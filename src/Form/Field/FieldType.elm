module Form.Field.FieldType exposing
    ( FieldType(..), StringFieldType(..), SimpleFieldType(..), BoolFieldType(..), CheckboxFieldType(..), NumericFieldType(..), DateFieldType(..)
    , decoder
    , defaultValue, toClass, toMax, toMaxLength, toMin, toPlaceholder, toType
    )

{-| Field Type


# FieldType

@docs FieldType, StringFieldType, SimpleFieldType, BoolFieldType, CheckboxFieldType, NumericFieldType, DateFieldType


# Decoder

@docs decoder


# Helpers

@docs defaultValue, toClass, toMax, toMaxLength, toMin, toPlaceholder, toType

-}

import Form.Lib.Time as LibTime
import Json.Decode as Decode
import Json.Decode.Extra as DecodeExtra
import Time
import Time.Extra as TimeExtra


{-| -}
type FieldType
    = StringType StringFieldType
    | BoolType BoolFieldType
    | NumericType NumericFieldType


{-| -}
type StringFieldType
    = SimpleType SimpleFieldType
    | Select
    | HttpSelect
    | Radio


{-| -}
type BoolFieldType
    = CheckboxType CheckboxFieldType
    | RadioBool
    | RadioEnum


{-| -}
type CheckboxFieldType
    = Checkbox
    | CheckboxConsent


{-| -}
type SimpleFieldType
    = Text
    | Email
    | Date DateFieldType
    | Phone
    | Url
    | TextArea


{-| -}
type NumericFieldType
    = Age


{-| -}
type DateFieldType
    = DatePast
    | DateOfBirth


{-| -}
fromString : String -> Maybe FieldType
fromString str =
    case str of
        "text" ->
            Just (StringType (SimpleType Text))

        "email" ->
            Just (StringType (SimpleType Email))

        "date_birth" ->
            Just (StringType (SimpleType (Date DateOfBirth)))

        "date_past" ->
            Just (StringType (SimpleType (Date DatePast)))

        "phone" ->
            Just (StringType (SimpleType Phone))

        "url" ->
            Just (StringType (SimpleType Url))

        "textarea" ->
            Just (StringType (SimpleType TextArea))

        "checkbox" ->
            Just (BoolType (CheckboxType Checkbox))

        "checkbox_consent" ->
            Just (BoolType (CheckboxType CheckboxConsent))

        "radio_bool" ->
            Just (BoolType RadioBool)

        "radio_enum" ->
            Just (BoolType RadioEnum)

        "select" ->
            Just (StringType Select)

        "httpSelect" ->
            Just (StringType HttpSelect)

        "radio" ->
            Just (StringType Radio)

        "age" ->
            Just (NumericType Age)

        _ ->
            Nothing


{-| -}
toType : SimpleFieldType -> String
toType fieldType =
    case fieldType of
        Text ->
            "text"

        Email ->
            "email"

        Date _ ->
            "date"

        Phone ->
            "tel"

        Url ->
            "url"

        TextArea ->
            "textarea"


{-| -}
toPlaceholder : SimpleFieldType -> String
toPlaceholder fieldType =
    case fieldType of
        Email ->
            "your@email.com"

        Phone ->
            "400 000 000"

        _ ->
            ""


{-| -}
toMaxLength : SimpleFieldType -> Maybe Int
toMaxLength fieldType =
    case fieldType of
        Date _ ->
            Just 10

        _ ->
            Nothing


{-| -}
toMin : Time.Posix -> FieldType -> Maybe String
toMin time fieldType =
    case fieldType of
        StringType (SimpleType (Date _)) ->
            time
                |> TimeExtra.add TimeExtra.Year -120 Time.utc
                |> TimeExtra.floor TimeExtra.Year Time.utc
                |> LibTime.toDateString
                |> Just

        NumericType Age ->
            Just "18"

        _ ->
            Nothing


{-| -}
toMax : Time.Posix -> FieldType -> Maybe String
toMax time fieldType =
    case fieldType of
        StringType (SimpleType (Date _)) ->
            Just (LibTime.toDateString time)

        NumericType Age ->
            Just "99"

        _ ->
            Nothing


{-| -}
defaultValue : Time.Posix -> SimpleFieldType -> Maybe String
defaultValue time fieldType =
    case fieldType of
        Date DateOfBirth ->
            time
                |> TimeExtra.add TimeExtra.Year -40 Time.utc
                |> TimeExtra.floor TimeExtra.Year Time.utc
                |> LibTime.toDateString
                |> Just

        _ ->
            Nothing


{-| -}
toClass : SimpleFieldType -> String
toClass fieldType =
    case fieldType of
        Text ->
            "input"

        Email ->
            "input"

        Date _ ->
            "input"

        Phone ->
            "input"

        Url ->
            "input"

        TextArea ->
            "textarea"


{-| -}
decoder : Decode.Decoder FieldType
decoder =
    Decode.string
        |> Decode.andThen
            (fromString >> DecodeExtra.fromMaybe "Invalid field type")
