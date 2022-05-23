module Form.Validate exposing
    ( validate, validateField
    , isValid, isValidAgeInput
    , errorToMessage
    )

{-| Form.Validate


# Validate

@docs validate, validateField


# Predicates

@docs isValid, isValidAgeInput


# Errors

@docs errorToMessage

-}

import Dict
import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.RadioEnum as RadioEnum
import Form.Fields as Fields
import Form.Lib.String as LibString
import Form.Locale as Locale
import Form.Locale.Phone as Phone
import Iso8601
import Maybe.Extra as MaybeExtra
import Regex
import Url


{-| -}
validateField : Locale.Locale -> Fields.Fields -> Field.Field -> Result Error Field.Field
validateField locale fields field =
    case field of
        Field.StringField_ stringField ->
            validateStringField locale stringField
                |> Result.map
                    (\updatedValue ->
                        Field.StringField_ (Field.updateStringValue_ updatedValue stringField)
                    )
                |> Result.mapError StringError_

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


validateStringField : Locale.Locale -> Field.StringField -> Result StringError String
validateStringField locale field =
    String.trim (Field.getStringValue_ field)
        |> emptyValidator (Field.isRequired (Field.StringField_ field))
        |> Result.andThen (stringValidator locale (Field.getStringType field))


validateBoolField : Field.CheckboxFieldProperties -> Result BoolError Bool
validateBoolField properties =
    if properties.tipe == FieldType.Checkbox then
        Ok properties.value

    else if properties.value == True then
        Ok True

    else
        Err ConsentIsRequired


validateRadioBoolField : Fields.Fields -> Field.Field -> Field.MaybeBoolFieldProperties -> Result BoolError (Maybe Bool)
validateRadioBoolField fields field properties =
    if Fields.isEnabled fields field && properties.required then
        case properties.value of
            Nothing ->
                Err EmptyBoolError

            _ ->
                Ok properties.value

    else
        Ok properties.value


validateRadioEnumField : Field.MaybeEnumFieldProperties -> Result BoolError (Maybe RadioEnum.Value)
validateRadioEnumField properties =
    if properties.required then
        case properties.value of
            Nothing ->
                Err EmptyBoolError

            _ ->
                Ok properties.value

    else
        Ok properties.value


validateNumericField : Field.NumericField -> Result NumericError (Maybe Int)
validateNumericField (Field.AgeField properties) =
    if properties.required then
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


type StringError
    = EmptyError
    | InvalidMobilePhoneNumber
    | InvalidPhoneNumber
    | InvalidEmail
    | InvalidDate
    | InvalidUrl


type BoolError
    = ConsentIsRequired
    | EmptyBoolError


type NumericError
    = InvalidAge


type Error
    = StringError_ StringError
    | BoolError_ BoolError
    | NumericError_ NumericError


{-| -}
errorToMessage : Field.Field -> Error -> String
errorToMessage field error =
    case error of
        StringError_ EmptyError ->
            Field.getLabel field ++ " is required"

        StringError_ InvalidMobilePhoneNumber ->
            Field.getLabel field ++ " is not a valid mobile number"

        StringError_ InvalidPhoneNumber ->
            Field.getLabel field ++ " is not a valid phone number"

        StringError_ InvalidEmail ->
            Field.getLabel field ++ " is not a valid email address"

        StringError_ InvalidDate ->
            -- Only old browsers without a date picker should trigger this error
            Field.getLabel field ++ " format should be YYYY-MM-DD"

        StringError_ InvalidUrl ->
            Field.getLabel field ++ " is not a valid url"

        BoolError_ ConsentIsRequired ->
            "Consent is required"

        BoolError_ EmptyBoolError ->
            Field.getLabel field ++ " is required"

        NumericError_ InvalidAge ->
            Field.getLabel field ++ " must be 18-99"


type alias StringValidator =
    String -> Result StringError String


emptyValidator : Bool -> StringValidator
emptyValidator required value =
    if String.isEmpty value && required then
        Err EmptyError

    else
        Ok value


emailValidator : StringValidator
emailValidator value =
    let
        regex =
            "^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never
    in
    if Regex.contains regex value then
        Ok value

    else
        Err InvalidEmail


urlValidator : StringValidator
urlValidator value =
    case Url.fromString value of
        Just _ ->
            Ok value

        Nothing ->
            Err InvalidUrl


dateValidator : StringValidator
dateValidator value =
    Iso8601.toTime value
        |> Result.map Iso8601.fromTime
        |> Result.mapError (always InvalidDate)


phoneValidator : Locale.Locale -> StringValidator
phoneValidator (Locale.Locale _ code) value =
    let
        normalisedValue =
            value |> String.words |> String.concat
    in
    if Regex.contains (Phone.mobileRegex code) normalisedValue then
        Ok (Phone.formatForSubmission code normalisedValue)

    else if Regex.contains (Phone.regex code) normalisedValue then
        Err InvalidMobilePhoneNumber

    else
        Err InvalidPhoneNumber


stringValidator : Locale.Locale -> FieldType.StringFieldType -> StringValidator
stringValidator locale fieldType =
    case fieldType of
        FieldType.SimpleType FieldType.Email ->
            emailValidator

        FieldType.SimpleType (FieldType.Date _) ->
            dateValidator

        FieldType.SimpleType FieldType.Phone ->
            phoneValidator locale

        FieldType.SimpleType FieldType.Url ->
            urlValidator

        _ ->
            Ok
