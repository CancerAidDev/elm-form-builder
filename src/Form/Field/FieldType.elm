module Form.Field.FieldType exposing
    ( FieldType(..), StringFieldType(..), SimpleFieldType(..), BoolFieldType(..), CheckboxFieldType(..), IntegerFieldType(..), MultiStringFieldType(..), DateFieldType, DateConfig(..), ListStringFieldType(..)
    , decoder
    , dateConfigToString, toAutoComplete, toClass, toMaxLength, toType, dateDefault, dateOfBirth, datePast, dateFuture, minAgeDefault, maxAgeDefault
    )

{-| Field Type


# FieldType

@docs FieldType, StringFieldType, SimpleFieldType, BoolFieldType, CheckboxFieldType, IntegerFieldType, MultiStringFieldType, DateFieldType, DateConfig, ListStringFieldType


# Decoder

@docs decoder


# Helpers

@docs dateConfigToString, toAutoComplete, toClass, toMaxLength, toType, dateDefault, dateOfBirth, datePast, dateFuture, minAgeDefault, maxAgeDefault

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
    | IntegerType IntegerFieldType


{-| -}
type StringFieldType
    = SimpleType SimpleFieldType
    | DateType DateFieldType
    | Select
    | SearchableSelect
    | HttpSelect
    | HttpSearchableSelect
    | Radio
    | Color


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
    | Time


{-| -}
type IntegerFieldType
    = SimpleInteger
    | Age
    | LinearScale


{-| -}
type MultiStringFieldType
    = MultiSelect
    | SearchableMultiSelect
    | MultiHttpSelect
    | Tags


{-| -}
type alias DateFieldType =
    { min : Maybe DateConfig, max : Maybe DateConfig, default : Maybe DateConfig }


{-| -}
type DateConfig
    = DateAbsolute Time.Posix
    | DateOffset ( TimeExtra.Interval, Int )


{-| -}
dateConfigToString : Time.Posix -> DateConfig -> String
dateConfigToString currentTime config =
    LibTime.toDateString <|
        case config of
            DateAbsolute time ->
                time

            DateOffset ( offsetUnit, offset ) ->
                currentTime
                    |> TimeExtra.add offsetUnit offset Time.utc
                    |> TimeExtra.floor offsetUnit Time.utc


{-| -}
dateOfBirth : DateFieldType
dateOfBirth =
    { min = Just (DateOffset ( TimeExtra.Year, -120 ))
    , max = Just (DateOffset ( TimeExtra.Year, 0 ))
    , default = Just (DateOffset ( TimeExtra.Year, -40 ))
    }


{-| -}
dateFuture : DateFieldType
dateFuture =
    { min = Just (DateOffset ( TimeExtra.Day, 1 ))
    , max = Just (DateOffset ( TimeExtra.Year, 10 ))
    , default = Nothing
    }


{-| -}
datePast : DateFieldType
datePast =
    { min = Just (DateOffset ( TimeExtra.Year, -120 ))
    , max = Just (DateOffset ( TimeExtra.Day, -1 ))
    , default = Nothing
    }


{-| -}
dateDefault : DateFieldType
dateDefault =
    { min = Nothing
    , max = Nothing
    , default = Nothing
    }


{-| -}
minAgeDefault : Maybe Int
minAgeDefault =
    Just 18


{-| -}
maxAgeDefault : Maybe Int
maxAgeDefault =
    Just 99


{-| -}
fromString : String -> Maybe FieldType
fromString str =
    case str of
        "text" ->
            Just (StringType (SimpleType Text))

        "email" ->
            Just (StringType (SimpleType Email))

        "date_birth" ->
            Just (StringType (DateType dateOfBirth))

        "date_past" ->
            Just (StringType (DateType datePast))

        "date_future" ->
            Just (StringType (DateType dateFuture))

        "date" ->
            Just (StringType (DateType dateDefault))

        "phone" ->
            Just (StringType (SimpleType Phone))

        "time" ->
            Just (StringType (SimpleType Time))

        "color" ->
            Just (StringType Color)

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

        "http_searchable_select" ->
            Just (StringType HttpSearchableSelect)

        "multi_select" ->
            Just (MultiStringType MultiSelect)

        "searchable_multi_select" ->
            Just (MultiStringType SearchableMultiSelect)

        "multi_http_select" ->
            Just (MultiStringType MultiHttpSelect)

        "radio" ->
            Just (StringType Radio)

        "tags" ->
            Just (MultiStringType Tags)

        "age" ->
            Just (IntegerType Age)

        "integer" ->
            Just (IntegerType SimpleInteger)

        "linear_scale" ->
            Just (IntegerType LinearScale)

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

        StringType (SimpleType Time) ->
            "time"

        StringType Color ->
            "color"

        StringType (SimpleType Url) ->
            "url"

        StringType (SimpleType TextArea) ->
            "textarea"

        StringType (DateType _) ->
            "date"

        _ ->
            ""


{-| -}
toAutoComplete : FieldType -> Maybe String
toAutoComplete fieldType =
    case fieldType of
        StringType (SimpleType Email) ->
            Just "email"

        StringType (SimpleType Phone) ->
            Just "tel"

        _ ->
            Nothing


{-| -}
toMaxLength : FieldType -> Maybe Int
toMaxLength fieldType =
    case fieldType of
        StringType (DateType _) ->
            Just 10

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
