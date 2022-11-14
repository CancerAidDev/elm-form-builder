module Form.Validate exposing
    ( validate, validateField, Error
    , isValid, isValidAgeInput
    , errorToMessage
    )

{-| Form.Validate


# Validate

@docs validate, validateField, Error


# Predicates

@docs isValid, isValidAgeInput


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
import Form.Lib.String as LibString
import Form.Locale as Locale
import Form.Validate.StringField as ValidateStringField
import Form.Validate.Types as StringFieldTypes
import Maybe.Extra as MaybeExtra
import Regex
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

        Field.NumericField_ numericField ->
            validateNumericField numericField
                |> Result.map
                    (\updatedValue ->
                        Field.NumericField_ (Field.updateNumericValue_ updatedValue numericField)
                    )
                |> Result.mapError NumericError_

        Field.ListStringField_ listStringField ->
            validateListStringField listStringField
                |> Result.map
                    (\updatedValue ->
                        Field.ListStringField_ (Field.updateListStringValue_ False updatedValue listStringField)
                    )
                |> Result.mapError ListStringError_


validateListStringField : Field.ListStringField -> Result ListStringError String
validateListStringField field =
    if List.isEmpty (Field.getListStringValue_ field) && Field.isRequired (Field.ListStringField_ field) == Required.Yes then
        Err EmptyListError

    else
        Ok ""


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


validateNumericField : Field.NumericField -> Result NumericError (Maybe Int)
validateNumericField (Field.AgeField properties) =
    if properties.required == Required.Yes then
        let
            regex =
                "^(1[89]|[2-9][0-9])$"
                    |> Regex.fromString
                    |> Maybe.withDefault Regex.never
        in
        if Regex.contains regex (LibString.fromMaybeInt properties.value) then
            Ok properties.value

        else
            Err InvalidAge

    else
        Ok properties.value


{-| -}
isValidAgeInput : Maybe Int -> Bool
isValidAgeInput age =
    let
        regex =
            "^(|[1-9]|1[89]|[2-9][0-9])$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never
    in
    if Regex.contains regex (LibString.fromMaybeInt age) then
        True

    else
        False


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


type NumericError
    = InvalidAge


type ListStringError
    = EmptyListError


{-| -}
type Error
    = StringError_ Field.StringField StringFieldTypes.StringFieldError
    | MultiStringError_ MultiStringError
    | BoolError_ BoolError
    | NumericError_ NumericError
    | ListStringError_ ListStringError


{-| -}
errorToMessage : Locale.Locale -> Error -> String
errorToMessage locale error =
    case error of
        StringError_ field err ->
            ValidateStringField.errorToMessage locale field err

        MultiStringError_ NoneSelectedError ->
            "At least one selection is required"

        BoolError_ ConsentIsRequired ->
            "Consent is required"

        BoolError_ EmptyBoolError ->
            "Field is required"

        NumericError_ InvalidAge ->
            "Age must be 18-99"

        ListStringError_ EmptyListError ->
            "Field must not be empty"
