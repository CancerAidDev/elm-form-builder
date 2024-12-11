module Fields exposing (..)

import Dict
import Form.Field as FormField
import Form.Field.Direction as Direction
import Form.Field.Required as IsRequired
import Form.Field.Width as Width
import Form.Fields as FormFields
import Regex
import Set


fields : FormFields.Fields
fields =
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
        , case Regex.fromString "\\b[A-Z][a-z]* [A-Z][a-z]*( [A-Z])?\\b" of
            Nothing ->
                FormField.textDefault
                    |> FormField.setIsRequired IsRequired.Yes
                    |> FormField.setLabel "Full Name"
                    |> FormField.setOrder order
                    |> FormField.setValue "Regex does not compile"
                    |> FormField.setDisabled
                    |> FormField.text

            Just regex ->
                FormField.textDefault
                    |> FormField.setIsRequired IsRequired.Yes
                    |> FormField.setLabel "Full Name"
                    |> FormField.setOrder order
                    |> FormField.setRegexValidation
                        [ { pattern = regex
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
        ( "secondaryEmail"
        , FormField.emailDefault
            |> FormField.setIsRequired IsRequired.Nullable
            |> FormField.setLabel "Secondary Email Address"
            |> FormField.setOrder order
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
             |> FormField.setUnhiddenBy "hidesField"
            |> FormField.searchableSelect
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
        ( "newsletterFreq"
        , FormField.radioBoolDefault
            |> FormField.setIsRequired IsRequired.Nullable
            |> FormField.setLabel "How often would you like to receive our newsletter?"
            |> FormField.setOrder order
            |> FormField.setUnhiddenBy "newsletter"
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
    ]
        |> List.indexedMap (\index field -> field index)
        |> Dict.fromList
