module Form.Types.Field exposing
    ( Field(..), StringField(..), BoolField(..), NumericField(..)
    , SimpleFieldProperties, SelectFieldProperties, HttpSelectFieldProperties, BoolFieldProperties, CheckboxFieldProperties, MaybeBoolFieldProperties, MaybeEnumFieldProperties
    , getBoolProperties, getEnabledBy, getLabel, getNumericValue, getOrder, getProperties, getStringType, getStringValue, getStringValue_, getTitle, getType, getUrl, getWidth
    , resetValueToDefault, setRequired, updateBoolValue, updateCheckboxValue_, updateNumericValue, updateNumericValue_, updateRadioBoolValue, updateRadioBoolValue_, updateRadioEnumValue, updateRadioEnumValue_, updateRemoteOptions, updateStringValue, updateStringValue_, maybeUpdateStringValue
    , hasTitle, isCheckbox, isColumn, isNumericField, isRequired
    , encode
    , metadataKey
    )

{-| Field type and helper functions


# Field

@docs Field, StringField, BoolField, NumericField


# Properties

@docs SimpleFieldProperties, SelectFieldProperties, HttpSelectFieldProperties, BoolFieldProperties, CheckboxFieldProperties, MaybeBoolFieldProperties, MaybeEnumFieldProperties


# Getters

@docs getBoolProperties, getEnabledBy, getLabel, getNumericValue, getOrder, getProperties, getStringType, getStringValue, getStringValue_, getTitle, getType, getUrl, getWidth


# Setters

@docs resetValueToDefault, setRequired, updateBoolValue, updateCheckboxValue_, updateNumericValue, updateNumericValue_, updateRadioBoolValue, updateRadioBoolValue_, updateRadioEnumValue, updateRadioEnumValue_, updateRemoteOptions, updateStringValue, updateStringValue_, maybeUpdateStringValue


# Predicates

@docs hasTitle, isCheckbox, isColumn, isNumericField, isRequired


# Encode

@docs encode


# Metadata

@docs metadataKey

-}

import Form.Types.Direction as Direction
import Form.Types.FieldType as FieldType
import Form.Types.Option as Option
import Form.Types.RadioBool as RadioBool
import Form.Types.RadioEnum as RadioEnum
import Form.Types.Width as Width
import Http.Detailed as HttpDetailed
import Json.Encode as Encode
import Json.Encode.Extra as EncodeExtra
import RemoteData


{-| -}
type Field
    = StringField_ StringField
    | BoolField_ BoolField
    | NumericField_ NumericField


{-| -}
type StringField
    = SimpleField SimpleFieldProperties
    | SelectField SelectFieldProperties
    | HttpSelectField HttpSelectFieldProperties
    | RadioField RadioFieldProperties


{-| -}
type BoolField
    = CheckboxField CheckboxFieldProperties
    | RadioBoolField MaybeBoolFieldProperties
    | RadioEnumField MaybeEnumFieldProperties


{-| -}
type NumericField
    = NumericField NumericFieldProperties


{-| -}
type alias FieldProperties a =
    { a
        | required : Bool
        , label : String
        , width : Width.Width
        , enabledBy : Maybe String
        , order : Int
    }


{-| -}
type alias StringFieldProperties a =
    FieldProperties { a | value : String }


{-| -}
type alias SimpleFieldProperties =
    StringFieldProperties { tipe : FieldType.SimpleFieldType }


{-| -}
type alias SelectFieldProperties =
    StringFieldProperties { default : Maybe String, options : List Option.Option }


{-| -}
type alias HttpSelectFieldProperties =
    StringFieldProperties
        { url : String
        , default : Maybe String
        , options : RemoteData.RemoteData (HttpDetailed.Error String) (List Option.Option)
        }


{-| -}
type alias RadioFieldProperties =
    StringFieldProperties { default : Maybe String, options : List Option.Option, title : String, direction : Direction.Direction }


{-| -}
type alias CheckboxFieldProperties =
    FieldProperties { tipe : FieldType.CheckboxFieldType, value : Bool }


{-| -}
type alias BoolFieldProperties a =
    FieldProperties { a | value : Bool }


{-| -}
type alias MaybeEnumFieldProperties =
    FieldProperties { value : Maybe RadioEnum.Value, title : String, default : Maybe RadioEnum.Value, options : List RadioEnum.Value }


{-| -}
type alias MaybeBoolFieldProperties =
    FieldProperties { value : Maybe Bool, title : String, default : Maybe String, options : List Bool }


{-| -}
type alias NumericFieldProperties =
    FieldProperties { value : Maybe Int, title : String, tipe : FieldType.NumericFieldType }


{-| -}
getProperties : Field -> FieldProperties {}
getProperties field =
    case field of
        StringField_ stringProperties ->
            let
                { required, label, width, enabledBy, order } =
                    getStringProperties stringProperties
            in
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            }

        BoolField_ (CheckboxField { required, label, width, enabledBy, order }) ->
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            }

        BoolField_ (RadioBoolField { required, label, width, enabledBy, order }) ->
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            }

        BoolField_ (RadioEnumField { required, label, width, enabledBy, order }) ->
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            }

        NumericField_ (NumericField { required, label, width, enabledBy, order }) ->
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            }


getStringProperties : StringField -> FieldProperties { value : String }
getStringProperties field =
    case field of
        HttpSelectField { required, label, width, enabledBy, order, value } ->
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , value = value
            }

        SimpleField { required, label, width, enabledBy, order, value } ->
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , value = value
            }

        SelectField { required, label, width, enabledBy, order, value } ->
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , value = value
            }

        RadioField { required, label, width, enabledBy, order, value } ->
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , value = value
            }


{-| -}
updateStringValue : String -> Field -> Field
updateStringValue value field =
    case field of
        StringField_ stringField ->
            StringField_ <| updateStringValue_ value stringField

        _ ->
            field


{-| -}
maybeUpdateStringValue : Maybe String -> Field -> Field
maybeUpdateStringValue maybeValue field =
    -- Keep existing field if the value is Nothing
    Maybe.map (\str -> updateStringValue str field) maybeValue
        |> Maybe.withDefault field


{-| -}
getBoolProperties : Field -> Maybe Bool
getBoolProperties field =
    case field of
        BoolField_ f ->
            case f of
                CheckboxField { value } ->
                    Just value

                RadioBoolField { value } ->
                    value

                _ ->
                    Nothing

        _ ->
            Nothing


{-| -}
resetValueToDefault : Field -> Field
resetValueToDefault field =
    case field of
        StringField_ stringField ->
            StringField_ (resetStringFieldValueToDefault stringField)

        BoolField_ (CheckboxField properties) ->
            BoolField_ (CheckboxField { properties | value = False })

        BoolField_ (RadioBoolField properties) ->
            BoolField_ (RadioBoolField { properties | value = properties.default |> Maybe.andThen RadioBool.fromString })

        BoolField_ (RadioEnumField properties) ->
            BoolField_ (RadioEnumField { properties | value = properties.default })

        NumericField_ (NumericField properties) ->
            NumericField_ (NumericField { properties | value = Nothing })


resetStringFieldValueToDefault : StringField -> StringField
resetStringFieldValueToDefault field =
    case field of
        HttpSelectField properties ->
            HttpSelectField { properties | value = properties.default |> Maybe.withDefault "" }

        SimpleField properties ->
            SimpleField { properties | value = "" }

        SelectField properties ->
            SelectField { properties | value = properties.default |> Maybe.withDefault "" }

        RadioField properties ->
            RadioField { properties | value = properties.default |> Maybe.withDefault "" }


{-| -}
setRequired : Bool -> Field -> Field
setRequired bool field =
    case field of
        StringField_ stringField ->
            StringField_ (setRequiredStringField bool stringField)

        BoolField_ (CheckboxField properties) ->
            BoolField_ (CheckboxField { properties | required = bool })

        BoolField_ (RadioBoolField properties) ->
            BoolField_ (RadioBoolField { properties | required = bool })

        BoolField_ (RadioEnumField properties) ->
            BoolField_ (RadioEnumField { properties | required = bool })

        NumericField_ (NumericField properties) ->
            NumericField_ (NumericField { properties | required = bool })


{-| -}
setRequiredStringField : Bool -> StringField -> StringField
setRequiredStringField bool field =
    case field of
        HttpSelectField properties ->
            HttpSelectField { properties | required = bool }

        SimpleField properties ->
            SimpleField { properties | required = bool }

        SelectField properties ->
            SelectField { properties | required = bool }

        RadioField properties ->
            RadioField { properties | required = bool }


{-| -}
updateBoolValue : Bool -> Field -> Field
updateBoolValue value field =
    case field of
        BoolField_ boolField ->
            BoolField_ <| updateCheckboxValue_ value boolField

        _ ->
            field


{-| -}
updateRadioEnumValue : Maybe RadioEnum.Value -> Field -> Field
updateRadioEnumValue value field =
    case field of
        BoolField_ boolField ->
            BoolField_ <| updateRadioEnumValue_ value boolField

        _ ->
            field


{-| -}
updateRadioBoolValue : Maybe Bool -> Field -> Field
updateRadioBoolValue value field =
    case field of
        BoolField_ boolField ->
            BoolField_ <| updateRadioBoolValue_ value boolField

        _ ->
            field


{-| -}
updateNumericValue : String -> Field -> Field
updateNumericValue value field =
    case field of
        NumericField_ numericField ->
            NumericField_ <| updateNumericValue_ (String.toInt value) numericField

        _ ->
            field


{-| -}
updateStringValue_ : String -> StringField -> StringField
updateStringValue_ value field =
    case field of
        SimpleField properties ->
            SimpleField { properties | value = value }

        SelectField properties ->
            SelectField { properties | value = value }

        HttpSelectField properties ->
            HttpSelectField { properties | value = value }

        RadioField properties ->
            RadioField { properties | value = value }


{-| -}
updateCheckboxValue_ : Bool -> BoolField -> BoolField
updateCheckboxValue_ value field =
    case field of
        CheckboxField properties ->
            CheckboxField { properties | value = value }

        _ ->
            field


{-| -}
updateRadioBoolValue_ : Maybe Bool -> BoolField -> BoolField
updateRadioBoolValue_ value field =
    case field of
        RadioBoolField properties ->
            RadioBoolField { properties | value = value }

        _ ->
            field


{-| -}
updateRadioEnumValue_ : Maybe RadioEnum.Value -> BoolField -> BoolField
updateRadioEnumValue_ value field =
    case field of
        RadioEnumField properties ->
            RadioEnumField { properties | value = value }

        _ ->
            field


{-| -}
updateNumericValue_ : Maybe Int -> NumericField -> NumericField
updateNumericValue_ value (NumericField properties) =
    NumericField { properties | value = value }


{-| -}
updateRemoteOptions : RemoteData.RemoteData (HttpDetailed.Error String) (List Option.Option) -> Field -> Field
updateRemoteOptions options field =
    case field of
        StringField_ (HttpSelectField properties) ->
            StringField_ (HttpSelectField { properties | options = options })

        _ ->
            field


{-| -}
getLabel : Field -> String
getLabel =
    getProperties >> .label


{-| -}
getEnabledBy : Field -> Maybe String
getEnabledBy =
    getProperties >> .enabledBy


{-| -}
getStringValue_ : StringField -> String
getStringValue_ field =
    case field of
        SimpleField properties ->
            properties.value

        SelectField properties ->
            properties.value

        HttpSelectField properties ->
            properties.value

        RadioField properties ->
            properties.value


{-| -}
getStringValue : Field -> Maybe String
getStringValue field =
    case field of
        StringField_ f ->
            Just (getStringValue_ f)

        _ ->
            Nothing


{-| -}
getNumericValue : Field -> Maybe Int
getNumericValue field =
    case field of
        NumericField_ (NumericField { value }) ->
            value

        _ ->
            Nothing


{-| -}
isRequired : Field -> Bool
isRequired =
    getProperties >> .required


{-| -}
isCheckbox : Field -> Bool
isCheckbox field =
    case field of
        BoolField_ (CheckboxField _) ->
            True

        _ ->
            False


{-| -}
hasTitle : Field -> Bool
hasTitle field =
    case field of
        BoolField_ (RadioBoolField _) ->
            True

        BoolField_ (RadioEnumField _) ->
            True

        NumericField_ _ ->
            True

        StringField_ (RadioField _) ->
            True

        _ ->
            False


{-| -}
getTitle : Field -> String
getTitle field =
    case field of
        BoolField_ (RadioBoolField properties) ->
            properties.title

        BoolField_ (RadioEnumField properties) ->
            properties.title

        NumericField_ (NumericField properties) ->
            properties.title

        StringField_ (RadioField properties) ->
            properties.title

        _ ->
            ""


{-| -}
getType : Field -> FieldType.FieldType
getType field =
    case field of
        StringField_ stringField ->
            FieldType.StringType <| getStringType stringField

        BoolField_ (CheckboxField { tipe }) ->
            FieldType.BoolType (FieldType.CheckboxType tipe)

        BoolField_ (RadioBoolField _) ->
            FieldType.BoolType FieldType.RadioBool

        BoolField_ (RadioEnumField _) ->
            FieldType.BoolType FieldType.RadioEnum

        NumericField_ (NumericField { tipe }) ->
            FieldType.NumericType tipe


{-| -}
isNumericField : Field -> Bool
isNumericField field =
    case field of
        NumericField_ _ ->
            True

        _ ->
            False


{-| -}
isColumn : Field -> Bool
isColumn field =
    case field of
        StringField_ (RadioField { direction }) ->
            direction == Direction.Column

        _ ->
            True


{-| -}
getStringType : StringField -> FieldType.StringFieldType
getStringType field =
    case field of
        SimpleField properties ->
            FieldType.SimpleType properties.tipe

        SelectField _ ->
            FieldType.Select

        HttpSelectField _ ->
            FieldType.HttpSelect

        RadioField _ ->
            FieldType.Radio


{-| -}
getOrder : Field -> Int
getOrder =
    getProperties >> .order


{-| -}
getWidth : Field -> Width.Width
getWidth =
    getProperties >> .width


{-| -}
getUrl : Field -> Maybe String
getUrl field =
    case field of
        StringField_ (HttpSelectField properties) ->
            Just properties.url

        _ ->
            Nothing


{-| -}
encode : Field -> Encode.Value
encode field =
    case field of
        StringField_ stringField ->
            Encode.string <| getStringValue_ stringField

        BoolField_ (CheckboxField { value }) ->
            Encode.bool value

        BoolField_ (RadioEnumField { value }) ->
            EncodeExtra.maybe Encode.bool (RadioEnum.toBool value)

        BoolField_ (RadioBoolField { value }) ->
            EncodeExtra.maybe Encode.bool value

        NumericField_ (NumericField { value }) ->
            EncodeExtra.maybe Encode.int value


{-| -}
metadataKey : String -> Maybe String
metadataKey string =
    case String.split "." string of
        [ "metadata", key ] ->
            Just key

        _ ->
            Nothing
