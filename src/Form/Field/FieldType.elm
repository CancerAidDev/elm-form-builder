module Form.Field.FieldType exposing
    ( FieldType(..), StringFieldType(..), SimpleFieldType(..), BoolFieldType(..), CheckboxFieldType(..), NumericFieldType(..), MultiStringFieldType(..), DateFieldType(..)
    , decoder
    , defaultValue, toClass, toMax, toMaxLength, toMin, toType
    )

{-| Field Type


# FieldType

@docs FieldType, StringFieldType, SimpleFieldType, BoolFieldType, CheckboxFieldType, NumericFieldType, MultiStringFieldType, DateFieldType


# Decoder

@docs decoder


# Helpers

@docs defaultValue, toClass, toMax, toMaxLength, toMin, toType

-}

import Form.Lib.Time as LibTime
import Json.Decode as Decode
import Json.Decode.Extra as DecodeExtra
import Time
import Time.Extra as TimeExtra


{-| -}
type FieldType
    = StringType StringFieldType
    | MultiStringType MultiStringFieldType
    | BoolType BoolFieldType
    | NumericType NumericFieldType


{-| -}
type StringFieldType
    = SimpleType SimpleFieldType
    | DateType DateFieldType
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
    | Phone
    | Url
    | TextArea


{-| -}
type NumericFieldType
    = Age


{-| -}
type MultiStringFieldType
    = MultiSelect
    | SearchableMultiSelect
    | MultiHttpSelect


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
            Just (StringType (DateType DateOfBirth))

        "date_past" ->
            Just (StringType (DateType DatePast))

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

        "http_select" ->
            Just (StringType HttpSelect)

        "multi_select" ->
            Just (MultiStringType MultiSelect)

        "searchable_multi_select" ->
            Just (MultiStringType SearchableMultiSelect)

        "multi_http_select" ->
            Just (MultiStringType MultiHttpSelect)

        "radio" ->
            Just (StringType Radio)

        "age" ->
            Just (NumericType Age)

        _ ->
            Nothing


{-| -}
toType : FieldType -> String
toType fieldType =
    case fieldType of
        StringType (SimpleType Text) ->
            "text"

        StringType (SimpleType Email) ->
            "email"

        StringType (SimpleType Phone) ->
            "tel"

        StringType (SimpleType Url) ->
            "url"

        StringType (SimpleType TextArea) ->
            "textarea"

        StringType (DateType _) ->
            "date"

        _ ->
            ""


{-| -}
toMaxLength : FieldType -> Maybe Int
toMaxLength fieldType =
    case fieldType of
        StringType (DateType _) ->
            Just 10

        _ ->
            Nothing


{-| -}
toMin : Time.Posix -> FieldType -> Maybe String
toMin time fieldType =
    case fieldType of
        StringType (DateType DateOfBirth) ->
            time
                |> TimeExtra.add TimeExtra.Year -120 Time.utc
                |> TimeExtra.floor TimeExtra.Year Time.utc
                |> LibTime.toDateString
                |> Just

        StringType (DateType DatePast) ->
            Just (LibTime.toDateString time)

        NumericType Age ->
            Just "18"

        _ ->
            Nothing


{-| -}
toMax : Time.Posix -> FieldType -> Maybe String
toMax time fieldType =
    case fieldType of
        StringType (DateType DateOfBirth) ->
            Just (LibTime.toDateString time)

        StringType (DateType DatePast) ->
            time
                |> TimeExtra.add TimeExtra.Year 10 Time.utc
                |> TimeExtra.floor TimeExtra.Year Time.utc
                |> LibTime.toDateString
                |> Just

        NumericType Age ->
            Just "99"

        _ ->
            Nothing


{-| -}
defaultValue : Time.Posix -> FieldType -> Maybe String
defaultValue time fieldType =
    case fieldType of
        StringType (DateType _) ->
            time
                |> TimeExtra.add TimeExtra.Year -40 Time.utc
                |> TimeExtra.floor TimeExtra.Year Time.utc
                |> LibTime.toDateString
                |> Just

        _ ->
            Nothing


{-| -}
toClass : FieldType -> String
toClass fieldType =
    case fieldType of
        StringType (SimpleType TextArea) ->
            "textarea"

        StringType (SimpleType _) ->
            "input"

        StringType (DateType _) ->
            "input"

        _ ->
            ""


{-| -}
decoder : Decode.Decoder FieldType
decoder =
    Decode.string
        |> Decode.andThen
            (fromString >> DecodeExtra.fromMaybe "Invalid field type")
