module Form.Field.DateSpec exposing (suite)

import Expect
import Form.Field as Field
import Form.Field.FieldType as FieldType
import Test
import Time
import Time.Extra as TimeExtra


suite : Test.Test
suite =
    let
        -- 2026-01-01T00:00Z
        newYear =
            Time.millisToPosix 1767225600000

        newYork =
            Time.customZone (-5 * 60) []
    in
    Test.describe "Date fields"
        [ Test.describe "dateConfigToString"
            [ Test.test "absolute dates are in UTC" <|
                \_ ->
                    FieldType.dateConfigToString newYork newYear (FieldType.DateAbsolute newYear)
                        |> Expect.equal "2026-01-01"
            , Test.test "year offsets are to the day" <|
                \_ ->
                    FieldType.dateConfigToString Time.utc (Time.millisToPosix 1782864000000) (FieldType.DateOffset ( TimeExtra.Year, -18 ))
                        |> Expect.equal "2008-07-01"
            , Test.test "offsets are in the given zone" <|
                \_ ->
                    FieldType.dateConfigToString newYork newYear (FieldType.DateOffset ( TimeExtra.Day, 0 ))
                        |> Expect.equal "2025-12-31"
            ]
        , Test.describe "setters"
            [ Test.test "range presets keep the date input" <|
                \_ ->
                    Field.dateDefault
                        |> Field.setDateInput FieldType.Masked
                        |> Field.setDatePast
                        |> .tipe
                        |> .input
                        |> Expect.equal FieldType.Masked
            , Test.test "date of birth is masked" <|
                \_ ->
                    Field.dateDefault
                        |> Field.setDateInput FieldType.Calendar
                        |> Field.setDateOfBirth
                        |> .tipe
                        |> .input
                        |> Expect.equal FieldType.Masked
            , Test.test "date input can be changed after a preset" <|
                \_ ->
                    Field.dateDefault
                        |> Field.setDateOfBirth
                        |> Field.setDateInput FieldType.Calendar
                        |> .tipe
                        |> .input
                        |> Expect.equal FieldType.Calendar
            ]
        ]
