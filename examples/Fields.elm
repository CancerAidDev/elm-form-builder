module Fields exposing (..)

import Dict
import Form.Field as FormField
import Form.Field.Direction as Direction
import Form.Field.Required as IsRequired
import Form.Field.Width as Width
import Form.Fields as FormFields
import Regex
import RemoteData
import Set


fields : FormFields.Fields
fields =
    let
        markdownLabelExtraContent : String
        markdownLabelExtraContent =
            """
- Car
- Bike
- Bus
- Train
            """
    in
    [ \order ->
        ( "Uneditable"
        , FormField.textDefault
            |> FormField.setLabel "Uneditable Field"
            |> FormField.setOrder order
            |> FormField.setDisabled
            |> FormField.text
        )
    , \order ->
        ( "not a valid email field"
        , FormField.emailDefault
            |> FormField.setLabel "Not relevant Email Address"
            |> FormField.setOrder order
            |> FormField.setDisabled
            |> FormField.email
        )
    , \order ->
        ( "name"
        , FormField.textDefault
            |> FormField.setIsRequired IsRequired.Yes
            |> FormField.setLabel "Full Name"
            |> FormField.setOrder order
            |> FormField.setRegexValidation
                [ { pattern = Regex.fromString "\\b[A-Z][a-z]* [A-Z][a-z]*( [A-Z])?\\b" |> Maybe.withDefault Regex.never
                  , message = "Please enter your full name"
                  }
                ]
            |> FormField.text
        )
    , \order ->
        ( "email"
          -- forbid emails from bigcompany.com or bigorganisation.org
        , FormField.emailDefault
            |> FormField.setIsRequired IsRequired.Yes
            |> FormField.setLabel "Email Address"
            |> FormField.setOrder order
            |> FormField.setForbiddenEmailDomains
                [ { domain = "bigcompany.com"
                  , message = "Please don't use the company email address"
                  }
                , { domain = "bigorganisation.org"
                  , message = "Please don't use the organisation email address"
                  }
                ]
            |> FormField.email
        )
    , \order ->
        ( "phone"
        , FormField.phoneDefault
            |> FormField.setIsRequired IsRequired.Yes
            |> FormField.setLabel "Phone"
            |> FormField.setOrder order
            |> FormField.phone
        )
    , \order ->
        ( "time"
        , FormField.timeDefault
            |> FormField.setIsRequired IsRequired.Yes
            |> FormField.setLabel "Time"
            |> FormField.setOrder order
            |> FormField.time
        )
    , \order ->
        ( "age"
        , FormField.integerDefault
            |> FormField.setIsRequired IsRequired.Nullable
            |> FormField.setLabel "Age"
            |> FormField.setMin 0
            |> FormField.setMax 100
            |> FormField.setOrder order
            |> FormField.integer
        )
    , \order ->
        ( "dateOfBirth"
        , FormField.dateDefault
            |> FormField.setDateOfBirth
            |> FormField.setIsRequired IsRequired.Nullable
            |> FormField.setLabel "Date of Birth"
            |> FormField.setOrder order
            |> FormField.date
        )
    , \order ->
        ( "datePast"
        , FormField.dateDefault
            |> FormField.setDatePast
            |> FormField.setIsRequired IsRequired.Nullable
            |> FormField.setLabel "Claim Started"
            |> FormField.setOrder order
            |> FormField.date
        )
    , \order ->
        ( "dateFuture"
        , FormField.dateDefault
            |> FormField.setDateFuture
            |> FormField.setIsRequired IsRequired.Nullable
            |> FormField.setLabel "Start Date"
            |> FormField.setOrder order
            |> FormField.date
        )
    , \order ->
        ( "date"
        , FormField.dateDefault
            |> FormField.setDateDefault
            |> FormField.setIsRequired IsRequired.Nullable
            |> FormField.setLabel "Event Date"
            |> FormField.setOrder order
            |> FormField.date
        )
    , \order ->
        ( "shortField"
        , FormField.textDefault
            |> FormField.setIsRequired IsRequired.Yes
            |> FormField.setWidth Width.HalfSize
            |> FormField.setLabel "Short Label"
            |> FormField.setOrder order
            |> FormField.setRegexValidation
                [ { pattern = Regex.fromString "\\b[A-Z][a-z]* [A-Z][a-z]*( [A-Z])?\\b" |> Maybe.withDefault Regex.never
                  , message = "Please enter your full name"
                  }
                ]
            |> FormField.text
        )
    , \order ->
        ( "longField"
        , FormField.textDefault
            |> FormField.setIsRequired IsRequired.Yes
            |> FormField.setWidth Width.HalfSize
            |> FormField.setLabel "This is a very long field label that will wrap over two lines"
            |> FormField.setOrder order
            |> FormField.setRegexValidation
                [ { pattern = Regex.fromString "[A-Za-z\\s]+" |> Maybe.withDefault Regex.never
                  , message = "This is a very long multiline error message that says that only letters and spaces are allowed in this field"
                  }
                ]
            |> FormField.text
        )
    , \order ->
        ( "something"
        , FormField.selectDefault
            |> FormField.setLabel "Something"
            |> FormField.setOrder order
            |> FormField.setDisabled
            |> FormField.setSelectablePlaceholder
            |> FormField.select
                [ { label = Nothing, value = "One" }
                , { label = Nothing, value = "Two" }
                ]
        )
    , \order ->
        ( "hidesField"
        , FormField.selectDefault
            |> FormField.setIsRequired IsRequired.No
            |> FormField.setLabel "Hides a field"
            |> FormField.setOrder order
            |> FormField.setSelectablePlaceholder
            |> FormField.select
                [ { label = Nothing, value = "One" }
                , { label = Nothing, value = "Two" }
                ]
        )
    , \order ->
        ( "httpSearchableSelectField"
        , FormField.httpSearchableSelectDefault
            |> FormField.setIsRequired IsRequired.No
            |> FormField.setLabel "HTTP Searchable State"
            |> FormField.setWidth Width.HalfSize
            |> FormField.setOrder order
            |> FormField.setOptions
                (RemoteData.Success
                    [ { label = Just "Australian Capital Territory", value = "1" }
                    , { label = Just "New South Wales", value = "2" }
                    , { label = Just "Northern Territory", value = "3" }
                    , { label = Just "Queensland", value = "4" }
                    , { label = Just "South Australian", value = "5" }
                    , { label = Just "Tasmania", value = "6" }
                    , { label = Just "Victorian", value = "7" }
                    , { label = Just "Western Australia", value = "8" }
                    ]
                )
            |> FormField.setUnhiddenBy "hidesField"
            |> FormField.httpSearchableSelect "url"
        )
    , \order ->
        ( "state"
        , let
            options =
                [ { label = Nothing, value = "Australian Capital Territory" }
                , { label = Nothing, value = "New South Wales" }
                , { label = Nothing, value = "Northern Territory" }
                , { label = Nothing, value = "Queensland" }
                , { label = Nothing, value = "South Australian" }
                , { label = Nothing, value = "Tasmania" }
                , { label = Nothing, value = "Victorian" }
                , { label = Nothing, value = "Western Australia" }
                ]
          in
          FormField.selectDefault
            |> FormField.setIsRequired IsRequired.Nullable
            |> FormField.setLabel "State"
            |> FormField.setOrder order
            |> FormField.setPlaceholder "State"
            |> FormField.select options
        )
    , \order ->
        ( "modes"
        , let
            options =
                [ { label = Nothing, value = "Car" }
                , { label = Nothing, value = "Tram" }
                , { label = Nothing, value = "Bus" }
                , { label = Nothing, value = "Train" }
                , { label = Nothing, value = "Cycle" }
                ]
          in
          FormField.multiSelectDefault
            |> FormField.setIsRequired IsRequired.Yes
            |> FormField.setLabel "What modes of transport do you use?"
            |> FormField.setOrder order
            |> FormField.setPlaceholder "Mode"
            |> FormField.multiSelect options
        )
    , \order ->
        ( "searchableState"
        , FormField.searchableSelectDefault
            |> FormField.setIsRequired IsRequired.Nullable
            |> FormField.setLabel "Searchable State"
            |> FormField.setOrder order
            |> FormField.setOptions
                [ { label = Nothing, value = "Australian Capital Territory" }
                , { label = Nothing, value = "New South Wales" }
                , { label = Nothing, value = "Northern Territory" }
                , { label = Nothing, value = "Queensland" }
                , { label = Nothing, value = "South Australian" }
                , { label = Nothing, value = "Tasmania" }
                , { label = Nothing, value = "Victorian" }
                , { label = Nothing, value = "Western Australia" }
                ]
            |> FormField.setPlaceholder "Searchable State"
            |> FormField.searchableSelect
        )
    , \order ->
        ( "searchableStateWithLabels"
        , FormField.searchableSelectDefault
            |> FormField.setIsRequired IsRequired.Nullable
            |> FormField.setLabel "Searchable State"
            |> FormField.setOrder order
            |> FormField.setOptions
                [ { label = Just "Australian Capital Territory", value = "1" }
                , { label = Just "New South Wales", value = "2" }
                , { label = Just "Northern Territory", value = "3" }
                , { label = Just "Queensland", value = "4" }
                , { label = Just "South Australian", value = "5" }
                , { label = Just "Tasmania", value = "6" }
                , { label = Just "Victorian", value = "7" }
                , { label = Just "Western Australia", value = "8" }
                ]
            |> FormField.setPlaceholder "Searchable State With Labels"
            |> FormField.searchableSelect
        )
    , \order ->
        ( "workdays"
        , FormField.searchableMultiSelectDefault
            |> FormField.setIsRequired IsRequired.Yes
            |> FormField.setLabel "What days of the week do you work?"
            |> FormField.setOrder order
            |> FormField.setOptions
                [ { label = Just "Saturday", value = "Sat" }
                , { label = Just "Sunday", value = "Sun" }
                ]
            |> FormField.setSearchableOptions
                [ { label = Just "Monday", value = "Mon" }
                , { label = Just "Tuesday", value = "Tue" }
                , { label = Just "Wednesday", value = "Wed" }
                , { label = Just "Thursday", value = "Thu" }
                , { label = Just "Friday", value = "Fri" }
                ]
            |> FormField.setPlaceholder "Workdays"
            |> FormField.searchableMultiSelect
        )
    , \order ->
        ( "updates"
        , let
            options =
                [ { label = Nothing, value = "Yes" }
                , { label = Nothing, value = "No" }
                , { label = Nothing, value = "Unsure" }
                ]
          in
          FormField.radioDefault
            |> FormField.setIsRequired IsRequired.Yes
            |> FormField.setLabel "Are you up to date with your updates?"
            |> FormField.setOrder order
            |> FormField.setDirection Direction.Row
            |> FormField.radio options
        )
    , \order ->
        ( "newsletter"
        , FormField.radioBoolDefault
            |> FormField.setIsRequired IsRequired.Yes
            |> FormField.setLabel "Would you like to sign up to our newsletter?"
            |> FormField.setOrder order
            |> FormField.radioBool
        )
    , \order ->
        ( "travel"
        , FormField.radioBoolDefault
            |> FormField.setIsRequired IsRequired.Yes
            |> FormField.setLabel "Do you use any of the following modes of transport: "
            |> FormField.setLabelExtraContent markdownLabelExtraContent
            |> FormField.setOrder order
            |> FormField.radioBool
        )
    , \order ->
        ( "newsletterPromotions"
        , FormField.radioBoolDefault
            |> FormField.setIsRequired IsRequired.Yes
            |> FormField.setLabel "Would you like to receive promotional offers?"
            |> FormField.setOrder order
            |> FormField.setEnabledBy "newsletter"
            |> FormField.radioBool
        )
    , \order ->
        ( "newsletterFreq"
        , FormField.radioBoolDefault
            |> FormField.setIsRequired IsRequired.Nullable
            |> FormField.setLabel "How often would you like to receive promotional offers?"
            |> FormField.setOrder order
            |> FormField.setUnhiddenBy "newsletterPromotions"
            |> FormField.radioBool
        )
    , \order ->
        ( "NewsletterTags"
        , FormField.tagDefault
            |> FormField.setIsRequired IsRequired.Yes
            |> FormField.setLabel "Newsletter Tags"
            |> FormField.setOrder order
            |> FormField.setPlaceholder (Just "Add new tag...")
            |> FormField.setValue (Set.fromList [ "Hello", "Goodbye", "Beta" ])
            |> FormField.tag
        )
    , \order ->
        ( "Checkbox"
        , FormField.checkboxDefault
            |> FormField.setIsRequired IsRequired.Yes
            |> FormField.setLabel "By checking this box, I confirm that we have the above person's consent for the above personal information to be shared and to be contacted for the purposes of a Program, and to be processed."
            |> FormField.setOrder order
            |> FormField.checkbox
        )
    , \order ->
        ( "Checkbox with link"
        , FormField.checkboxDefault
            |> FormField.setIsRequired IsRequired.Yes
            |> FormField.setLabel "By checking this box, I confirm that we have the above person's consent for the above personal information to be shared and to be contacted for the purposes of a Program, and to be processed in accordance with [Link](google.com)."
            |> FormField.setOrder order
            |> FormField.checkbox
        )
    ]
        |> List.indexedMap (\index field -> field index)
        |> Dict.fromList
