module Form.Field exposing
    ( Field(..), StringField(..), MultiStringField(..), BoolField(..), NumericField(..), text, email, date, phone, url, textarea, checkbox, radioBool, radioEnum, select, searchableSelect, httpSelect, multiSelect, searchableMultiSelect, multiHttpSelect, radio, age, numericText, tag
    , AgeFieldProperties, NumericTextFieldProperties, CommonFieldProperties, DateFieldProperties, SimpleFieldProperties, SelectFieldProperties, SearchableSelectFieldProperties, HttpSelectFieldProperties, MultiSelectFieldProperties, SearchableMultiSelectFieldProperties, MultiHttpSelectFieldProperties, RadioFieldProperties, BoolFieldProperties, CheckboxFieldProperties, RadioBoolFieldProperties, RadioEnumFieldProperties, StringFieldProperties, TagFieldProperties
    , getBoolProperties, getEnabledBy, getUnhiddenBy, getLabel, getNumericValue, getOrder, getProperties, getStringType, getStringValue, getStringValue_, getParsedDateValue_, getMultiStringValue_, getType, getUrl, getWidth
    , resetValueToDefault, setRequired, updateBoolValue, updateCheckboxValue_, updateNumericValue, updateNumericValue_, updateRadioBoolValue, updateRadioBoolValue_, updateRadioEnumValue, updateRadioEnumValue_, updateRemoteOptions, updateStringValue, updateParsedDateValue, updateStringDisabled, updateStringHidden, updateMultiStringOption, updateStringValue_, updateStringDisabled_, updateStringHidden_, updateMultiStringValue_, updateShowDropdown, maybeUpdateStringValue, updateSearchableSelectInput, updateTagsInputBarValue, updateTagsValue, updateTagsValue_
    , isCheckbox, isColumn, isNumericField, isRequired
    , encode
    , metadataKey
    , dateOfBirth
    )

{-| Field type and helper functions


# Field

@docs Field, StringField, MultiStringField, BoolField, NumericField, text, email, date, phone, url, textarea, checkbox, radioBool, radioEnum, select, searchableSelect, httpSelect, multiSelect, searchableMultiSelect, multiHttpSelect, radio, age, numericText, tag


# Properties

@docs AgeFieldProperties, NumericTextFieldProperties, CommonFieldProperties, DateFieldProperties, SimpleFieldProperties, SelectFieldProperties, SearchableSelectFieldProperties, HttpSelectFieldProperties, MultiSelectFieldProperties, SearchableMultiSelectFieldProperties, MultiHttpSelectFieldProperties, RadioFieldProperties, BoolFieldProperties, CheckboxFieldProperties, RadioBoolFieldProperties, RadioEnumFieldProperties, StringFieldProperties, TagFieldProperties


# Getters

@docs getBoolProperties, getEnabledBy, getUnhiddenBy, getLabel, getNumericValue, getOrder, getProperties, getStringType, getStringValue, getStringValue_, getParsedDateValue_, getMultiStringValue_, getType, getUrl, getWidth


# Setters

@docs resetValueToDefault, setRequired, updateBoolValue, updateCheckboxValue_, updateNumericValue, updateNumericValue_, updateRadioBoolValue, updateRadioBoolValue_, updateRadioEnumValue, updateRadioEnumValue_, updateRemoteOptions, updateStringValue, updateParsedDateValue, updateStringDisabled, updateStringHidden, updateMultiStringOption, updateStringValue_, updateStringDisabled_, updateStringHidden_, updateMultiStringValue_, updateShowDropdown, maybeUpdateStringValue, updateSearchableSelectInput, updateTagsInputBarValue, updateTagsValue, updateTagsValue_


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
import Form.Format.Email as EmailFormat
import Form.Lib.RegexValidation as RegexValidation
import Http.Detailed as HttpDetailed
import Json.Encode as Encode
import Json.Encode.Extra as EncodeExtra
import RemoteData
import Set
import Time



-- change these to use a list of regexvalidations instead


{-| -}
text : StringFieldProperties { regexValidation : List RegexValidation.RegexValidation } -> Field
text { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy, regexValidation } =
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
            , regexValidation = regexValidation
            }


{-| -}
tag : TagFieldProperties {} -> Field
tag { required, label, width, enabledBy, order, value, inputBar, disabled, hidden, unhiddenBy, placeholder } =
    MultiStringField_ <|
        TagField
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , value = value
            , inputBar = inputBar
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            , placeholder = placeholder
            }


{-| -}
email : StringFieldProperties { forbiddenDomains : List EmailFormat.ForbiddenDomain } -> Field
email { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy, forbiddenDomains } =
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
            , regexValidation =
                RegexValidation.fromSuffixConstraints <|
                    List.map
                        (\forbiddenDomain -> ( forbiddenDomain.domain, forbiddenDomain.message ))
                        forbiddenDomains
            }


{-| -}
date : StringFieldProperties { minDate : Maybe Time.Posix, maxDate : Maybe Time.Posix } -> Field
date { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy, minDate, maxDate } =
    StringField_ <|
        DateField
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , tipe = FieldType.Date
            , value = value
            , parsedDate = Nothing
            , minDate = minDate
            , maxDate = maxDate
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            }


{-| -}
dateOfBirth : StringFieldProperties { minDate : Maybe Time.Posix, maxDate : Maybe Time.Posix } -> Field
dateOfBirth { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy, minDate, maxDate } =
    StringField_ <|
        DateField
            { required = required
            , label = label
            , width = width
            , enabledBy = enabledBy
            , order = order
            , tipe = FieldType.DateOfBirth
            , value = value
            , parsedDate = Nothing
            , minDate = minDate
            , maxDate = maxDate
            , disabled = disabled
            , hidden = hidden
            , unhiddenBy = unhiddenBy
            }


{-| -}
phone : StringFieldProperties { regexValidation : List RegexValidation.RegexValidation } -> Field
phone { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy, regexValidation } =
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
            , regexValidation = regexValidation
            }


{-| -}
url : StringFieldProperties { regexValidation : List RegexValidation.RegexValidation } -> Field
url { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy, regexValidation } =
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
            , regexValidation = regexValidation
            }


{-| -}
textarea : StringFieldProperties { regexValidation : List RegexValidation.RegexValidation } -> Field
textarea { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy, regexValidation } =
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
            , regexValidation = regexValidation
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
select : SelectFieldProperties {} -> Field
select =
    StringField_ << SelectField


{-| -}
searchableSelect : SearchableSelectFieldProperties -> Field
searchableSelect =
    StringField_ << SearchableSelectField


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
numericText : NumericTextFieldProperties -> Field
numericText =
    NumericField_ << NumericTextField


{-| -}
type Field
    = StringField_ StringField
    | MultiStringField_ MultiStringField
    | BoolField_ BoolField
    | NumericField_ NumericField


{-| -}
type StringField
    = SimpleField SimpleFieldProperties
    | DateField DateFieldProperties
    | SelectField (SelectFieldProperties {})
    | SearchableSelectField SearchableSelectFieldProperties
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
    | NumericTextField NumericTextFieldProperties


{-| -}
type MultiStringField
    = MultiSelectField (MultiSelectFieldProperties {})
    | SearchableMultiSelectField SearchableMultiSelectFieldProperties
    | MultiHttpSelectField MultiHttpSelectFieldProperties
    | TagField (TagFieldProperties {})


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
type alias TagFieldProperties a =
    MultiStringFieldProperties
        { a
            | inputBar : String
            , placeholder : Maybe String
        }


{-| -}
type alias SimpleFieldProperties =
    StringFieldProperties
        { tipe : FieldType.SimpleFieldType
        , regexValidation : List RegexValidation.RegexValidation
        }


{-| -}
type alias DateFieldProperties =
    StringFieldProperties
        { tipe : FieldType.DateFieldType
        , parsedDate : Maybe Time.Posix
        , minDate : Maybe Time.Posix
        , maxDate : Maybe Time.Posix
        }


{-| -}
type alias SelectFieldProperties a =
    StringFieldProperties
        { a
            | default : Maybe String
            , options : List Option.Option
            , placeholder : String
            , hasSelectablePlaceholder : Bool
        }


{-| -}
type alias SearchableSelectFieldProperties =
    SelectFieldProperties
        { showDropdown : Bool
        , searchInput : String
        }


{-| -}
type alias HttpSelectFieldProperties =
    StringFieldProperties
        { url : String
        , default : Maybe String
        , options : RemoteData.RemoteData (HttpDetailed.Error String) (List Option.Option)
        , placeholder : String
        , hasSelectablePlaceholder : Bool
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
type alias NumericTextFieldProperties =
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

        NumericField_ (NumericTextField properties) ->
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

        DateField { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } ->
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

        SearchableSelectField { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } ->
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

        TagField { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } ->
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


{-| -}
updateParsedDateValue : Time.Posix -> StringField -> StringField
updateParsedDateValue value stringField =
    case stringField of
        DateField properties ->
            DateField { properties | parsedDate = Just value }

        _ ->
            stringField


genericUpdateStringField : (a -> StringField -> StringField) -> a -> Field -> Field
genericUpdateStringField f value field =
    case field of
        StringField_ (SearchableSelectField properties) ->
            StringField_ (f value (SearchableSelectField properties))
                |> updateShowDropdown False

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

        StringField_ stringfield ->
            StringField_ (updateStringValue_ option.value stringfield)
                |> updateShowDropdown False

        _ ->
            field


{-| -}
updateSearchableSelectInput : String -> Field -> Field
updateSearchableSelectInput input field =
    case field of
        StringField_ (SearchableSelectField properties) ->
            StringField_ (SearchableSelectField { properties | searchInput = input })

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

        NumericField_ (NumericTextField properties) ->
            NumericField_ (NumericTextField { properties | value = Nothing })


resetStringFieldValueToDefault : StringField -> StringField
resetStringFieldValueToDefault field =
    case field of
        HttpSelectField properties ->
            HttpSelectField { properties | value = properties.default |> Maybe.withDefault "" }

        SimpleField properties ->
            SimpleField { properties | value = "" }

        DateField properties ->
            DateField { properties | value = "", parsedDate = Nothing }

        SelectField properties ->
            SelectField { properties | value = properties.default |> Maybe.withDefault "" }

        SearchableSelectField properties ->
            SearchableSelectField { properties | value = properties.default |> Maybe.withDefault "" }

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

        TagField properties ->
            TagField { properties | value = Set.empty, inputBar = "" }


{-| -}
setRequired : Required.IsRequired -> Field -> Field
setRequired required field =
    case field of
        StringField_ (SimpleField properties) ->
            StringField_ (SimpleField { properties | required = required })

        StringField_ (DateField properties) ->
            StringField_ (DateField { properties | required = required })

        StringField_ (SelectField properties) ->
            StringField_ (SelectField { properties | required = required })

        StringField_ (SearchableSelectField properties) ->
            StringField_ (SearchableSelectField { properties | required = required })

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

        MultiStringField_ (TagField properties) ->
            MultiStringField_ (TagField { properties | required = required })

        BoolField_ (CheckboxField properties) ->
            BoolField_ (CheckboxField { properties | required = required })

        BoolField_ (RadioBoolField properties) ->
            BoolField_ (RadioBoolField { properties | required = required })

        BoolField_ (RadioEnumField properties) ->
            BoolField_ (RadioEnumField { properties | required = required })

        NumericField_ (AgeField properties) ->
            NumericField_ (AgeField { properties | required = required })

        NumericField_ (NumericTextField properties) ->
            NumericField_ (NumericTextField { properties | required = required })


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
updateTagsValue : Bool -> String -> Field -> Field
updateTagsValue addTag value field =
    case field of
        MultiStringField_ multiStringField ->
            MultiStringField_ <| updateTagsValue_ addTag value multiStringField

        _ ->
            field


{-| -}
updateTagsInputBarValue : String -> Field -> Field
updateTagsInputBarValue input field =
    case field of
        MultiStringField_ (TagField properties) ->
            MultiStringField_ (TagField { properties | inputBar = input })

        _ ->
            field


{-| -}
updateShowDropdown : Bool -> Field -> Field
updateShowDropdown showDropdown field =
    case field of
        StringField_ (SearchableSelectField properties) ->
            StringField_ (SearchableSelectField { properties | showDropdown = showDropdown })

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

        DateField properties ->
            DateField { properties | value = value }

        SelectField properties ->
            SelectField { properties | value = value }

        SearchableSelectField properties ->
            SearchableSelectField { properties | value = value }

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

        DateField properties ->
            DateField { properties | disabled = value }

        SelectField properties ->
            SelectField { properties | disabled = value }

        SearchableSelectField properties ->
            SearchableSelectField { properties | disabled = value }

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

        DateField properties ->
            DateField { properties | hidden = value }

        SelectField properties ->
            SelectField { properties | hidden = value }

        SearchableSelectField properties ->
            SearchableSelectField { properties | hidden = value }

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

        TagField properties ->
            TagField (update properties)


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

        TagField properties ->
            TagField { properties | value = value }


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
updateNumericValue_ value field =
    case field of
        AgeField properties ->
            AgeField { properties | value = value }

        NumericTextField properties ->
            NumericTextField { properties | value = value }


{-| -}
updateTagsValue_ : Bool -> String -> MultiStringField -> MultiStringField
updateTagsValue_ addTag value field =
    case ( field, String.isEmpty value, addTag ) of
        ( TagField properties, False, True ) ->
            TagField
                { properties
                    | value = Set.insert value properties.value
                    , inputBar = ""
                }

        ( TagField properties, False, False ) ->
            TagField { properties | value = Set.remove value properties.value }

        _ ->
            field


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
getParsedDateValue_ : StringField -> Maybe Time.Posix
getParsedDateValue_ field =
    case field of
        DateField props ->
            props.parsedDate

        _ ->
            Nothing


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

        NumericField_ (NumericTextField _) ->
            FieldType.NumericType FieldType.NumericText


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

        DateField properties ->
            FieldType.DateType properties.tipe

        SelectField _ ->
            FieldType.Select

        SearchableSelectField _ ->
            FieldType.SearchableSelect

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

        TagField _ ->
            FieldType.Tags


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

        NumericField_ (NumericTextField { value }) ->
            EncodeExtra.maybe Encode.int value


{-| -}
metadataKey : String -> Maybe String
metadataKey string =
    case String.split "." string of
        [ "metadata", key ] ->
            Just key

        _ ->
            Nothing
