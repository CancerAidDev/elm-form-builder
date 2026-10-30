module Form.Format.DateSpec exposing (suite)

import Expect
import Form.Format.Date as Date
import Form.Locale.CountryCode as CountryCode
import Test


suite : Test.Test
suite =
    Test.describe "Form.Format.Date"
        [ Test.describe "placeholder"
            [ Test.test "en-AU" <| \_ -> Date.placeholder (Just CountryCode.AU) |> Expect.equal "DD/MM/YYYY"
            , Test.test "en-NZ" <| \_ -> Date.placeholder (Just CountryCode.NZ) |> Expect.equal "DD/MM/YYYY"
            , Test.test "en-US" <| \_ -> Date.placeholder (Just CountryCode.US) |> Expect.equal "MM/DD/YYYY"
            , Test.test "en-CA" <| \_ -> Date.placeholder (Just CountryCode.CA) |> Expect.equal "YYYY-MM-DD"
            ]
        , Test.describe "orderDescription"
            [ Test.test "en-AU" <| \_ -> Date.orderDescription (Just CountryCode.AU) |> Expect.equal "day, month, year"
            , Test.test "en-US" <| \_ -> Date.orderDescription (Just CountryCode.US) |> Expect.equal "month, day, year"
            , Test.test "en-CA" <| \_ -> Date.orderDescription (Just CountryCode.CA) |> Expect.equal "year, month, day"
            ]
        , Test.describe "placeholderWhileTyping"
            [ Test.test "Empty" <| \_ -> Date.placeholderWhileTyping (Just CountryCode.AU) "" |> Expect.equal ""
            , Test.test "Partial day" <| \_ -> Date.placeholderWhileTyping (Just CountryCode.AU) "1" |> Expect.equal "1D/MM/YYYY"
            , Test.test "Day and separator" <| \_ -> Date.placeholderWhileTyping (Just CountryCode.AU) "15/" |> Expect.equal "15/MM/YYYY"
            , Test.test "Partial year" <| \_ -> Date.placeholderWhileTyping (Just CountryCode.AU) "15/02/19" |> Expect.equal "15/02/19YY"
            , Test.test "en-US" <| \_ -> Date.placeholderWhileTyping (Just CountryCode.US) "02/" |> Expect.equal "02/DD/YYYY"
            , Test.test "en-CA" <| \_ -> Date.placeholderWhileTyping (Just CountryCode.CA) "1980-0" |> Expect.equal "1980-0M-DD"
            , Test.test "Complete date" <| \_ -> Date.placeholderWhileTyping (Just CountryCode.AU) "15/02/1980" |> Expect.equal ""
            , Test.test "Unpadded day while editing" <| \_ -> Date.placeholderWhileTyping (Just CountryCode.AU) "1/02/1980" |> Expect.equal ""
            , Test.test "Unpadded day" <| \_ -> Date.placeholderWhileTyping (Just CountryCode.AU) "1/3" |> Expect.equal "1/3M/YYYY"
            , Test.test "Unpadded day and separator" <| \_ -> Date.placeholderWhileTyping (Just CountryCode.AU) "1/" |> Expect.equal "1/MM/YYYY"
            , Test.test "Too many digits in a group" <| \_ -> Date.placeholderWhileTyping (Just CountryCode.AU) "315/02/1980" |> Expect.equal ""
            , Test.test "Missing separator" <| \_ -> Date.placeholderWhileTyping (Just CountryCode.AU) "1502/1980" |> Expect.equal ""
            ]
        , Test.describe "toDisplay"
            [ Test.test "ISO date in en-AU" <| \_ -> Date.toDisplay (Just CountryCode.AU) "1980-02-01" |> Expect.equal "01/02/1980"
            , Test.test "ISO date in en-US" <| \_ -> Date.toDisplay (Just CountryCode.US) "1980-02-01" |> Expect.equal "02/01/1980"
            , Test.test "ISO date in en-CA" <| \_ -> Date.toDisplay (Just CountryCode.CA) "1980-02-01" |> Expect.equal "1980-02-01"
            , Test.test "ISO timestamp" <| \_ -> Date.toDisplay (Just CountryCode.AU) "1980-02-01T00:00:00.000Z" |> Expect.equal "01/02/1980"
            , Test.test "Empty" <| \_ -> Date.toDisplay (Just CountryCode.AU) "" |> Expect.equal ""
            ]
        , Test.describe "toIsoDate"
            [ Test.test "Date" <| \_ -> Date.toIsoDate "1980-02-01" |> Expect.equal (Just "1980-02-01")
            , Test.test "Timestamp" <| \_ -> Date.toIsoDate "1980-02-01T10:00:00Z" |> Expect.equal (Just "1980-02-01")
            , Test.test "Leap day" <| \_ -> Date.toIsoDate "2000-02-29" |> Expect.equal (Just "2000-02-29")
            , Test.test "Not a leap year" <| \_ -> Date.toIsoDate "1900-02-29" |> Expect.equal Nothing
            , Test.test "Impossible day" <| \_ -> Date.toIsoDate "1980-04-31" |> Expect.equal Nothing
            , Test.test "Impossible month" <| \_ -> Date.toIsoDate "1980-13-01" |> Expect.equal Nothing
            , Test.test "Display format" <| \_ -> Date.toIsoDate "01/02/1980" |> Expect.equal Nothing
            , Test.test "Day 00" <| \_ -> Date.toIsoDate "1980-02-00" |> Expect.equal Nothing
            , Test.test "Month 00" <| \_ -> Date.toIsoDate "1980-00-01" |> Expect.equal Nothing
            ]
        , Test.describe "fromInput"
            [ inputTest "en-AU complete date" CountryCode.AU "" "01/02/1980" "1980-02-01"
            , inputTest "en-AU digits only" CountryCode.AU "" "01021980" "1980-02-01"
            , inputTest "en-NZ complete date" CountryCode.NZ "" "01/02/1980" "1980-02-01"
            , inputTest "en-US complete date" CountryCode.US "" "02/01/1980" "1980-02-01"
            , inputTest "en-CA complete date" CountryCode.CA "" "19800201" "1980-02-01"
            , inputTest "first digit" CountryCode.AU "" "0" "0"
            , inputTest "adds separator after day" CountryCode.AU "0" "01" "01/"
            , inputTest "adds separator after month" CountryCode.AU "01/" "01/02" "01/02/"
            , inputTest "adds separator after year in en-CA" CountryCode.CA "198" "1980" "1980-"
            , inputTest "ignores typed separator after complete group" CountryCode.AU "01/" "01//" "01/"
            , inputTest "pads a single digit day when a separator is typed" CountryCode.AU "1" "1/" "01/"
            , inputTest "pads a single digit day when a space is typed" CountryCode.AU "1" "1 " "01/"
            , inputTest "deleting the separator doesn't re-add it" CountryCode.AU "01/" "01" "01"
            , inputTest "deleting the second separator doesn't re-add it" CountryCode.AU "01/02/" "01/02" "01/02"
            , inputTest "deleting a digit keeps the separator before it" CountryCode.AU "01/0" "01/" "01/"
            , inputTest "deleting from a complete date" CountryCode.AU "1980-02-01" "01/02/198" "01/02/198"
            , inputTest "pads single digit day and month" CountryCode.AU "" "1/2/1980" "1980-02-01"
            , inputTest "pads single digit month in en-US" CountryCode.US "" "2/1/1980" "1980-02-01"
            , inputTest "ignores letters" CountryCode.AU "" "0a1b" "01/"
            , inputTest "ignores extra digits" CountryCode.AU "" "010219801" "1980-02-01"
            , inputTest "keeps an impossible date as typed" CountryCode.AU "" "31/02/1980" "31/02/1980"
            , inputTest "keeps an impossible date as typed in en-CA" CountryCode.CA "" "1980-02-31" "1980-02-31"
            , inputTest "accepts a pasted ISO date in en-AU" CountryCode.AU "" "1980-02-01" "1980-02-01"
            , inputTest "accepts a pasted ISO date in en-US" CountryCode.US "" "1980-02-01" "1980-02-01"
            , inputTest "empty" CountryCode.AU "01/" "" ""
            , inputTest "deleting a day digit in the middle isn't padded" CountryCode.AU "1980-02-15" "1/02/1980" "1/02/1980"
            , inputTest "retyping the day digit completes the date" CountryCode.AU "1/02/1980" "16/02/1980" "1980-02-16"
            , inputTest "replacing the month in the middle isn't padded" CountryCode.US "1980-02-01" "1/01/1980" "1/01/1980"
            , inputTest "pasting over a date pads single digits" CountryCode.AU "1990-01-01" "3/4/1990" "1990-04-03"
            , inputTest "day 00 is kept as typed" CountryCode.AU "00/02/198" "00/02/1980" "00/02/1980"
            , inputTest "typing a digit into a full part in the middle is ignored" CountryCode.AU "1980-02-15" "315/02/1980" "1980-02-15"
            , inputTest "deleting a separator in the middle is ignored" CountryCode.AU "1980-02-15" "1502/1980" "1980-02-15"
            , inputTest "typing a separator inside the year is ignored" CountryCode.AU "2000-01-01" "01/01/20/00" "2000-01-01"
            , inputTest "typing a letter in the middle is ignored" CountryCode.AU "1/02/1980" "1a/02/1980" "1/02/1980"
            , inputTest "deleting a digit in the middle of a partial date" CountryCode.AU "12/3" "1/3" "1/3"
            , inputTest "replacing the month in the middle completes the date" CountryCode.AU "15/0/1980" "15/03/1980" "1980-03-15"
            , inputTest "pasted date with single digit day in en-CA" CountryCode.CA "" "1980-1-2" "1980-01-02"
            , inputTest "pasted ISO date with a time" CountryCode.AU "" "1980-01-02T00:00:00Z" "1980-01-02"
            , inputTest "pasted ISO date with spaces" CountryCode.AU "" " 1980-01-02 " "1980-01-02"
            ]
        , Test.describe "fromBlur"
            [ blurTest "pads single digit day and month" CountryCode.AU "1/3/1980" "1980-03-01"
            , blurTest "pads single digit month in en-US" CountryCode.US "3/1/1980" "1980-03-01"
            , blurTest "pads single digit day in en-CA" CountryCode.CA "1980-3-2" "1980-03-02"
            , blurTest "pads a partial date" CountryCode.AU "12/3" "12/03"
            , blurTest "leaves a group with too many digits" CountryCode.AU "315/02/1980" "315/02/1980"
            , blurTest "leaves an ISO date" CountryCode.AU "1980-03-01" "1980-03-01"
            , blurTest "leaves an empty value" CountryCode.AU "" ""
            ]
        ]


blurTest : String -> CountryCode.CountryCode -> String -> String -> Test.Test
blurTest name code value expected =
    Test.test name <|
        \_ ->
            Date.fromBlur (Just code) value
                |> Expect.equal expected


inputTest : String -> CountryCode.CountryCode -> String -> String -> String -> Test.Test
inputTest name code previousValue input expected =
    Test.test name <|
        \_ ->
            Date.fromInput (Just code) previousValue input
                |> Expect.equal expected
