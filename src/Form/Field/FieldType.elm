module Form.Field.FieldType exposing
    ( FieldType(..), StringFieldType(..), SimpleFieldType(..), BoolFieldType(..), CheckboxFieldType(..), NumericFieldType(..), MultiStringFieldType(..), ListStringFieldType(..)
    , decoder
    , defaultValue, toClass, toMax, toMaxLength, toMin, toType
    )

{-| Field Type


# FieldType

@docs FieldType, StringFieldType, SimpleFieldType, BoolFieldType, CheckboxFieldType, NumericFieldType, MultiStringFieldType, ListStringFieldType


# Decoder

@docs decoder


# Helpers

@docs defaultValue, toClass, toMax, toMaxLength, toMin, toType

-}

import Form.Lib.Time as LibTime
import Json.Decode as Decode
import Json.Decode.Extra as DecodeExtra
import Time


{-| -}
type FieldType
    = StringType StringFieldType
    | MultiStringType MultiStringFieldType
    | BoolType BoolFieldType
    | NumericType NumericFieldType


{-| -}
type StringFieldType
    = SimpleType SimpleFieldType
    | DateType
    | Select
    | SearchableSelect
    | HttpSelect
    | Radio


{-| -}
type ListStringFieldType
    = Tag


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
    | NumericText


{-| -}
type MultiStringFieldType
    = MultiSelect
    | SearchableMultiSelect
    | MultiHttpSelect
    | Tags


{-| -}
fromString : String -> Maybe FieldType
fromString str =
    case str of
        "text" ->
            Just (StringType (SimpleType Text))

        "email" ->
            Just (StringType (SimpleType Email))

        "date" ->
            Just (StringType DateType)

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

        "searchable_select" ->
            Just (StringType SearchableSelect)

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

        "numeric_text" ->
            Just (NumericType NumericText)

        "tags" ->
            Just (MultiStringType Tags)

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

        StringType DateType ->
            "date"

        _ ->
            ""


{-| -}
toMaxLength : FieldType -> Maybe Int
toMaxLength fieldType =
    case fieldType of
        StringType DateType ->
            Just 10

        _ ->
            Nothing


{-| -}
toMin : Maybe Time.Posix -> Time.Posix -> FieldType -> Maybe String
toMin minDate time fieldType =
    case fieldType of
        StringType DateType ->
            case minDate of
                Just date ->
                    date
                        |> LibTime.toDateString
                        |> Just

                Nothing ->
                    time
                        |> LibTime.offsetYear -120
                        |> LibTime.toDateString
                        |> Just

        NumericType Age ->
            Just "18"

        NumericType NumericText ->
            Just "0"

        _ ->
            Nothing


{-| -}
toMax : Maybe Time.Posix -> Time.Posix -> FieldType -> Maybe String
toMax maxDate time fieldType =
    case fieldType of
        StringType DateType ->
            case maxDate of
                Just date ->
                    date
                        |> LibTime.toDateString
                        |> Just

                Nothing ->
                    time
                        |> LibTime.offsetYear 120
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
        StringType DateType ->
            time
                |> LibTime.offsetYear -40
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

        StringType DateType ->
            "input"

        _ ->
            ""


{-| -}
decoder : Decode.Decoder FieldType
decoder =
    Decode.string
        |> Decode.andThen
            (fromString >> DecodeExtra.fromMaybe "Invalid field type")
