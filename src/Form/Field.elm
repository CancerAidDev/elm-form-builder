module Form.Field exposing
    ( Field(..), StringField(..), MultiStringField(..), BoolField(..), NumericField(..)
    , AgeFieldProperties, CommonFieldProperties, DateFieldProperties, SimpleFieldProperties, SelectFieldProperties, HttpSelectFieldProperties, MultiSelectFieldProperties, SearchableMultiSelectFieldProperties, MultiHttpSelectFieldProperties, RadioFieldProperties, BoolFieldProperties, CheckboxFieldProperties, RadioBoolFieldProperties, RadioEnumFieldProperties, StringFieldProperties, TagFieldProperties
    , mkAgeField, mkCheckbox, mkDate, mkHttpSelect, mkInput, mkMultiHttpSelect, mkMultiSelect, mkRadio, mkRadioBool, mkRadioEnum, mkSearchableMultiSelect, mkSelect, mkTag
    , setDateFuture, setDateOfBirth, setDefault, setDirection, setDisabled, setEmail, setEnabledBy, setForbiddenEmailDomains, setHidden, setIsRequired, setLabel, setOptions, setOrder, setPhone, setPlaceholder, setRegexValidation, setRemoteUrl, setSearchableOptions, setSelectablePlaceholder, setTagsInputBar, setTextArea, setUnhiddenBy, setUrl, setValue, setWidth
    , getBoolProperties, getEnabledBy, getUnhiddenBy, getLabel, getNumericValue, getOrder, getProperties, getStringType, getStringValue, getStringValue_, getParsedDateValue_, getMultiStringValue_, getType, getUrl, getWidth
    , resetValueToDefault, setRequired, updateBoolValue, updateCheckboxValue_, updateNumericValue, updateNumericValue_, updateRadioBoolValue, updateRadioBoolValue_, updateRadioEnumValue, updateRadioEnumValue_, updateRemoteOptions, updateStringValue, updateParsedDateValue, updateStringDisabled, updateStringHidden, updateMultiStringOption, updateStringValue_, updateStringDisabled_, updateStringHidden_, updateMultiStringValue_, updateShowDropdown, maybeUpdateStringValue, updateSearchableMultiselectInput, updateTagsInputBarValue, updateTagsValue, updateTagsValue_
    , isCheckbox, isColumn, isNumericField, isRequired
    , encode
    , metadataKey
    )

{-| Field type and helper functions


# Field

@docs Field, StringField, MultiStringField, BoolField, NumericField


# Properties

@docs AgeFieldProperties, CommonFieldProperties, DateFieldProperties, SimpleFieldProperties, SelectFieldProperties, HttpSelectFieldProperties, MultiSelectFieldProperties, SearchableMultiSelectFieldProperties, MultiHttpSelectFieldProperties, RadioFieldProperties, BoolFieldProperties, CheckboxFieldProperties, RadioBoolFieldProperties, RadioEnumFieldProperties, StringFieldProperties, TagFieldProperties


# Constructors

@docs mkAgeField, mkCheckbox, mkDate, mkHttpSelect, mkInput, mkMultiHttpSelect, mkMultiSelect, mkRadio, mkRadioBool, mkRadioEnum, mkSearchableMultiSelect, mkSelect, mkTag


# Construction Property Setters

@docs setDateFuture, setDateOfBirth, setDefault, setDirection, setDisabled, setEmail, setEnabledBy, setForbiddenEmailDomains, setHidden, setIsRequired, setLabel, setOptions, setOrder, setPhone, setPlaceholder, setRegexValidation, setRemoteUrl, setSearchableOptions, setSelectablePlaceholder, setTagsInputBar, setTextArea, setUnhiddenBy, setUrl, setValue, setWidth


# Getters

@docs getBoolProperties, getEnabledBy, getUnhiddenBy, getLabel, getNumericValue, getOrder, getProperties, getStringType, getStringValue, getStringValue_, getParsedDateValue_, getMultiStringValue_, getType, getUrl, getWidth


# Setters

@docs resetValueToDefault, setRequired, updateBoolValue, updateCheckboxValue_, updateNumericValue, updateNumericValue_, updateRadioBoolValue, updateRadioBoolValue_, updateRadioEnumValue, updateRadioEnumValue_, updateRemoteOptions, updateStringValue, updateParsedDateValue, updateStringDisabled, updateStringHidden, updateMultiStringOption, updateStringValue_, updateStringDisabled_, updateStringHidden_, updateMultiStringValue_, updateShowDropdown, maybeUpdateStringValue, updateSearchableMultiselectInput, updateTagsInputBarValue, updateTagsValue, updateTagsValue_


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



-- MAKERS


{-| Makes an input field, defaulting to text input.

In addition to the common builders, the following are available:

  - `setRegexValidation (List RegexValidation.RegexValidation)`
  - `setEmail`
  - `setPhone`
  - `setUrl`
  - `setTextArea`

If setEmail is used, `setForbiddenEmailDomains` can additionally be used in lieu of `setRegexValidation` for convenience.

-}
mkInput : (SimpleFieldProperties -> SimpleFieldProperties) -> Field
mkInput setters =
    simpleFieldDefaults
        |> setters
        |> StringField_
        << SimpleField


{-| Makes a date input field, defaulting to a DatePast type.

In addition to the common builders, the following are available:

  - `setDateOfBirth`
  - `setDateFuture`

-}
mkDate : (DateFieldProperties -> DateFieldProperties) -> Field
mkDate setters =
    dateFieldDefaults
        |> setters
        |> StringField_
        << DateField


{-| Makes an age input field.
-}
mkAgeField : (AgeFieldProperties -> AgeFieldProperties) -> Field
mkAgeField setters =
    ageFieldDefaults
        |> setters
        |> NumericField_
        << AgeField


{-| Makes a tag field.

In addition to the common builders, the following are available:

  - `setTagsInputBar String`
  - `setPlaceholder (Maybe String)`

-}
mkTag : (TagFieldProperties -> TagFieldProperties) -> Field
mkTag setters =
    tagFieldDefaults
        |> setters
        |> MultiStringField_
        << TagField


{-| Makes a checkbox field.
-}
mkCheckbox : (CheckboxFieldProperties -> CheckboxFieldProperties) -> Field
mkCheckbox setters =
    checkboxFieldDefaults
        |> setters
        |> BoolField_
        << CheckboxField


{-| Makes a radio field.

In addition to the common builders, the following are available:

  - `setDefault String`
  - `setOptions (List Option.Option)`
  - `setDirection Direction.Direction`

A list of options needs to be passed in, but setters passed in will override these.

-}
mkRadio : List Option.Option -> (RadioFieldProperties -> RadioFieldProperties) -> Field
mkRadio options setters =
    radioFieldDefaults
        |> setters
        << setOptions options
        |> StringField_
        << RadioField


{-| Makes a boolean radio field.
-}
mkRadioBool : (RadioBoolFieldProperties -> RadioBoolFieldProperties) -> Field
mkRadioBool setters =
    radioBoolFieldDefaults
        |> setters
        |> BoolField_
        << RadioBoolField


{-| Makes a radio field for selection of Yes/No/N/A enums, with all three as an option by default. Override with setOptions.

In addition to the common builders, the following are available:

  - `setDefault RadioEnum.Value`
  - `setOptions (List RadioEnum.Value)`

-}
mkRadioEnum : (RadioEnumFieldProperties -> RadioEnumFieldProperties) -> Field
mkRadioEnum setters =
    radioEnumFieldDefaults
        |> setters
        |> BoolField_
        << RadioEnumField


{-| Makes a drop-down select field from a list of options.

In addition to the common builders, the following are available:

  - `setDefault String`
  - `setOptions (List Option.Option)`
  - `setPlaceholder String`
  - `setSelectablePlaceholder`

A list of options needs to be passed in, but setters passed in will override these.

-}
mkSelect : List Option.Option -> (SelectFieldProperties -> SelectFieldProperties) -> Field
mkSelect options setters =
    selectFieldDefaults
        |> setters
        << setOptions options
        |> StringField_
        << SelectField


{-| Makes a remotely fetched drop-down select field.

In addition to the common builders, the following are available:

  - `setDefault String`
  - `setOptions (RemoteData.RemoteData (HttpDetailed.Error String) (List Option.Option))`
  - `setPlaceholder String`
  - `setRemoteUrl String`
  - `setSelectablePlaceholder`

-}
mkHttpSelect : String -> (HttpSelectFieldProperties -> HttpSelectFieldProperties) -> Field
mkHttpSelect url_ setters =
    httpSelectFieldDefaults
        |> setters
        << setRemoteUrl url_
        |> StringField_
        << HttpSelectField


{-| Makes a multi select field from a list of options.

In addition to the common builders, the following are available:

  - `setOptions (List Option.Option)`
  - `setPlaceholder String`

A list of options needs to be passed in, but setters passed in will override these.

-}
mkMultiSelect : List Option.Option -> (MultiSelectFieldProperties {} -> MultiSelectFieldProperties {}) -> Field
mkMultiSelect options setters =
    multiSelectFieldDefaults
        |> setters
        << setOptions options
        |> MultiStringField_
        << MultiSelectField


{-| Makes a searchable multi select field, with two categories of options: searchable and non-searchable. Neither category is mandatory, so make sure to set at least one for the field to be useful.

In addition to the common builders, the following are available:

  - `setOptions (List Option.Option)`
  - `setSearchableOptions (List Option.Option)`
  - `setPlaceholder String`

-}
mkSearchableMultiSelect : (SearchableMultiSelectFieldProperties -> SearchableMultiSelectFieldProperties) -> Field
mkSearchableMultiSelect setters =
    searchableMultiSelectFieldDefaults
        |> setters
        |> MultiStringField_
        << SearchableMultiSelectField


{-| Makes a remotely fetched multi select field.

In addition to the common builders, the following are available:

  - `setOptions (List Option.Option)`
  - `setPlaceholder String`
  - `setRemoteUrl String`

-}
mkMultiHttpSelect : String -> (MultiHttpSelectFieldProperties -> MultiHttpSelectFieldProperties) -> Field
mkMultiHttpSelect url_ setters =
    multiHttpSelectFieldDefaults
        |> setters
        << setRemoteUrl url_
        |> MultiStringField_
        << MultiHttpSelectField



-- SETTERS


{-| -}
setIsRequired : Required.IsRequired -> FieldProperties a -> FieldProperties a
setIsRequired required field =
    { field | required = required }


{-| -}
setLabel : String -> FieldProperties a -> FieldProperties a
setLabel label field =
    { field | label = label }


{-| -}
setWidth : Width.Width -> FieldProperties a -> FieldProperties a
setWidth width field =
    { field | width = width }


{-| -}
setEnabledBy : String -> FieldProperties a -> FieldProperties a
setEnabledBy enabledBy field =
    { field | enabledBy = Just enabledBy }


{-| -}
setOrder : Int -> FieldProperties a -> FieldProperties a
setOrder order field =
    { field | order = order }


{-| -}
setDisabled : Bool -> FieldProperties a -> FieldProperties a
setDisabled disabled field =
    { field | disabled = disabled }


{-| -}
setHidden : Bool -> FieldProperties a -> FieldProperties a
setHidden hidden field =
    { field | hidden = hidden }


{-| -}
setUnhiddenBy : String -> FieldProperties a -> FieldProperties a
setUnhiddenBy unhiddenBy field =
    { field | unhiddenBy = Just unhiddenBy }


{-| -}
setRegexValidation : List RegexValidation.RegexValidation -> SimpleFieldProperties -> SimpleFieldProperties
setRegexValidation regexValidation field =
    { field | regexValidation = regexValidation }


{-| -}
setForbiddenEmailDomains : List EmailFormat.ForbiddenDomain -> SimpleFieldProperties -> SimpleFieldProperties
setForbiddenEmailDomains forbiddenDomains field =
    { field
        | regexValidation =
            RegexValidation.fromSuffixConstraints <|
                List.map
                    (\forbiddenDomain -> ( forbiddenDomain.domain, forbiddenDomain.message ))
                    forbiddenDomains
    }


{-| -}
setTagsInputBar : String -> TagFieldProperties -> TagFieldProperties
setTagsInputBar inputBar field =
    { field | inputBar = inputBar }


{-| This shouldn't be exposed for safety purposes - make custom builders instead.
-}
setTipe : t -> FieldProperties { a | tipe : t } -> FieldProperties { a | tipe : t }
setTipe tipe field =
    { field | tipe = tipe }


{-| -}
setValue : v -> FieldProperties { a | value : v } -> FieldProperties { a | value : v }
setValue value field =
    { field | value = value }


{-| -}
setDefault : d -> FieldProperties { a | default : Maybe d } -> FieldProperties { a | default : Maybe d }
setDefault default field =
    { field | default = Just default }


{-| -}
setOptions : o -> FieldProperties { a | options : o } -> FieldProperties { a | options : o }
setOptions options field =
    { field | options = options }


{-| -}
setPlaceholder : p -> FieldProperties { a | placeholder : p } -> FieldProperties { a | placeholder : p }
setPlaceholder placeholder field =
    { field | placeholder = placeholder }


{-| -}
setSelectablePlaceholder : FieldProperties { a | hasSelectablePlaceholder : Bool } -> FieldProperties { a | hasSelectablePlaceholder : Bool }
setSelectablePlaceholder field =
    { field | hasSelectablePlaceholder = True }


{-| -}
setRemoteUrl : String -> FieldProperties { a | url : String } -> FieldProperties { a | url : String }
setRemoteUrl url_ field =
    { field | url = url_ }


{-| -}
setSearchableOptions : List Option.Option -> SearchableMultiSelectFieldProperties -> SearchableMultiSelectFieldProperties
setSearchableOptions searchableOptions field =
    { field | searchableOptions = searchableOptions }


{-| -}
setEmail : SimpleFieldProperties -> SimpleFieldProperties
setEmail =
    setTipe FieldType.Email


{-| -}
setPhone : SimpleFieldProperties -> SimpleFieldProperties
setPhone =
    setTipe FieldType.Phone


{-| -}
setUrl : SimpleFieldProperties -> SimpleFieldProperties
setUrl =
    setTipe FieldType.Url


{-| -}
setTextArea : SimpleFieldProperties -> SimpleFieldProperties
setTextArea =
    setTipe FieldType.TextArea


{-| -}
setDateOfBirth : DateFieldProperties -> DateFieldProperties
setDateOfBirth =
    setTipe FieldType.DateOfBirth


{-| -}
setDateFuture : DateFieldProperties -> DateFieldProperties
setDateFuture =
    setTipe FieldType.DateFuture


{-| -}
setDirection : Direction.Direction -> RadioFieldProperties -> RadioFieldProperties
setDirection direction field =
    { field | direction = direction }



-- DEFAULTS


simpleFieldDefaults : SimpleFieldProperties
simpleFieldDefaults =
    { required = Required.No
    , label = ""
    , width = Width.FullSize
    , enabledBy = Nothing
    , order = 0
    , disabled = False
    , hidden = False
    , unhiddenBy = Nothing
    , regexValidation = []
    , tipe = FieldType.Text
    , value = ""
    }


dateFieldDefaults : DateFieldProperties
dateFieldDefaults =
    { required = Required.No
    , label = ""
    , width = Width.FullSize
    , enabledBy = Nothing
    , order = 0
    , disabled = False
    , hidden = False
    , unhiddenBy = Nothing
    , tipe = FieldType.DatePast
    , value = ""
    , parsedDate = Nothing
    }


tagFieldDefaults : TagFieldProperties
tagFieldDefaults =
    { required = Required.No
    , label = ""
    , width = Width.FullSize
    , enabledBy = Nothing
    , order = 0
    , disabled = False
    , hidden = False
    , unhiddenBy = Nothing
    , value = Set.empty
    , inputBar = ""
    , placeholder = Nothing
    }


checkboxFieldDefaults : CheckboxFieldProperties
checkboxFieldDefaults =
    { required = Required.No
    , label = ""
    , width = Width.FullSize
    , enabledBy = Nothing
    , order = 0
    , disabled = False
    , hidden = False
    , unhiddenBy = Nothing
    , value = False
    , tipe = FieldType.Checkbox
    }


radioBoolFieldDefaults : RadioBoolFieldProperties
radioBoolFieldDefaults =
    { required = Required.No
    , label = ""
    , width = Width.FullSize
    , enabledBy = Nothing
    , order = 0
    , disabled = False
    , hidden = False
    , unhiddenBy = Nothing
    , value = Nothing
    }


radioEnumFieldDefaults : RadioEnumFieldProperties
radioEnumFieldDefaults =
    { required = Required.No
    , label = ""
    , width = Width.FullSize
    , enabledBy = Nothing
    , order = 0
    , disabled = False
    , hidden = False
    , unhiddenBy = Nothing
    , value = Nothing
    , default = Nothing
    , options = [ RadioEnum.Yes, RadioEnum.No, RadioEnum.NA ]
    }


selectFieldDefaults : SelectFieldProperties
selectFieldDefaults =
    { required = Required.No
    , label = ""
    , width = Width.FullSize
    , enabledBy = Nothing
    , order = 0
    , disabled = False
    , hidden = False
    , unhiddenBy = Nothing
    , value = ""
    , default = Nothing
    , options = []
    , placeholder = ""
    , hasSelectablePlaceholder = False
    }


httpSelectFieldDefaults : HttpSelectFieldProperties
httpSelectFieldDefaults =
    { required = Required.No
    , label = ""
    , width = Width.FullSize
    , enabledBy = Nothing
    , order = 0
    , disabled = False
    , hidden = False
    , unhiddenBy = Nothing
    , value = ""
    , url = ""
    , default = Nothing
    , options = RemoteData.NotAsked
    , placeholder = ""
    , hasSelectablePlaceholder = False
    }


multiSelectFieldDefaults : MultiSelectFieldProperties {}
multiSelectFieldDefaults =
    { required = Required.No
    , label = ""
    , width = Width.FullSize
    , enabledBy = Nothing
    , order = 0
    , disabled = False
    , hidden = False
    , unhiddenBy = Nothing
    , value = Set.empty
    , options = []
    , placeholder = ""
    , showDropdown = False
    }


searchableMultiSelectFieldDefaults : SearchableMultiSelectFieldProperties
searchableMultiSelectFieldDefaults =
    { required = Required.No
    , label = ""
    , width = Width.FullSize
    , enabledBy = Nothing
    , order = 0
    , disabled = False
    , hidden = False
    , unhiddenBy = Nothing
    , value = Set.empty
    , options = []
    , placeholder = ""
    , showDropdown = False
    , searchableOptions = []
    , searchInput = ""
    }


multiHttpSelectFieldDefaults : MultiHttpSelectFieldProperties
multiHttpSelectFieldDefaults =
    { required = Required.No
    , label = ""
    , width = Width.FullSize
    , enabledBy = Nothing
    , order = 0
    , disabled = False
    , hidden = False
    , unhiddenBy = Nothing
    , value = Set.empty
    , options = RemoteData.NotAsked
    , placeholder = ""
    , showDropdown = False
    , url = ""
    }


radioFieldDefaults : RadioFieldProperties
radioFieldDefaults =
    { required = Required.No
    , label = ""
    , width = Width.FullSize
    , enabledBy = Nothing
    , order = 0
    , disabled = False
    , hidden = False
    , unhiddenBy = Nothing
    , value = ""
    , default = Nothing
    , options = []
    , direction = Direction.Column
    }


ageFieldDefaults : AgeFieldProperties
ageFieldDefaults =
    { required = Required.No
    , label = ""
    , width = Width.FullSize
    , enabledBy = Nothing
    , order = 0
    , disabled = False
    , hidden = False
    , unhiddenBy = Nothing
    , value = Nothing
    }



-- TYPES


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
    | TagField TagFieldProperties


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
type alias TagFieldProperties =
    MultiStringFieldProperties
        { inputBar : String
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
        }


{-| -}
type alias SelectFieldProperties =
    StringFieldProperties
        { default : Maybe String
        , options : List Option.Option
        , placeholder : String
        , hasSelectablePlaceholder : Bool
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

        DateField properties ->
            DateField { properties | value = "", parsedDate = Nothing }

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
updateNumericValue_ value (AgeField properties) =
    AgeField { properties | value = value }


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


{-| -}
metadataKey : String -> Maybe String
metadataKey string =
    case String.split "." string of
        [ "metadata", key ] ->
            Just key

        _ ->
            Nothing
