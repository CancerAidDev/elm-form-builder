module Form.Field exposing
    ( Field(..), StringField(..), MultiStringField(..), BoolField(..), NumericField(..)
    , AgeFieldProperties, CommonFieldProperties, PhoneFieldProperties, DateFieldProperties, SimpleFieldProperties, SelectFieldProperties, SearchableSelectFieldProperties, HttpSelectFieldProperties, MultiSelectFieldProperties, SearchableMultiSelectFieldProperties, MultiHttpSelectFieldProperties, RadioFieldProperties, BoolFieldProperties, CheckboxFieldProperties, RadioBoolFieldProperties, RadioEnumFieldProperties, StringFieldProperties, TagFieldProperties, FieldProperties
    , ageDefault, checkboxDefault, dateDefault, emailDefault, httpSelectDefault, searchableSelectDefault, multiHttpSelectDefault, multiSelectDefault, phoneDefault, timeDefault, radioBoolDefault, radioDefault, radioEnumDefault, searchableMultiSelectDefault, selectDefault, tagDefault, textAreaDefault, textDefault, urlDefault
    , age, checkbox, date, httpSelect, text, multiHttpSelect, multiSelect, radio, radioBool, radioEnum, searchableSelect, searchableMultiSelect, select, tag, url, phone, time, textArea, email
    , setDateFuture, setDateOfBirth, setDateOffset, setDateBounds, setDatePast, setDefault, setDirection, setDisabled, setEnabledBy, setForbiddenEmailDomains, setHidden, setIsRequired, setLabel, setOptions, setOrder, setPlaceholder, setRegexValidation, setRemoteUrl, setSearchableOptions, setSelectablePlaceholder, setLocale, setTagsInputBar, setUnhiddenBy, setValue, setWidth
    , getBoolProperties, getEnabledBy, getUnhiddenBy, getLabel, getNumericValue, getOrder, getProperties, getStringType, getStringValue, getStringValue_, getLocale_, getCountryCodeValue_, getParsedDateValue_, getMultiStringValue_, getType, getUrl, getCode
    , resetValueToDefault, updateBoolValue, updateCheckboxValue_, updateNumericValue, updateNumericValue_, updateRadioBoolValue, updateRadioBoolValue_, updateRadioEnumValue, updateRadioEnumValue_, updateRemoteOptions, updateStringValue, updateParsedDateValue, updateStringDisabled, updateMultiStringOption, updateStringValue_, updateMultiStringValue_, updatePhoneShowDropdown, updatePhoneDropdown, updateShowDropdown, maybeUpdateStringValue, updateTagsInputBarValue, updateTagsValue, updateTagsValue_, updateSearchableSelectInput, updatePhoneSearchInput
    , isCheckbox, isRequired
    , encode
    , metadataKey
    , CountryCodeDropdown
    )

{-| Field type and helper functions


# Field

@docs Field, StringField, MultiStringField, BoolField, NumericField


# Properties

@docs AgeFieldProperties, CommonFieldProperties, PhoneFieldProperties, DateFieldProperties, SimpleFieldProperties, SelectFieldProperties, SearchableSelectFieldProperties, HttpSelectFieldProperties, MultiSelectFieldProperties, SearchableMultiSelectFieldProperties, MultiHttpSelectFieldProperties, RadioFieldProperties, BoolFieldProperties, CheckboxFieldProperties, RadioBoolFieldProperties, RadioEnumFieldProperties, StringFieldProperties, TagFieldProperties, FieldProperties


# Default Properties

@docs ageDefault, checkboxDefault, dateDefault, emailDefault, httpSelectDefault, searchableSelectDefault, multiHttpSelectDefault, multiSelectDefault, phoneDefault, timeDefault, radioBoolDefault, radioDefault, radioEnumDefault, searchableMultiSelectDefault, selectDefault, tagDefault, textAreaDefault, textDefault, urlDefault


# Constructors

@docs age, checkbox, date, httpSelect, text, multiHttpSelect, multiSelect, radio, radioBool, radioEnum, searchableSelect, searchableMultiSelect, select, tag, url, phone, time, textArea, email


# Construction Property Setters

@docs setDateFuture, setDateOfBirth, setDateOffset, setDateBounds, setDatePast, setDefault, setDirection, setDisabled, setEnabledBy, setForbiddenEmailDomains, setHidden, setIsRequired, setLabel, setOptions, setOrder, setPlaceholder, setRegexValidation, setRemoteUrl, setSearchableOptions, setSelectablePlaceholder, setLocale, setTagsInputBar, setUnhiddenBy, setValue, setWidth


# Getters

@docs getBoolProperties, getEnabledBy, getUnhiddenBy, getLabel, getNumericValue, getOrder, getProperties, getStringType, getStringValue, getStringValue_, getLocale_, getCountryCodeValue_, getParsedDateValue_, getMultiStringValue_, getType, getUrl, getCode


# Setters

@docs resetValueToDefault, updateBoolValue, updateCheckboxValue_, updateNumericValue, updateNumericValue_, updateRadioBoolValue, updateRadioBoolValue_, updateRadioEnumValue, updateRadioEnumValue_, updateRemoteOptions, updateStringValue, updateParsedDateValue, updateStringDisabled, updateMultiStringOption, updateStringValue_, updateMultiStringValue_, updatePhoneShowDropdown, updatePhoneDropdown, updateShowDropdown, maybeUpdateStringValue, updateTagsInputBarValue, updateTagsValue, updateTagsValue_, updateSearchableSelectInput, updatePhoneSearchInput


# Predicates

@docs isCheckbox, isRequired


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
import Form.Locale as Locale
import Form.Locale.CountryCode as CountryCode
import Http.Detailed as HttpDetailed
import Json.Encode as Encode
import Json.Encode.Extra as EncodeExtra
import RemoteData
import Set
import Time
import Time.Extra as TimeExtra



-- MAKERS


{-| Makes an input field, defaulting to text input.

In addition to the common builders, the following are available:

  - `setRegexValidation (List RegexValidation.RegexValidation)`

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
text : SimpleFieldProperties -> Field
text =
    StringField_ << SimpleField


{-| Makes an email input field.

In addition to the common builders, the following are available:

  - `setForbiddenEmailDomains (List EmailFormat.ForbiddenDomain)`

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
email : SimpleFieldProperties -> Field
email =
    StringField_ << SimpleField << setTipe FieldType.Email


{-| Makes a time field.

In addition to the common builders, the following are available:

  - `setRegexValidation (List RegexValidation.RegexValidation)`

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
time : SimpleFieldProperties -> Field
time =
    StringField_ << SimpleField << setTipe FieldType.Time


{-| Makes a phone field.

In addition to the common builders, the following are available:

  - `setRegexValidation (List RegexValidation.RegexValidation)`

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
phone : PhoneFieldProperties -> Field
phone =
    StringField_ << PhoneField


{-| Makes a url field.

In addition to the common builders, the following are available:

  - `setLocale (Maybe Locale.Locale)`

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
url : SimpleFieldProperties -> Field
url =
    StringField_ << SimpleField << setTipe FieldType.Url


{-| Makes a multiline text area field.

In addition to the common builders, the following are available:

  - `setRegexValidation (List RegexValidation.RegexValidation)`

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
textArea : SimpleFieldProperties -> Field
textArea =
    StringField_ << SimpleField << setTipe FieldType.TextArea


{-| Makes a date input field. By default, dates 100 years from the start of the Unix epoch (00:00:00 UTC on 1 January 1970) are allowed. Use setters to customise this.

In addition to the common builders, the following are available:

  - `setDateOfBirth`
  - `setDateFuture`
  - `setDatePast`
  - `setDateBounds Time.Posix Time.Posix`
  - `setDateOffset ( TimeExtra.Interval, Int ) ( TimeExtra.Interval, Int )`

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
date : DateFieldProperties -> Field
date =
    StringField_ << DateField


{-| Makes an age input field.

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
age : AgeFieldProperties -> Field
age =
    NumericField_ << AgeField


{-| Makes a tag field.

In addition to the common builders, the following are available:

  - `setTagsInputBar String`
  - `setPlaceholder (Maybe String)`

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
tag : TagFieldProperties -> Field
tag =
    MultiStringField_ << TagField


{-| Makes a checkbox field.

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
checkbox : CheckboxFieldProperties -> Field
checkbox =
    BoolField_ << CheckboxField


{-| Makes a radio field.

In addition to the common builders, the following are available:

  - `setDefault String`
  - `setOptions (List Option.Option)`
  - `setDirection Direction.Direction`

A list of options needs to be passed in, but setters passed in will override these.

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
radio : List Option.Option -> RadioFieldProperties -> Field
radio options =
    StringField_ << RadioField << setOptions options


{-| Makes a boolean radio field.

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
radioBool : RadioBoolFieldProperties -> Field
radioBool =
    BoolField_ << RadioBoolField


{-| Makes a radio field for selection of Yes/No/N/A enums, with all three as an option by default. Override with setOptions.

In addition to the common builders, the following are available:

  - `setDefault RadioEnum.Value`
  - `setOptions (List RadioEnum.Value)`

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
radioEnum : RadioEnumFieldProperties -> Field
radioEnum =
    BoolField_ << RadioEnumField


{-| Makes a drop-down select field from a list of options.

In addition to the common builders, the following are available:

  - `setDefault String`
  - `setOptions (List Option.Option)`
  - `setPlaceholder String`
  - `setSelectablePlaceholder`

A list of options needs to be passed in, but setters passed in will override these.

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
select : List Option.Option -> SelectFieldProperties {} -> Field
select options =
    StringField_ << SelectField << setOptions options


{-| Makes a remotely fetched drop-down select field.

In addition to the common builders, the following are available:

  - `setDefault String`
  - `setOptions (RemoteData.RemoteData (HttpDetailed.Error String) (List Option.Option))`
  - `setPlaceholder String`
  - `setRemoteUrl String`
  - `setSelectablePlaceholder`

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
httpSelect : String -> HttpSelectFieldProperties -> Field
httpSelect url_ =
    StringField_ << HttpSelectField << setRemoteUrl url_


{-| Makes a searchable select field, with options that are searchable.

In addition to the common builders, the following are available:

  - `setDefault String`
  - \`setOptions (List Option.Option)
  - `setPlaceholder String`
  - `setSelectablePlaceholder`

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
searchableSelect : SearchableSelectFieldProperties -> Field
searchableSelect =
    StringField_ << SearchableSelectField


{-| Makes a multi select field from a list of options.

In addition to the common builders, the following are available:

  - `setOptions (List Option.Option)`
  - `setPlaceholder String`

A list of options needs to be passed in, but setters passed in will override these.

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
multiSelect : List Option.Option -> MultiSelectFieldProperties {} -> Field
multiSelect options =
    MultiStringField_ << MultiSelectField << setOptions options


{-| Makes a searchable multi select field, with two categories of options: searchable and non-searchable. Neither category is mandatory, so make sure to set at least one for the field to be useful.

In addition to the common builders, the following are available:

  - `setOptions (List Option.Option)`
  - `setSearchableOptions (List Option.Option)`
  - `setPlaceholder String`

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
searchableMultiSelect : SearchableMultiSelectFieldProperties -> Field
searchableMultiSelect =
    MultiStringField_ << SearchableMultiSelectField


{-| Makes a remotely fetched multi select field.

In addition to the common builders, the following are available:

  - `setOptions (List Option.Option)`
  - `setPlaceholder String`
  - `setRemoteUrl String`

Common builders:

  - `setIsRequired Required.IsRequired`
  - `setLabel String`
  - `setWidth Width.Width`
  - `setEnabledBy String`
  - `setOrder Int`
  - `setDisabled`
  - `setHidden`
  - `setUnhiddenBy String`

-}
multiHttpSelect : String -> MultiHttpSelectFieldProperties -> Field
multiHttpSelect url_ =
    MultiStringField_ << MultiHttpSelectField << setRemoteUrl url_



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
setDisabled : FieldProperties a -> FieldProperties a
setDisabled field =
    { field | disabled = True }


{-| -}
setHidden : FieldProperties a -> FieldProperties a
setHidden field =
    { field | hidden = True }


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
setLocale : Maybe Locale.Locale -> PhoneFieldProperties -> PhoneFieldProperties
setLocale locale field =
    { field | locale = locale }


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


{-| Sets the selectable date range to be the last 120 years.
-}
setDateOfBirth : DateFieldProperties -> DateFieldProperties
setDateOfBirth =
    setTipe FieldType.dateOfBirth


{-| Sets the selectable date range to be the next 10 years.
-}
setDateFuture : DateFieldProperties -> DateFieldProperties
setDateFuture =
    setTipe FieldType.dateFuture


{-| Sets the selectable date range to be the last 120 years.
-}
setDatePast : DateFieldProperties -> DateFieldProperties
setDatePast =
    setTipe FieldType.datePast


{-| Sets the selectable date range to be based on intervals relative to the current date.

For example, to select a date between 2 years ago and 5 years from now, use:

    `setDateOffset ( TimeExtra.Year, -2 ) ( TimeExtra.Year, 5 )`

-}
setDateOffset : ( TimeExtra.Interval, Int ) -> ( TimeExtra.Interval, Int ) -> DateFieldProperties -> DateFieldProperties
setDateOffset minOffset maxOffset =
    setTipe (FieldType.DateOffset minOffset maxOffset)


{-| Sets the selectable date range to absolute dates in POSIX time.
-}
setDateBounds : Time.Posix -> Time.Posix -> DateFieldProperties -> DateFieldProperties
setDateBounds minBound maxBound =
    setTipe (FieldType.DateAbsolute minBound maxBound)


{-| -}
setDirection : Direction.Direction -> RadioFieldProperties -> RadioFieldProperties
setDirection direction field =
    { field | direction = direction }



-- DEFAULT


simpleDefault : SimpleFieldProperties
simpleDefault =
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


{-| `{ required = Required.No
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
}`
-}
textDefault : SimpleFieldProperties
textDefault =
    simpleDefault


{-| `{ required = Required.No
, label = ""
, width = Width.FullSize
, enabledBy = Nothing
, order = 0
, disabled = False
, hidden = False
, unhiddenBy = Nothing
, regexValidation = []
, tipe = FieldType.Email
, value = ""
}`
-}
emailDefault : SimpleFieldProperties
emailDefault =
    setTipe FieldType.Email <| simpleDefault


{-| `{ required = Required.No
, label = ""
, width = Width.FullSize
, enabledBy = Nothing
, order = 0
, disabled = False
, hidden = False
, unhiddenBy = Nothing
, regexValidation = []
, tipe = FieldType.Url
, value = ""
}`
-}
urlDefault : SimpleFieldProperties
urlDefault =
    setTipe FieldType.Url <| simpleDefault


{-| `{ required = Required.No
, label = ""
, width = Width.FullSize
, enabledBy = Nothing
, order = 0
, disabled = False
, hidden = False
, unhiddenBy = Nothing
, regexValidation = []
, tipe = FieldType.Phone
, value = ""
, locale = Nothing
}`
-}
phoneDefault : PhoneFieldProperties
phoneDefault =
    { required = Required.No
    , label = ""
    , width = Width.FullSize
    , enabledBy = Nothing
    , order = 0
    , disabled = False
    , hidden = False
    , unhiddenBy = Nothing
    , value = ""
    , locale = Nothing
    , countryCodeDropdown = { searchInput = "", value = Nothing, showDropdown = False }
    }


{-| `{ required = Required.No
, label = ""
, width = Width.FullSize
, enabledBy = Nothing
, order = 0
, disabled = False
, hidden = False
, unhiddenBy = Nothing
, regexValidation = []
, tipe = FieldType.Time
, value = ""
}`
-}
timeDefault : SimpleFieldProperties
timeDefault =
    setTipe FieldType.Time <| simpleDefault


{-| `{ required = Required.No
, label = ""
, width = Width.FullSize
, enabledBy = Nothing
, order = 0
, disabled = False
, hidden = False
, unhiddenBy = Nothing
, regexValidation = []
, tipe = FieldType.TextArea
, value = ""
}`
-}
textAreaDefault : SimpleFieldProperties
textAreaDefault =
    setTipe FieldType.TextArea <| simpleDefault


{-| `{ required = Required.No
, label = ""
, width = Width.FullSize
, enabledBy = Nothing
, order = 0
, disabled = False
, hidden = False
, unhiddenBy = Nothing
, tipe = FieldType.DateAbsolute (Time.millisToPosix 0) (Time.millisToPosix 3155720400000)
, value = ""
, parsedDate = Nothing
}`
-}
dateDefault : DateFieldProperties
dateDefault =
    { required = Required.No
    , label = ""
    , width = Width.FullSize
    , enabledBy = Nothing
    , order = 0
    , disabled = False
    , hidden = False
    , unhiddenBy = Nothing
    , tipe = FieldType.DateAbsolute (Time.millisToPosix 0) (Time.millisToPosix 3155720400000)
    , value = ""
    , parsedDate = Nothing
    }


{-| `{ required = Required.No
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
}`
-}
tagDefault : TagFieldProperties
tagDefault =
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


{-| `{ required = Required.No
, label = ""
, width = Width.FullSize
, enabledBy = Nothing
, order = 0
, disabled = False
, hidden = False
, unhiddenBy = Nothing
, value = False
, tipe = FieldType.Checkbox
}`
-}
checkboxDefault : CheckboxFieldProperties
checkboxDefault =
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


{-| `{ required = Required.No
, label = ""
, width = Width.FullSize
, enabledBy = Nothing
, order = 0
, disabled = False
, hidden = False
, unhiddenBy = Nothing
, value = Nothing
}`
-}
radioBoolDefault : RadioBoolFieldProperties
radioBoolDefault =
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


{-| `{ required = Required.No
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
}`
-}
radioEnumDefault : RadioEnumFieldProperties
radioEnumDefault =
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


{-| `{ required = Required.No
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
}`
-}
selectDefault : SelectFieldProperties {}
selectDefault =
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


{-| `{ required = Required.No
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
}`
-}
httpSelectDefault : HttpSelectFieldProperties
httpSelectDefault =
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


{-| `{ required = Required.No
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
}`
-}
multiSelectDefault : MultiSelectFieldProperties {}
multiSelectDefault =
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


{-| `{ required = Required.No
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
}`
-}
searchableSelectDefault : SearchableSelectFieldProperties
searchableSelectDefault =
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
    , showDropdown = False
    , searchInput = ""
    }


{-| `{ required = Required.No
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
}`
-}
searchableMultiSelectDefault : SearchableMultiSelectFieldProperties
searchableMultiSelectDefault =
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


{-| `{ required = Required.No
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
}`
-}
multiHttpSelectDefault : MultiHttpSelectFieldProperties
multiHttpSelectDefault =
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


{-| `{ required = Required.No
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
}`
-}
radioDefault : RadioFieldProperties
radioDefault =
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


{-| `{ required = Required.No
, label = ""
, width = Width.FullSize
, enabledBy = Nothing
, order = 0
, disabled = False
, hidden = False
, unhiddenBy = Nothing
, value = Nothing
}`
-}
ageDefault : AgeFieldProperties
ageDefault =
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
    | PhoneField PhoneFieldProperties
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


type alias CountryCodeDropdown =
    { searchInput : String, value : Maybe CountryCode.CountryCode, showDropdown : Bool }


{-| -}
type alias PhoneFieldProperties =
    StringFieldProperties
        { locale : Maybe Locale.Locale
        , countryCodeDropdown : CountryCodeDropdown
        }


{-| -}
type alias DateFieldProperties =
    StringFieldProperties
        { tipe : FieldType.DateFieldType
        , parsedDate : Maybe Time.Posix
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

        PhoneField { required, label, width, enabledBy, order, value, disabled, hidden, unhiddenBy } ->
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
updateStringValue =
    genericUpdateStringField updateStringValue_


{-| -}
updateStringDisabled : Bool -> Field -> Field
updateStringDisabled =
    let
        updateStringDisabled_ : Bool -> StringField -> StringField
        updateStringDisabled_ value field =
            case field of
                SimpleField properties ->
                    SimpleField { properties | disabled = value }

                PhoneField properties ->
                    PhoneField { properties | disabled = value }

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
    in
    genericUpdateStringField updateStringDisabled_


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
        MultiStringField_ (MultiSelectField properties) ->
            MultiStringField_ <| MultiSelectField (update properties)

        MultiStringField_ (SearchableMultiSelectField properties) ->
            MultiStringField_ <| SearchableMultiSelectField (update properties)

        MultiStringField_ (MultiHttpSelectField properties) ->
            MultiStringField_ <| MultiHttpSelectField (update properties)

        MultiStringField_ (TagField properties) ->
            MultiStringField_ <| TagField (update properties)

        StringField_ stringfield ->
            StringField_ (updateStringValue_ option.value stringfield)
                |> updateShowDropdown False

        _ ->
            field


{-| -}
updateSearchableSelectInput : String -> Field -> Field
updateSearchableSelectInput input_ field =
    case field of
        StringField_ (SearchableSelectField properties) ->
            StringField_ (SearchableSelectField { properties | searchInput = input_ })

        MultiStringField_ (SearchableMultiSelectField properties) ->
            MultiStringField_ (SearchableMultiSelectField { properties | searchInput = input_ })

        _ ->
            field


{-| -}
updatePhoneSearchInput : String -> Field -> Field
updatePhoneSearchInput input_ field =
    case field of
        StringField_ (PhoneField properties) ->
            let
                dropdown =
                    properties.countryCodeDropdown
            in
            StringField_ (PhoneField { properties | countryCodeDropdown = { dropdown | searchInput = input_ } })

        _ ->
            field


{-| -}
getBoolProperties : Field -> Maybe Bool
getBoolProperties field =
    case field of
        BoolField_ (CheckboxField { value }) ->
            Just value

        BoolField_ (RadioBoolField { value }) ->
            value

        _ ->
            Nothing


{-| -}
resetValueToDefault : Field -> Field
resetValueToDefault field =
    case field of
        StringField_ (HttpSelectField properties) ->
            StringField_ <| HttpSelectField { properties | value = properties.default |> Maybe.withDefault httpSelectDefault.value }

        StringField_ (SimpleField properties) ->
            StringField_ <| SimpleField { properties | value = simpleDefault.value }

        StringField_ (PhoneField properties) ->
            StringField_ <| PhoneField { properties | value = dateDefault.value }

        StringField_ (DateField properties) ->
            StringField_ <| DateField { properties | value = dateDefault.value, parsedDate = dateDefault.parsedDate }

        StringField_ (SelectField properties) ->
            StringField_ <| SelectField { properties | value = properties.default |> Maybe.withDefault selectDefault.value }

        StringField_ (SearchableSelectField properties) ->
            StringField_ <| SearchableSelectField { properties | value = properties.default |> Maybe.withDefault selectDefault.value }

        StringField_ (RadioField properties) ->
            StringField_ <| RadioField { properties | value = properties.default |> Maybe.withDefault radioDefault.value }

        MultiStringField_ (MultiHttpSelectField properties) ->
            MultiStringField_ <| MultiHttpSelectField { properties | value = multiHttpSelectDefault.value }

        MultiStringField_ (MultiSelectField properties) ->
            MultiStringField_ <| MultiSelectField { properties | value = multiSelectDefault.value }

        MultiStringField_ (SearchableMultiSelectField properties) ->
            MultiStringField_ <| SearchableMultiSelectField { properties | value = searchableMultiSelectDefault.value, searchInput = searchableMultiSelectDefault.searchInput }

        MultiStringField_ (TagField properties) ->
            MultiStringField_ <| TagField { properties | value = tagDefault.value, inputBar = tagDefault.inputBar }

        BoolField_ (CheckboxField properties) ->
            BoolField_ (CheckboxField { properties | value = checkboxDefault.value })

        BoolField_ (RadioBoolField properties) ->
            BoolField_ (RadioBoolField { properties | value = radioBoolDefault.value })

        BoolField_ (RadioEnumField properties) ->
            BoolField_ (RadioEnumField { properties | value = radioEnumDefault.value })

        NumericField_ (AgeField properties) ->
            NumericField_ (AgeField { properties | value = ageDefault.value })


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
updateTagsInputBarValue input_ field =
    case field of
        MultiStringField_ (TagField properties) ->
            MultiStringField_ (TagField { properties | inputBar = input_ })

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
updatePhoneShowDropdown : Bool -> Field -> Field
updatePhoneShowDropdown showDropdown field =
    case field of
        StringField_ (PhoneField properties) ->
            let
                dropdown =
                    properties.countryCodeDropdown
            in
            StringField_ (PhoneField { properties | countryCodeDropdown = { dropdown | showDropdown = showDropdown } })

        _ ->
            field


{-| -}
updatePhoneDropdown : String -> Field -> Field
updatePhoneDropdown value field =
    case field of
        StringField_ (PhoneField properties) ->
            let
                dropdown =
                    properties.countryCodeDropdown
            in
            StringField_ (PhoneField { properties | countryCodeDropdown = { dropdown | value = CountryCode.fromString value, showDropdown = False } })

        _ ->
            field


{-| -}
updateStringValue_ : String -> StringField -> StringField
updateStringValue_ value field =
    case field of
        SimpleField properties ->
            SimpleField { properties | value = value }

        PhoneField properties ->
            PhoneField { properties | value = value }

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
getLocale_ : StringField -> Maybe Locale.Locale
getLocale_ field =
    case field of
        PhoneField props ->
            props.locale

        _ ->
            Nothing


{-| -}
getCountryCodeValue_ : StringField -> Maybe CountryCode.CountryCode
getCountryCodeValue_ field =
    case field of
        PhoneField props ->
            props.countryCodeDropdown.value

        _ ->
            Nothing


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
getStringType : StringField -> FieldType.StringFieldType
getStringType field =
    case field of
        SimpleField properties ->
            FieldType.SimpleType properties.tipe

        PhoneField _ ->
            FieldType.Phone

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
getUrl : Field -> Maybe String
getUrl field =
    case field of
        StringField_ (HttpSelectField properties) ->
            Just properties.url

        _ ->
            Nothing


{-| -}
getCode : Field -> Maybe CountryCode.CountryCode
getCode field =
    case field of
        StringField_ (PhoneField properties) ->
            case properties.locale of
                Just (Locale.Locale _ code) ->
                    Just code

                Nothing ->
                    properties.countryCodeDropdown.value

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
