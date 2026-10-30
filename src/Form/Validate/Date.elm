module Form.Validate.Date exposing (dateValidator)

import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Format.Date as DateFormat
import Form.Lib.Time as LibTime
import Form.Validate.Types as ValidatorTypes
import Iso8601
import Maybe.Extra as MaybeExtra
import Time


{-| Validator API for ISO 8601 dates within the field's min and max dates.
-}
dateValidator : Time.Zone -> Time.Posix -> FieldType.DateFieldType -> ValidatorTypes.Validator
dateValidator zone time config _ field =
    let
        value =
            Field.getStringValue_ field

        -- Masked fields are checked against the date they show, ignoring any time after it
        date =
            case config.input of
                FieldType.Masked ->
                    DateFormat.toIsoDate value

                FieldType.Calendar ->
                    Just value
    in
    case date of
        Just dateValue ->
            Iso8601.toTime dateValue
                |> Result.mapError (always ValidatorTypes.InvalidDate)
                |> Result.andThen (rangeValidator zone time config)
                |> Result.map (\v -> Field.updateParsedDateValue v field)

        Nothing ->
            Err ValidatorTypes.InvalidDate


{-| Bounds are compared as dates, worked out by `FieldType.dateConfigToString`. The value is a date without a time, so it's parsed as UTC midnight.
-}
rangeValidator : Time.Zone -> Time.Posix -> FieldType.DateFieldType -> Time.Posix -> Result ValidatorTypes.StringFieldError Time.Posix
rangeValidator zone time { min, max } value =
    let
        date =
            LibTime.toDateString value

        toDate =
            Maybe.map (FieldType.dateConfigToString zone time)

        tooEarly =
            toDate min
                |> MaybeExtra.filter (\earliest -> date < earliest)
                |> Maybe.map ValidatorTypes.DateTooEarly

        tooLate =
            toDate max
                |> MaybeExtra.filter (\latest -> date > latest)
                |> Maybe.map ValidatorTypes.DateTooLate
    in
    [ tooEarly
    , tooLate
    ]
        |> MaybeExtra.orList
        |> Maybe.map Err
        |> Maybe.withDefault (Ok value)
