module Form.Validate.DateSpec exposing (suite)

import Dict
import Expect
import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.Required as Required
import Form.Locale as Locale
import Form.Validate as Validate
import Form.Validate.HelperSpec as HelperSpec
import Form.Validate.StringField as StringField
import Form.Validate.Types as Types
import Test
import Time


suite : Test.Test
suite =
    Test.describe "Form.Validate.Date"
        [ Test.describe "validate"
            [ HelperSpec.simpleFieldTest (FieldType.DateType FieldType.datePast)
                (HelperSpec.dateField FieldType.datePast)
                { valid = [ { value = "2022-05-30", name = "Simple date" } ]
                , invalid =
                    [ { value = "asdf", error = Types.InvalidDate, name = "Text as date" }
                    , { value = "2024-06-01", error = Types.DateTooLate "2024-05-31", name = "Today" }
                    , { value = "1904-05-31", error = Types.DateTooEarly "1904-06-01", name = "Over 120 years ago" }
                    ]
                , locale = Locale.enAU
                }
            , HelperSpec.simpleFieldTest (FieldType.DateType FieldType.dateOfBirth)
                (HelperSpec.dateField FieldType.dateOfBirth)
                { valid =
                    [ { value = "2022-05-30", name = "Simple date" }
                    , { value = "2024-06-01", name = "Today" }
                    , { value = "1904-06-01", name = "120 years ago" }
                    , { value = "1980-02-01T00:00:00Z", name = "Timestamp" }
                    , { value = "2000-02-29", name = "Leap day" }
                    ]
                , invalid =
                    [ { value = "asdf", error = Types.InvalidDate, name = "Text as date" }
                    , { value = "30/05/2022", error = Types.InvalidDate, name = "Incomplete conversion" }
                    , { value = "30/05/20", error = Types.InvalidDate, name = "Incomplete date" }
                    , { value = "1980-02-31", error = Types.InvalidDate, name = "Impossible date" }
                    , { value = "1900-02-29", error = Types.InvalidDate, name = "Not a leap year" }
                    , { value = "2024-06-02", error = Types.DateTooLate "2024-06-01", name = "Future date" }
                    , { value = "1904-05-31", error = Types.DateTooEarly "1904-06-01", name = "Over 120 years ago" }
                    , { value = "1980-02-00", error = Types.InvalidDate, name = "Day 00" }
                    , { value = "1980-00-01", error = Types.InvalidDate, name = "Month 00" }
                    , { value = "2024-06-02T05:00:00+10:00", error = Types.DateTooLate "2024-06-01", name = "Tomorrow with an offset" }
                    ]
                , locale = Locale.enAU
                }
            , HelperSpec.simpleFieldTest (FieldType.DateType maskedDatePast)
                (HelperSpec.dateField maskedDatePast)
                { valid = [ { value = "2022-05-30", name = "Simple date" } ]
                , invalid =
                    [ { value = "30/05/2022", error = Types.InvalidDate, name = "Incomplete conversion" }
                    , { value = "1980-02-31", error = Types.InvalidDate, name = "Impossible date" }
                    , { value = "2024-06-01", error = Types.DateTooLate "2024-05-31", name = "Today" }
                    ]
                , locale = Locale.enAU
                }
            , HelperSpec.simpleFieldTest (FieldType.DateType FieldType.dateFuture)
                (HelperSpec.dateField FieldType.dateFuture)
                { valid = [ { value = "2025-05-30", name = "Simple date" } ]
                , invalid =
                    [ { value = "asdf", error = Types.InvalidDate, name = "Text as date" }
                    , { value = "2024-06-01", error = Types.DateTooEarly "2024-06-02", name = "Today" }
                    ]
                , locale = Locale.enAU
                }
            , HelperSpec.simpleFieldTest (FieldType.DateType FieldType.dateDefault)
                (HelperSpec.dateField FieldType.dateDefault)
                { valid = [ { value = "2022-05-30", name = "Simple date" } ]
                , invalid = [ { value = "asdf", error = Types.InvalidDate, name = "Text as date" } ]
                , locale = Locale.enAU
                }
            ]
        , Test.describe "today in the user's zone"
            [ -- 2024-06-01 07:00 in Sydney, 2024-05-31 in UTC
              zoneTest "date of birth today in Sydney" sydney (Time.millisToPosix 1717189200000) FieldType.dateOfBirth "2024-06-01" (Ok ())
            , zoneTest "date past yesterday in Sydney" sydney (Time.millisToPosix 1717189200000) FieldType.datePast "2024-05-31" (Ok ())
            , zoneTest "date past today in Sydney" sydney (Time.millisToPosix 1717189200000) FieldType.datePast "2024-06-01" (Err (Types.DateTooLate "2024-05-31"))

            -- 2024-06-01 18:00 in Los Angeles, 2024-06-02 in UTC
            , zoneTest "date future tomorrow in Los Angeles" losAngeles (Time.millisToPosix 1717290000000) FieldType.dateFuture "2024-06-02" (Ok ())
            , zoneTest "date future today in Los Angeles" losAngeles (Time.millisToPosix 1717290000000) FieldType.dateFuture "2024-06-01" (Err (Types.DateTooEarly "2024-06-02"))
            , zoneTest "date of birth tomorrow in Los Angeles" losAngeles (Time.millisToPosix 1717290000000) FieldType.dateOfBirth "2024-06-02" (Err (Types.DateTooLate "2024-06-01"))
            ]
        , Test.describe "range only on fields the user can see and edit"
            [ rangeTest "visible and enabled" identity False
            , rangeTest "hidden" Field.setHidden True
            , rangeTest "disabled" Field.setDisabled True
            ]
        , Test.describe "errorToMessage"
            [ errorMessageTest "date of birth invalid in en-AU" Locale.enAU FieldType.dateOfBirth Types.InvalidDate "Enter a valid date (DD/MM/YYYY)"
            , errorMessageTest "date of birth invalid in en-US" Locale.enUS FieldType.dateOfBirth Types.InvalidDate "Enter a valid date (MM/DD/YYYY)"
            , errorMessageTest "date of birth too late in en-AU" Locale.enAU FieldType.dateOfBirth (Types.DateTooLate "2024-06-01") "Date must be on or before 01/06/2024"
            , errorMessageTest "date of birth too early in en-US" Locale.enUS FieldType.dateOfBirth (Types.DateTooEarly "1904-01-02") "Date must be on or after 01/02/1904"
            , errorMessageTest "masked date past invalid in en-CA" Locale.enCA maskedDatePast Types.InvalidDate "Enter a valid date (YYYY-MM-DD)"
            , errorMessageTest "masked date past too late in en-AU" Locale.enAU maskedDatePast (Types.DateTooLate "2024-05-31") "Date must be on or before 31/05/2024"
            , errorMessageTest "date picker invalid" Locale.enAU FieldType.datePast Types.InvalidDate "Enter a valid date (YYYY-MM-DD)"
            , errorMessageTest "date picker too late" Locale.enAU FieldType.datePast (Types.DateTooLate "2024-05-31") "Date must be on or before 2024-05-31"
            ]
        ]


maskedDatePast : FieldType.DateFieldType
maskedDatePast =
    let
        datePast =
            FieldType.datePast
    in
    { datePast | input = FieldType.Masked }


errorMessageTest : String -> Locale.Locale -> FieldType.DateFieldType -> Types.StringFieldError -> String -> Test.Test
errorMessageTest name locale tipe error message =
    Test.test name <|
        \_ ->
            StringField.errorToMessage locale (HelperSpec.dateField tipe { required = Required.Yes, value = "" }) error
                |> Expect.equal message


{-| Whether a date past field holding today is valid.
-}
rangeTest : String -> (Field.DateFieldProperties -> Field.DateFieldProperties) -> Bool -> Test.Test
rangeTest name setEditability expected =
    Test.test name <|
        \_ ->
            let
                field =
                    Field.dateDefault
                        |> Field.setDatePast
                        |> Field.setValue "2024-06-01"
                        |> setEditability
                        |> Field.date
            in
            Validate.validateField Time.utc (Time.millisToPosix 1717200000000) Locale.enAU (Dict.singleton "date" field) field
                |> Result.toMaybe
                |> (/=) Nothing
                |> Expect.equal expected


sydney : Time.Zone
sydney =
    Time.customZone (10 * 60) []


losAngeles : Time.Zone
losAngeles =
    Time.customZone (-7 * 60) []


zoneTest : String -> Time.Zone -> Time.Posix -> FieldType.DateFieldType -> String -> Result Types.StringFieldError () -> Test.Test
zoneTest name zone time tipe value expected =
    Test.test name <|
        \_ ->
            HelperSpec.dateField tipe { required = Required.Yes, value = value }
                |> StringField.validate zone time Locale.enAU
                |> Result.map (always ())
                |> Expect.equal expected
