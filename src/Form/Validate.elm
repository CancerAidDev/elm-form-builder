module Form.Validate exposing
    ( validate, validateField, Error
    , isValid
    , errorToMessage
    )

{-| Form.Validate


# Validate

@docs validate, validateField, Error


# Predicates

@docs isValid


# Errors

@docs errorToMessage

-}

import Dict
import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.RadioEnum as RadioEnum
import Form.Field.Required as Required
import Form.Fields as Fields
import Form.Format.ForSubmission as ForSubmission
import Form.Locale as Locale
import Form.Locale.CountryCode as CountryCode
import Form.Validate.StringField as ValidateStringField
import Form.Validate.Types as StringFieldTypes
import Maybe.Extra as MaybeExtra
import Set


{-| -}
validateField : Locale.Locale -> Fields.Fields -> Field.Field -> Result Error Field.Field
validateField locale fields field =
    case field of
        Field.StringField_ stringField ->
            ValidateStringField.validate locale stringField
                |> Result.map
                    (\validField ->
                        Field.StringField_ (Field.updateStringValue_ (ForSubmission.formatForSubmission locale validField) stringField)
                    )
                |> Result.mapError (StringError_ stringField)

        Field.MultiStringField_ multiStringField ->
            validateMultiStringField multiStringField
                |> Result.map
                    (\updatedValue ->
                        Field.MultiStringField_ (Field.updateMultiStringValue_ updatedValue multiStringField)
                    )
                |> Result.mapError MultiStringError_

        Field.BoolField_ (Field.CheckboxField properties) ->
            validateBoolField properties
                |> Result.map
                    (\updatedValue ->
                        Field.BoolField_
                            (Field.updateCheckboxValue_
                                updatedValue
                                (Field.CheckboxField properties)
                            )
                    )
                |> Result.mapError BoolError_

        Field.BoolField_ (Field.RadioBoolField properties) ->
            validateRadioBoolField fields field properties
                |> Result.map
                    (\updatedValue ->
                        Field.BoolField_
                            (Field.updateRadioBoolValue_
                                updatedValue
                                (Field.RadioBoolField properties)
                            )
                    )
                |> Result.mapError BoolError_

        Field.BoolField_ (Field.RadioEnumField properties) ->
            validateRadioEnumField properties
                |> Result.map
                    (\updatedValue ->
                        Field.BoolField_
                            (Field.updateRadioEnumValue_
                                updatedValue
                                (Field.RadioEnumField properties)
                            )
                    )
                |> Result.mapError BoolError_

        Field.IntegerField_ properties ->
            validateIntegerField properties
                |> Result.map
                    (\updatedValue ->
                        Field.IntegerField_ (Field.updateIntegerValue_ updatedValue properties)
                    )
                |> Result.mapError IntegerError_


validateMultiStringField : Field.MultiStringField -> Result MultiStringError (Set.Set String)
validateMultiStringField field =
    if Set.isEmpty (Field.getMultiStringValue_ field) && Field.isRequired (Field.MultiStringField_ field) == Required.Yes then
        Err NoneSelectedError

    else
        Ok (Field.getMultiStringValue_ field)


validateBoolField : Field.CheckboxFieldProperties -> Result BoolError Bool
validateBoolField properties =
    if properties.tipe == FieldType.Checkbox then
        Ok properties.value

    else if properties.value == True then
        Ok True

    else
        Err ConsentIsRequired


validateRadioBoolField : Fields.Fields -> Field.Field -> Field.RadioBoolFieldProperties -> Result BoolError (Maybe Bool)
validateRadioBoolField fields field properties =
    if Fields.isEnabled fields field && properties.required == Required.Yes then
        case properties.value of
            Nothing ->
                Err EmptyBoolError

            _ ->
                Ok properties.value

    else
        Ok properties.value


validateRadioEnumField : Field.RadioEnumFieldProperties -> Result BoolError (Maybe RadioEnum.Value)
validateRadioEnumField properties =
    if properties.required == Required.Yes then
        case properties.value of
            Nothing ->
                Err EmptyBoolError

            _ ->
                Ok properties.value

    else
        Ok properties.value


validateIntegerField : Field.IntegerField -> Result IntegerError (Maybe Int)
validateIntegerField (Field.IntegerField properties) =
    case properties.value of
        Just value ->
            case ( properties.tipe.min, properties.tipe.max ) of
                ( Just min, Just max ) ->
                    if min <= value && value <= max then
                        Ok properties.value

                    else
                        Err (GreaterThanMaxOrLessThanMin min max)

                ( Just min, Nothing ) ->
                    if min <= value then
                        Ok properties.value

                    else
                        Err (LessThanMin min)

                ( Nothing, Just max ) ->
                    if value <= max then
                        Ok properties.value

                    else
                        Err (GreaterThanMax max)

                ( Nothing, Nothing ) ->
                    Ok properties.value

        Nothing ->
            if properties.required == Required.Yes then
                Err EmptyIntegerError

            else
                Ok properties.value


{-| -}
validate : Locale.Locale -> Fields.Fields -> Maybe Fields.Fields
validate locale fields =
    fields
        |> Dict.foldl
            (\key field acc ->
                Result.toMaybe (validateField locale fields field)
                    |> Maybe.andThen (\value -> Maybe.map (Dict.insert key value) acc)
            )
            (Just Dict.empty)


{-| -}
isValid : Locale.Locale -> Fields.Fields -> Bool
isValid locale =
    validate locale >> MaybeExtra.isJust


type MultiStringError
    = NoneSelectedError


type BoolError
    = ConsentIsRequired
    | EmptyBoolError


type IntegerError
    = GreaterThanMax Int
    | LessThanMin Int
    | GreaterThanMaxOrLessThanMin Int Int
    | EmptyIntegerError


{-| -}
type Error
    = StringError_ Field.StringField StringFieldTypes.StringFieldError
    | MultiStringError_ MultiStringError
    | BoolError_ BoolError
    | IntegerError_ IntegerError


{-| -}
errorToMessage : Maybe CountryCode.CountryCode -> Error -> String
errorToMessage code error =
    case error of
        StringError_ field err ->
            ValidateStringField.errorToMessage code field err

        MultiStringError_ NoneSelectedError ->
            "At least one selection is required"

        BoolError_ ConsentIsRequired ->
            "Consent is required"

        BoolError_ EmptyBoolError ->
            "Field is required"

        IntegerError_ (GreaterThanMax max) ->
            "Must be less than " ++ String.fromInt max

        IntegerError_ (LessThanMin min) ->
            "Must be greater than " ++ String.fromInt min

        IntegerError_ (GreaterThanMaxOrLessThanMin min max) ->
            "Must be between " ++ String.fromInt min ++ " and " ++ String.fromInt max

        IntegerError_ EmptyIntegerError ->
            "Field is required"
