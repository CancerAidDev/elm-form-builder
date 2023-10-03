module Form.Field.FieldType exposing
    ( FieldType(..), StringFieldType(..), SimpleFieldType(..), BoolFieldType(..), CheckboxFieldType(..), IntegerFieldType, MultiStringFieldType(..), DateFieldType, DateConfig(..), ListStringFieldType(..)
    , decoder
    , defaultValue, toClass, toMax, toMaxLength, toMin, toType, dateOfBirth, datePast, dateFuture
    )

{-| Field Type


# FieldType

@docs FieldType, StringFieldType, SimpleFieldType, BoolFieldType, CheckboxFieldType, IntegerFieldType, MultiStringFieldType, DateFieldType, DateConfig, ListStringFieldType


# Decoder

@docs decoder


# Helpers

@docs defaultValue, toClass, toMax, toMaxLength, toMin, toType, dateOfBirth, datePast, dateFuture

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
    | Time


{-| -}
type alias IntegerFieldType =
    { min : Maybe Int, max : Maybe Int }


defaultInt : IntegerFieldType
defaultInt =
    { min = Nothing
    , max = Nothing
    }


{-| -}
type MultiStringFieldType
    = MultiSelect
    | SearchableMultiSelect
    | MultiHttpSelect
    | Tags


{-| -}
type alias DateFieldType =
    { min : Maybe DateConfig, max : Maybe DateConfig }


{-| -}
type DateConfig
    = DateAbsolute Time.Posix
    | DateOffset ( TimeExtra.Interval, Int )


dateConfigToString : Time.Posix -> DateConfig -> String
dateConfigToString time config =
    case config of
        DateAbsolute maxDate ->
            LibTime.toDateString maxDate

        DateOffset ( offsetUnit, offset ) ->
            time
                |> TimeExtra.add offsetUnit offset Time.utc
                |> TimeExtra.floor offsetUnit Time.utc
                |> LibTime.toDateString


{-| -}
dateOfBirth : DateFieldType
dateOfBirth =
    { min = Just (DateOffset ( TimeExtra.Year, -120 ))
    , max = Just (DateOffset ( TimeExtra.Year, 0 ))
    }


{-| -}
dateFuture : DateFieldType
dateFuture =
    { min = Just (DateOffset ( TimeExtra.Day, 1 ))
    , max = Just (DateOffset ( TimeExtra.Year, 10 ))
    }


{-| -}
datePast : DateFieldType
datePast =
    { min = Just (DateOffset ( TimeExtra.Year, -120 ))
    , max = Just (DateOffset ( TimeExtra.Day, -1 ))
    }


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

        "phone" ->
            Just (StringType (SimpleType Phone))

        "time" ->
            Just (StringType (SimpleType Time))

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

        "tags" ->
            Just (MultiStringType Tags)

        "integer" ->
            Just (IntegerType defaultInt)

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
        StringType (DateType { min }) ->
            min |> Maybe.map (dateConfigToString time)

        IntegerType { min } ->
            min |> Maybe.map String.fromInt

        _ ->
            Nothing


{-| -}
toMax : Time.Posix -> FieldType -> Maybe String
toMax time fieldType =
    case fieldType of
        StringType (DateType { max }) ->
            max |> Maybe.map (dateConfigToString time)

        IntegerType { max } ->
            max |> Maybe.map String.fromInt

        _ ->
            Nothing


{-| -}
defaultValue : Time.Posix -> FieldType -> Maybe String
defaultValue time fieldType =
    case fieldType of
        StringType (DateType _) ->
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
