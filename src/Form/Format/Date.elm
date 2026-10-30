module Form.Format.Date exposing (formatForSubmission, fromBlur, fromInput, orderDescription, placeholder, placeholderWhileTyping, toDisplay, toIsoDate)

{-| Formatting for date fields.

Masked date fields store a complete, valid date as an ISO 8601 date (`YYYY-MM-DD`), and anything else as the text that was typed. They are shown in the locale's date format:

  - US: `MM/DD/YYYY`
  - Canada: `YYYY-MM-DD`
  - Everywhere else: `DD/MM/YYYY`

-}

import Form.Lib.Time as LibTime
import Form.Locale.CountryCode as CountryCode
import Iso8601
import List.Extra as ListExtra
import Maybe.Extra as MaybeExtra
import Time


type DateOrder
    = DayMonthYear
    | MonthDayYear
    | YearMonthDay


type alias DateFormat =
    { order : DateOrder
    , separator : String
    }


formatForSubmission : CountryCode.CountryCode -> Time.Posix -> String
formatForSubmission _ value =
    Iso8601.fromTime value


toDateFormat : Maybe CountryCode.CountryCode -> DateFormat
toDateFormat code =
    case code of
        Just CountryCode.US ->
            { order = MonthDayYear, separator = "/" }

        Just CountryCode.CA ->
            { order = YearMonthDay, separator = "-" }

        _ ->
            { order = DayMonthYear, separator = "/" }


{-| Orders ( year, month, day ) into the display order.
-}
toOrder : DateOrder -> ( a, a, a ) -> List a
toOrder order ( year, month, day ) =
    case order of
        DayMonthYear ->
            [ day, month, year ]

        MonthDayYear ->
            [ month, day, year ]

        YearMonthDay ->
            [ year, month, day ]


{-| Inverse of `toOrder`.
-}
fromOrder : DateOrder -> List a -> Maybe ( a, a, a )
fromOrder order parts =
    case ( order, parts ) of
        ( DayMonthYear, [ day, month, year ] ) ->
            Just ( year, month, day )

        ( MonthDayYear, [ month, day, year ] ) ->
            Just ( year, month, day )

        ( YearMonthDay, [ year, month, day ] ) ->
            Just ( year, month, day )

        _ ->
            Nothing


{-| The placeholder letters for each part of the date, in the display order.
-}
partLetters : DateOrder -> List String
partLetters order =
    toOrder order ( "YYYY", "MM", "DD" )


{-| The number of digits in each part of the date, in the display order.
-}
partLengths : DateOrder -> List Int
partLengths order =
    List.map String.length (partLetters order)


{-| Pads a single digit day or month with a zero.
-}
padPart : Int -> String -> String
padPart length part =
    if length == 2 && String.length part == 1 then
        "0" ++ part

    else
        part


{-| Joins ( year, month, day ) into an ISO 8601 date (`YYYY-MM-DD`).
-}
fromIsoParts : ( String, String, String ) -> String
fromIsoParts ( year, month, day ) =
    String.join "-" [ year, month, day ]


{-| The locale's date format, e.g. `DD/MM/YYYY`.
-}
placeholder : Maybe CountryCode.CountryCode -> String
placeholder code =
    let
        { order, separator } =
            toDateFormat code
    in
    partLetters order
        |> String.join separator


{-| Whether the text could be all or the start of a date in the format: up to three groups of digits, each no longer than its part.
-}
fitsFormat : DateFormat -> String -> Bool
fitsFormat { order, separator } text =
    let
        groups =
            String.split separator text

        lengths =
            partLengths order

        partsFit =
            ListExtra.zip groups lengths
                |> List.all (\( group, length ) -> String.all Char.isDigit group && String.length group <= length)
    in
    List.length groups <= List.length lengths && partsFit


{-| The locale's date order in words, e.g. `day, month, year`, for screen readers, which read the placeholder letter by letter.
-}
orderDescription : Maybe CountryCode.CountryCode -> String
orderDescription code =
    toOrder (toDateFormat code).order ( "year", "month", "day" )
        |> String.join ", "


{-| The input value followed by the part of the placeholder not yet typed over, e.g. `15/MM/YYYY` after typing `15/`, or `1/3M/YYYY` after typing `1/3`, so the format stays visible while typing. Empty if nothing has been typed, the date is complete, or the input value doesn't fit the format.
-}
placeholderWhileTyping : Maybe CountryCode.CountryCode -> String -> String
placeholderWhileTyping code inputValue =
    let
        ({ order, separator } as format) =
            toDateFormat code

        groups =
            String.split separator inputValue

        typedCount =
            List.length groups

        earlierGroupsTyped =
            List.take (typedCount - 1) groups
                |> List.all (not << String.isEmpty)

        rest =
            partLetters order
                |> List.drop (typedCount - 1)
                |> String.join separator
                |> String.dropLeft (String.length (Maybe.withDefault "" (ListExtra.last groups)))
    in
    if inputValue /= "" && fitsFormat format inputValue && earlierGroupsTyped && rest /= "" then
        inputValue ++ rest

    else
        ""


{-| Splits a value starting with an ISO 8601 date into ( year, month, day ).
-}
isoParts : String -> Maybe ( String, String, String )
isoParts value =
    case String.split "-" (String.left 10 value) of
        [ year, month, day ] ->
            if List.map String.length [ year, month, day ] == [ 4, 2, 2 ] && List.all (String.all Char.isDigit) [ year, month, day ] then
                Just ( year, month, day )

            else
                Nothing

        _ ->
            Nothing


{-| The ISO 8601 date (`YYYY-MM-DD`) at the start of the value, if it is a real calendar date. Anything after the date (e.g. a time) is dropped.

The date must come back unchanged from `Iso8601.toTime`, which otherwise accepts day `00` as the last day of the previous month.

-}
toIsoDate : String -> Maybe String
toIsoDate value =
    isoParts value
        |> Maybe.map fromIsoParts
        |> MaybeExtra.filter (\isoDate -> Result.map LibTime.toDateString (Iso8601.toTime isoDate) == Ok isoDate)


{-| A date in the locale's date format, e.g. `01/02/1980`. An ISO 8601 date is shown in the locale's date order, and anything else is shown as is.
-}
toDisplay : Maybe CountryCode.CountryCode -> String -> String
toDisplay code value =
    let
        { order, separator } =
            toDateFormat code
    in
    isoParts value
        |> Maybe.map (toOrder order >> String.join separator)
        |> Maybe.withDefault value


{-| Value to store for text in the locale's date format: an ISO 8601 date if it's a complete, valid date, otherwise the text as is.
-}
toStored : DateFormat -> String -> String
toStored { order, separator } text =
    String.split separator text
        |> fromOrder order
        |> Maybe.andThen (fromIsoParts >> toIsoDate)
        |> Maybe.withDefault text


{-| Value to store for text typed into a masked date input, given the previously stored value.

Typing or deleting at the end, or pasting, groups the digits in the locale's date order, with separators added between groups. An edit in the middle is kept as typed if it still fits the format, as reformatting it would move the digits after it into other groups and move the cursor to the end. Otherwise (e.g. a separator typed inside the year) it's ignored.

A complete, valid date is stored as an ISO 8601 date. A pasted or autofilled ISO 8601 date (e.g. `1980-02-01`, or with a time) is accepted in any locale.

-}
fromInput : Maybe CountryCode.CountryCode -> String -> String -> String
fromInput code previousValue input =
    case toIsoDate (String.trim input) of
        Just isoDate ->
            isoDate

        Nothing ->
            let
                format =
                    toDateFormat code

                previousInputValue =
                    toDisplay code previousValue

                { inserted, unchangedAfter } =
                    edit previousInputValue input

                pasting =
                    inserted > 1

                text =
                    if unchangedAfter > 0 && not pasting then
                        if fitsFormat format input then
                            input

                        else
                            previousInputValue

                    else
                        mask format
                            { deleting = String.length input < String.length previousInputValue
                            , pasting = pasting
                            }
                            input
            in
            toStored format text


{-| Value to store when a masked date input loses focus: a single digit day or month is padded, so `1/3/1980` is stored as `1980-03-01`.
-}
fromBlur : Maybe CountryCode.CountryCode -> String -> String
fromBlur code value =
    let
        ({ order, separator } as format) =
            toDateFormat code

        groups =
            String.split separator (toDisplay code value)

        lengths =
            partLengths order
    in
    if List.length groups <= List.length lengths && List.all (String.all Char.isDigit) groups then
        List.map2 padPart lengths groups
            |> String.join separator
            |> toStored format

    else
        value


{-| How `before` was edited to give `after`: the number of characters inserted (more than one means it was pasted or autofilled rather than typed), and the number unchanged after the edit (more than zero means it was in the middle).
-}
edit : String -> String -> { inserted : Int, unchangedAfter : Int }
edit before after =
    let
        commonLength : List Char -> List Char -> Int
        commonLength xs ys =
            ListExtra.zip xs ys
                |> ListExtra.takeWhile (\( x, y ) -> x == y)
                |> List.length

        prefix =
            commonLength (String.toList before) (String.toList after)

        reversedRest text =
            List.reverse (String.toList (String.dropLeft prefix text))

        suffix =
            commonLength (reversedRest before) (reversedRest after)
    in
    { inserted = String.length after - prefix - suffix
    , unchangedAfter = suffix
    }


type alias MaskState =
    { groups : List String
    , current : String
    }


isSeparator : Char -> Bool
isSeparator char =
    List.member char [ '/', '-', '.', ' ' ]


{-| Groups the digits of the input in the given order, ignoring anything other than digits and separators (`/`, `-`, `.` or a space).

A separator ends a group early. For a day or month, if the separator was just typed at the end, or the input was pasted or autofilled, a single digit is padded with a zero, so `1/2/1980` becomes `01/02/1980`. A pasted single digit day at the end (with year-month-day order) is padded too.

Unless deleting, a separator is added after each completed group. When deleting, a separator is only kept if the input still ends with one, so deleting it doesn't add it straight back.

-}
mask : DateFormat -> { deleting : Bool, pasting : Bool } -> String -> String
mask { order, separator } { deleting, pasting } input =
    let
        lengths =
            partLengths order

        lastIndex =
            List.length lengths - 1

        lastPosition =
            String.length input - 1

        groupLength index =
            ListExtra.getAt index lengths
                |> Maybe.withDefault 0

        step : ( Int, Char ) -> MaskState -> MaskState
        step ( position, char ) state =
            let
                index =
                    List.length state.groups

                length =
                    groupLength index

                endGroup group =
                    { groups = state.groups ++ [ group ], current = "" }
            in
            if Char.isDigit char && String.length state.current < length then
                let
                    next =
                        state.current ++ String.fromChar char
                in
                if String.length next == length && index < lastIndex then
                    endGroup next

                else
                    { state | current = next }

            else if isSeparator char && state.current /= "" && index < lastIndex then
                if pasting || position == lastPosition then
                    endGroup (padPart length state.current)

                else
                    endGroup state.current

            else
                state

        { groups, current } =
            String.toList input
                |> List.indexedMap Tuple.pair
                |> List.foldl step { groups = [], current = "" }

        lastGroup =
            if pasting && List.length groups == lastIndex then
                padPart (groupLength lastIndex) current

            else
                current
    in
    if lastGroup /= "" then
        String.join separator (groups ++ [ lastGroup ])

    else if List.isEmpty groups || (deleting && not (String.endsWith separator input)) then
        String.join separator groups

    else
        String.join separator groups ++ separator
