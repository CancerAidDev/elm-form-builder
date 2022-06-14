module Form.Validate.StringField exposing (StringError(..), errorToMessage, validate)

import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.Option as Option
import Form.Locale as Locale
import Form.Locale.Phone as Phone
import Iso8601
import Regex
import RemoteData
import Url


type StringError
    = EmptyError
    | InvalidOption
    | InvalidMobilePhoneNumber
    | InvalidPhoneNumber
    | InvalidEmail
    | InvalidDate
    | InvalidUrl


errorToMessage : StringError -> String
errorToMessage error =
    case error of
        EmptyError ->
            "Field is required"

        InvalidOption ->
            "Invalid option"

        InvalidMobilePhoneNumber ->
            "Invalid mobile number"

        InvalidPhoneNumber ->
            "Invalid phone number"

        InvalidEmail ->
            "Invalid email address"

        InvalidDate ->
            -- Only old browsers without a date picker should trigger this error
            "Date format should be YYYY-MM-DD"

        InvalidUrl ->
            "Invalid url"


emailValidator : String -> Result StringError String
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


urlValidator : String -> Result StringError String
urlValidator value =
    case Url.fromString value of
        Just _ ->
            Ok value

        Nothing ->
            Err InvalidUrl


dateValidator : String -> Result StringError String
dateValidator value =
    Iso8601.toTime value
        |> Result.map Iso8601.fromTime
        |> Result.mapError (always InvalidDate)


phoneValidator : Locale.Locale -> String -> Result StringError String
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


optionsValidator : String -> List Option.Option -> Result StringError String
optionsValidator value options =
    if List.map .value options |> List.member value then
        Ok value

    else
        Err InvalidOption


remoteOptionsValidator : String -> RemoteData.RemoteData err (List Option.Option) -> Result StringError String
remoteOptionsValidator value options =
    options
        |> RemoteData.map (optionsValidator value)
        |> RemoteData.withDefault (Err InvalidOption)


validate : Locale.Locale -> Field.StringField -> Result StringError String
validate locale field =
    let
        trimmed =
            String.trim (Field.getStringValue_ field)
    in
    if String.isEmpty trimmed then
        if Field.isNullable field then
            Ok trimmed

        else if Field.isRequired (Field.StringField_ field) then
            Err EmptyError

        else
            Ok trimmed

    else
        stringValidator locale (Field.updateStringValue_ trimmed field)


stringValidator : Locale.Locale -> Field.StringField -> Result StringError String
stringValidator locale field =
    case field of
        Field.SimpleField { tipe, value } ->
            case tipe of
                FieldType.Email ->
                    emailValidator value

                FieldType.Date _ ->
                    dateValidator value

                FieldType.Phone ->
                    phoneValidator locale value

                FieldType.Url ->
                    urlValidator value

                FieldType.Text ->
                    Ok value

                FieldType.TextArea ->
                    Ok value

        Field.SelectField { value, options } ->
            optionsValidator value options

        Field.HttpSelectField { value, options } ->
            remoteOptionsValidator value options

        Field.RadioField { value, options } ->
            optionsValidator value options
