module Form.Field exposing
    ( Field(..), StringField(..), MultiStringField(..), BoolField(..), NumericField(..), text, email, dateOfBirth, datePast, phone, url, textarea, checkbox, radioBool, radioEnum, select, httpSelect, multiSelect, searchableMultiSelect, multiHttpSelect, radio, age
    , AgeFieldProperties, CommonFieldProperties, SimpleFieldProperties, SelectFieldProperties, HttpSelectFieldProperties, MultiSelectFieldProperties, SearchableMultiSelectFieldProperties, MultiHttpSelectFieldProperties, RadioFieldProperties, BoolFieldProperties, CheckboxFieldProperties, RadioBoolFieldProperties, RadioEnumFieldProperties, StringFieldProperties
    , getBoolProperties, getEnabledBy, getUnhiddenBy, getLabel, getNumericValue, getOrder, getProperties, getStringType, getStringValue, getStringValue_, getMultiStringValue_, getType, getUrl, getWidth
    , resetValueToDefault, setRequired, updateBoolValue, updateCheckboxValue_, updateNumericValue, updateNumericValue_, updateRadioBoolValue, updateRadioBoolValue_, updateRadioEnumValue, updateRadioEnumValue_, updateRemoteOptions, updateStringValue, updateStringDisabled, updateStringHidden, updateMultiStringOption, updateStringValue_, updateStringDisabled_, updateStringHidden_, updateMultiStringValue_, updateShowDropdown, maybeUpdateStringValue, updateSearchableMultiselectInput
    , isCheckbox, isColumn, isNumericField, isRequired
    , encode
    , metadataKey
    )

{-| Field type and helper functions


# Field

@docs Field, StringField, MultiStringField, BoolField, NumericField, text, email, dateOfBirth, datePast, phone, url, textarea, checkbox, radioBool, radioEnum, select, httpSelect, multiSelect, searchableMultiSelect, multiHttpSelect, radio, age


# Properties

@docs AgeFieldProperties, CommonFieldProperties, SimpleFieldProperties, SelectFieldProperties, HttpSelectFieldProperties, MultiSelectFieldProperties, SearchableMultiSelectFieldProperties, MultiHttpSelectFieldProperties, RadioFieldProperties, BoolFieldProperties, CheckboxFieldProperties, RadioBoolFieldProperties, RadioEnumFieldProperties, StringFieldProperties


# Getters

@docs getBoolProperties, getEnabledBy, getUnhiddenBy, getLabel, getNumericValue, getOrder, getProperties, getStringType, getStringValue, getStringValue_, getMultiStringValue_, getType, getUrl, getWidth


# Setters

@docs resetValueToDefault, setRequired, updateBoolValue, updateCheckboxValue_, updateNumericValue, updateNumericValue_, updateRadioBoolValue, updateRadioBoolValue_, updateRadioEnumValue, updateRadioEnumValue_, updateRemoteOptions, updateStringValue, updateStringDisabled, updateStringHidden, updateMultiStringOption, updateStringValue_, updateStringDisabled_, updateStringHidden_, updateMultiStringValue_, updateShowDropdown, maybeUpdateStringValue, updateSearchableMultiselectInput


# Predicates

@docs isCheckbox, isColumn, isNumericField, isRequired


# Encode

@docs encode


# Metadata

@docs metadataKey

-}

import Form.Field.Direction as Direction
import Form.Field.FieldType as FieldType
import Form.Field.Option as Option
import Form.Field.RadioEnum as RadioEnum
import Form.Field.Required as Required
import Form.Field.Width as Width
import Http.Detailed as HttpDetailed
import Json.Encode as Encode
import Json.Encode.Extra as EncodeExtra
import RemoteData
import Set


{-| -}
text : StringFieldProperties {} -> Field
text { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } =
    StringField_ <|
        SimpleField
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , tipe = FieldType.Text
            , value = value
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            }


{-| -}
email : StringFieldProperties {} -> Field
email { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } =
    StringField_ <|
        SimpleField
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , tipe = FieldType.Email
            , value = value
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            }


{-| -}
dateOfBirth : StringFieldProperties {} -> Field
dateOfBirth { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } =
    StringField_ <|
        SimpleField
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , tipe = FieldType.Date FieldType.DateOfBirth
            , value = value
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            }


{-| -}
datePast : StringFieldProperties {} -> Field
datePast { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } =
    StringField_ <|
        SimpleField
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , tipe = FieldType.Date FieldType.DatePast
            , value = value
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            }


{-| -}
phone : StringFieldProperties {} -> Field
phone { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } =
    StringField_ <|
        SimpleField
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , tipe = FieldType.Phone
            , value = value
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            }


{-| -}
url : StringFieldProperties {} -> Field
url { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } =
    StringField_ <|
        SimpleField
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , tipe = FieldType.Url
            , value = value
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            }


{-| -}
textarea : StringFieldProperties {} -> Field
textarea { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } =
    StringField_ <|
        SimpleField
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , tipe = FieldType.TextArea
            , value = value
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            }


{-| -}
checkbox : BoolFieldProperties {} -> Field
checkbox { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } =
    BoolField_ <|
        CheckboxField
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , tipe = FieldType.Checkbox
            , value = value
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            }


{-| -}
radioBool : RadioBoolFieldProperties -> Field
radioBool =
    BoolField_ << RadioBoolField


{-| -}
radioEnum : RadioEnumFieldProperties -> Field
radioEnum =
    BoolField_ << RadioEnumField


{-| -}
select : SelectFieldProperties -> Field
select =
    StringField_ << SelectField


{-| -}
httpSelect : HttpSelectFieldProperties -> Field
httpSelect =
    StringField_ << HttpSelectField


{-| -}
multiSelect : MultiSelectFieldProperties {} -> Field
multiSelect =
    MultiStringField_ << MultiSelectField


{-| -}
searchableMultiSelect : SearchableMultiSelectFieldProperties -> Field
searchableMultiSelect =
    MultiStringField_ << SearchableMultiSelectField


{-| -}
multiHttpSelect : MultiHttpSelectFieldProperties -> Field
multiHttpSelect =
    MultiStringField_ << MultiHttpSelectField


{-| -}
radio : RadioFieldProperties -> Field
radio =
    StringField_ << RadioField


{-| -}
age : AgeFieldProperties -> Field
age =
    NumericField_ << AgeField


{-| -}
type Field
    = StringField_ StringField
    | MultiStringField_ MultiStringField
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
    | RadioBoolField RadioBoolFieldProperties
    | RadioEnumField RadioEnumFieldProperties


{-| -}
type NumericField
    = AgeField AgeFieldProperties


{-| -}
type MultiStringField
    = MultiSelectField (MultiSelectFieldProperties {})
    | SearchableMultiSelectField SearchableMultiSelectFieldProperties
    | MultiHttpSelectField MultiHttpSelectFieldProperties


{-| -}
type alias FieldProperties a =
    { a
        | required : Required.IsRequired
        , label : String
        , width : Width.Width
        , enabledBy : Maybe String
        , order : Int
        , disabled : Bool
        , hidden : Bool
        , unhiddenBy : Maybe String
    }


{-| -}
type alias CommonFieldProperties =
    FieldProperties {}


{-| -}
type alias StringFieldProperties a =
    FieldProperties
        { a
            | value : String
        }


{-| -}
type alias SimpleFieldProperties =
    StringFieldProperties
        { tipe : FieldType.SimpleFieldType
        }


{-| -}
type alias SelectFieldProperties =
    StringFieldProperties
        { default : Maybe String
        , options : List Option.Option
        }


{-| -}
type alias HttpSelectFieldProperties =
    StringFieldProperties
        { url : String
        , default : Maybe String
        , options : RemoteData.RemoteData (HttpDetailed.Error String) (List Option.Option)
        }


{-| -}
type alias MultiStringFieldProperties a =
    FieldProperties { a | value : Set.Set String }


{-| -}
type alias MultiSelectFieldProperties a =
    MultiStringFieldProperties
        { a
            | placeholder : String
            , showDropdown : Bool
            , options : List Option.Option
        }


{-| -}
type alias SearchableMultiSelectFieldProperties =
    MultiSelectFieldProperties
        { searchableOptions : List Option.Option
        , searchInput : String
        }


{-| -}
type alias MultiHttpSelectFieldProperties =
    MultiStringFieldProperties
        { placeholder : String
        , showDropdown : Bool
        , url : String
        , options : RemoteData.RemoteData (HttpDetailed.Error String) (List Option.Option)
        }


{-| -}
type alias RadioFieldProperties =
    StringFieldProperties { default : Maybe String, options : List Option.Option, direction : Direction.Direction }


{-| -}
type alias BoolFieldProperties a =
    FieldProperties { a | value : Bool }


{-| -}
type alias CheckboxFieldProperties =
    BoolFieldProperties { tipe : FieldType.CheckboxFieldType }


{-| -}
type alias RadioEnumFieldProperties =
    FieldProperties { value : Maybe RadioEnum.Value, default : Maybe RadioEnum.Value, options : List RadioEnum.Value }


{-| -}
type alias RadioBoolFieldProperties =
    FieldProperties { value : Maybe Bool }


{-| -}
type alias AgeFieldProperties =
    FieldProperties { value : Maybe Int }


{-| -}
getProperties : Field -> CommonFieldProperties
getProperties field =
    case field of
        StringField_ stringProperties ->
            getStringProperties stringProperties
                |> getCommonProperties

        MultiStringField_ multiStringProperties ->
            getMultiStringProperties multiStringProperties
                |> getCommonProperties

        BoolField_ (CheckboxField properties) ->
            getCommonProperties properties

        BoolField_ (RadioBoolField properties) ->
            getCommonProperties properties

        BoolField_ (RadioEnumField properties) ->
            getCommonProperties properties

        NumericField_ (AgeField properties) ->
            getCommonProperties properties


getCommonProperties : FieldProperties a -> CommonFieldProperties
getCommonProperties { required, label, width, enabledBy, order, disabled, hidden, unhiddenBy } =
    { required = required
    , label = label
    , width = width
    , enabledBy = enabledBy
    , order = order
    , disabled = disabled
    , hidden = hidden
    , unhiddenBy = unhiddenBy
    }


getStringProperties : StringField -> FieldProperties { value : String }
getStringProperties field =
    case field of
        HttpSelectField { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } ->
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , value = value
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            }

        SimpleField { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } ->
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , value = value
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            }

        SelectField { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } ->
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , value = value
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            }

        RadioField { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } ->
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , value = value
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            }


{-| -}
getMultiStringProperties : MultiStringField -> FieldProperties { value : Set.Set String }
getMultiStringProperties field =
    case field of
        MultiHttpSelectField { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } ->
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , value = value
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            }

        MultiSelectField { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } ->
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , value = value
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            }

        SearchableMultiSelectField { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } ->
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , value = value
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            }


{-| Keep existing field if the value is Nothing
-}
maybeUpdateStringValue : Maybe String -> Field -> Field
maybeUpdateStringValue maybeValue field =
    Maybe.map (\str -> updateStringValue str field) maybeValue
        |> Maybe.withDefault field


{-| -}
updateStringValue : String -> Field -> Field
updateStringValue value field =
    case field of
        StringField_ _ ->
            genericUpdateStringField updateStringValue_ value field

        _ ->
            field


{-| -}
updateStringDisabled : Bool -> Field -> Field
updateStringDisabled value field =
    case field of
        StringField_ _ ->
            genericUpdateStringField updateStringDisabled_ value field

        _ ->
            field


{-| -}
updateStringHidden : Bool -> Field -> Field
updateStringHidden value field =
    case field of
        StringField_ _ ->
            genericUpdateStringField updateStringHidden_ value field

        _ ->
            field


genericUpdateStringField : (a -> StringField -> StringField) -> a -> Field -> Field
genericUpdateStringField f value field =
    case field of
        StringField_ stringField ->
            StringField_ <| f value stringField

        _ ->
            field


{-| -}
updateMultiStringOption : Option.Option -> Bool -> Field -> Field
updateMultiStringOption option checked field =
    case field of
        MultiStringField_ multiStringField ->
            MultiStringField_ <| updateMultiStringOption_ option checked multiStringField

        _ ->
            field


{-| -}
updateSearchableMultiselectInput : String -> Field -> Field
updateSearchableMultiselectInput input field =
    case field of
        MultiStringField_ (SearchableMultiSelectField properties) ->
            MultiStringField_ (SearchableMultiSelectField { properties | searchInput = input })

        _ ->
            field


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

        MultiStringField_ multiStringField ->
            MultiStringField_ (resetMultiStringFieldValueToDefault multiStringField)

        BoolField_ (CheckboxField properties) ->
            BoolField_ (CheckboxField { properties | value = False })

        BoolField_ (RadioBoolField properties) ->
            BoolField_ (RadioBoolField { properties | value = Nothing })

        BoolField_ (RadioEnumField properties) ->
            BoolField_ (RadioEnumField { properties | value = properties.default })

        NumericField_ (AgeField properties) ->
            NumericField_ (AgeField { properties | value = Nothing })


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


resetMultiStringFieldValueToDefault : MultiStringField -> MultiStringField
resetMultiStringFieldValueToDefault field =
    case field of
        MultiHttpSelectField properties ->
            MultiHttpSelectField { properties | value = Set.empty }

        MultiSelectField properties ->
            MultiSelectField { properties | value = Set.empty }

        SearchableMultiSelectField properties ->
            SearchableMultiSelectField { properties | value = Set.empty, searchInput = "" }


{-| -}
setRequired : Required.IsRequired -> Field -> Field
setRequired required field =
    case field of
        StringField_ (SimpleField properties) ->
            StringField_ (SimpleField { properties | required = required })

        StringField_ (SelectField properties) ->
            StringField_ (SelectField { properties | required = required })

        StringField_ (HttpSelectField properties) ->
            StringField_ (HttpSelectField { properties | required = required })

        StringField_ (RadioField properties) ->
            StringField_ (RadioField { properties | required = required })

        MultiStringField_ (MultiHttpSelectField properties) ->
            MultiStringField_ (MultiHttpSelectField { properties | required = required })

        MultiStringField_ (MultiSelectField properties) ->
            MultiStringField_ (MultiSelectField { properties | required = required })

        MultiStringField_ (SearchableMultiSelectField properties) ->
            MultiStringField_ (SearchableMultiSelectField { properties | required = required })

        BoolField_ (CheckboxField properties) ->
            BoolField_ (CheckboxField { properties | required = required })

        BoolField_ (RadioBoolField properties) ->
            BoolField_ (RadioBoolField { properties | required = required })

        BoolField_ (RadioEnumField properties) ->
            BoolField_ (RadioEnumField { properties | required = required })

        NumericField_ (AgeField properties) ->
            NumericField_ (AgeField { properties | required = required })


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
updateShowDropdown : Bool -> Field -> Field
updateShowDropdown showDropdown field =
    case field of
        MultiStringField_ (MultiSelectField properties) ->
            MultiStringField_ (MultiSelectField { properties | showDropdown = showDropdown })

        MultiStringField_ (SearchableMultiSelectField properties) ->
            MultiStringField_ (SearchableMultiSelectField { properties | showDropdown = showDropdown })

        MultiStringField_ (MultiHttpSelectField properties) ->
            MultiStringField_ (MultiHttpSelectField { properties | showDropdown = showDropdown })

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
updateStringDisabled_ : Bool -> StringField -> StringField
updateStringDisabled_ value field =
    case field of
        SimpleField properties ->
            SimpleField { properties | disabled = value }

        SelectField properties ->
            SelectField { properties | disabled = value }

        HttpSelectField properties ->
            HttpSelectField { properties | disabled = value }

        RadioField properties ->
            RadioField { properties | disabled = value }


{-| -}
updateStringHidden_ : Bool -> StringField -> StringField
updateStringHidden_ value field =
    case field of
        SimpleField properties ->
            SimpleField { properties | hidden = value }

        SelectField properties ->
            SelectField { properties | hidden = value }

        HttpSelectField properties ->
            HttpSelectField { properties | hidden = value }

        RadioField properties ->
            RadioField { properties | hidden = value }


updateMultiStringOption_ : Option.Option -> Bool -> MultiStringField -> MultiStringField
updateMultiStringOption_ option checked field =
    let
        update properties =
            { properties
                | value =
                    if checked then
                        Set.insert option.value properties.value

                    else
                        Set.remove option.value properties.value
            }
    in
    case field of
        MultiSelectField properties ->
            MultiSelectField (update properties)

        SearchableMultiSelectField properties ->
            SearchableMultiSelectField (update properties)

        MultiHttpSelectField properties ->
            MultiHttpSelectField (update properties)


{-| -}
updateMultiStringValue_ : Set.Set String -> MultiStringField -> MultiStringField
updateMultiStringValue_ value field =
    case field of
        MultiSelectField properties ->
            MultiSelectField { properties | value = value }

        SearchableMultiSelectField properties ->
            SearchableMultiSelectField { properties | value = value }

        MultiHttpSelectField properties ->
            MultiHttpSelectField { properties | value = value }


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
updateNumericValue_ value (AgeField properties) =
    AgeField { properties | value = value }


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
getUnhiddenBy : Field -> Maybe String
getUnhiddenBy =
    getProperties >> .unhiddenBy


{-| -}
getStringValue_ : StringField -> String
getStringValue_ =
    getStringProperties >> .value


{-| -}
getMultiStringValue_ : MultiStringField -> Set.Set String
getMultiStringValue_ =
    getMultiStringProperties >> .value


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
        NumericField_ (AgeField { value }) ->
            value

        _ ->
            Nothing


{-| -}
isRequired : Field -> Required.IsRequired
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
getType : Field -> FieldType.FieldType
getType field =
    case field of
        StringField_ stringField ->
            FieldType.StringType <| getStringType stringField

        MultiStringField_ multiStringField ->
            FieldType.MultiStringType <| getMultiStringType multiStringField

        BoolField_ (CheckboxField { tipe }) ->
            FieldType.BoolType (FieldType.CheckboxType tipe)

        BoolField_ (RadioBoolField _) ->
            FieldType.BoolType FieldType.RadioBool

        BoolField_ (RadioEnumField _) ->
            FieldType.BoolType FieldType.RadioEnum

        NumericField_ (AgeField _) ->
            FieldType.NumericType FieldType.Age


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
getMultiStringType : MultiStringField -> FieldType.MultiStringFieldType
getMultiStringType field =
    case field of
        MultiSelectField _ ->
            FieldType.MultiSelect

        MultiHttpSelectField _ ->
            FieldType.MultiHttpSelect

        SearchableMultiSelectField _ ->
            FieldType.SearchableMultiSelect


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
            let
                trimmed =
                    String.trim (getStringValue_ stringField)
            in
            if String.isEmpty trimmed && isRequired field == Required.Nullable then
                Encode.null

            else
                Encode.string <| getStringValue_ stringField

        MultiStringField_ multiStringField ->
            multiStringField
                |> (getMultiStringProperties >> .value)
                |> Set.toList
                |> Encode.list Encode.string

        BoolField_ (CheckboxField { value }) ->
            Encode.bool value

        BoolField_ (RadioEnumField { value }) ->
            EncodeExtra.maybe Encode.bool (RadioEnum.toBool value)

        BoolField_ (RadioBoolField { value }) ->
            EncodeExtra.maybe Encode.bool value

        NumericField_ (AgeField { value }) ->
            EncodeExtra.maybe Encode.int value


{-| -}
metadataKey : String -> Maybe String
metadataKey string =
    case String.split "." string of
        [ "metadata", key ] ->
            Just key

        _ ->
            Nothing
