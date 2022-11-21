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
        , FormField.text
            { required = IsRequired.No
            , label = "Uneditable Field"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , disabled = True
            , hidden = False
            , unhiddenBy = Nothing
            , regexValidation = []
            }
        )
    , \order ->
        ( "not a valid email field"
        , FormField.email
            { required = IsRequired.No
            , label = "Not relevant Email Address"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , disabled = True
            , hidden = False
            , unhiddenBy = Nothing
            , forbiddenDomains = []
            }
        )
    , \order ->
        ( "name"
        , case Regex.fromString "\\b[A-Z][a-z]* [A-Z][a-z]*( [A-Z])?\\b" of
            Nothing ->
                FormField.text
                    { required = IsRequired.Yes
                    , label = "Full Name"
                    , width = Width.FullSize
                    , enabledBy = Nothing
                    , order = order
                    , value = "Regex does not compile"
                    , disabled = True
                    , hidden = False
                    , unhiddenBy = Nothing
                    , regexValidation =
                        []
                    }

            Just regex ->
                FormField.text
                    { required = IsRequired.Yes
                    , label = "Full Name"
                    , width = Width.FullSize
                    , enabledBy = Nothing
                    , order = order
                    , value = ""
                    , disabled = False
                    , hidden = False
                    , unhiddenBy = Nothing
                    , regexValidation =
                        [ { pattern = regex
                          , message = "Please enter your full name"
                          }
                        ]
                    }
        )
    , \order ->
        ( "email"
          -- forbid emails from bigcompany.com or bigorganisation.org
        , FormField.email
            { required = IsRequired.Yes
            , label = "Email Address"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , disabled = False
            , hidden = False
            , unhiddenBy = Nothing
            , forbiddenDomains =
                [ { domain = "bigcompany.com"
                  , message = "Please don't use the company email address"
                  }
                , { domain = "bigorganisation.org"
                  , message = "Please don't use the organisation email address"
                  }
                ]
            }
        )
    , \order ->
        ( "secondaryEmail"
        , FormField.email
            { required = IsRequired.Nullable
            , label = "Secondary Email Address"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , disabled = False
            , hidden = False
            , unhiddenBy = Nothing
            , forbiddenDomains = []
            }
        )
    , \order ->
        ( "phone"
        , FormField.phone
            { required = IsRequired.Yes
            , label = "Phone"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , disabled = False
            , hidden = False
            , unhiddenBy = Nothing
            , regexValidation = []
            }
        )
    , \order ->
        ( "age"
        , FormField.age
            { required = IsRequired.Nullable
            , label = "Age"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = Nothing
            , disabled = False
            , hidden = False
            , unhiddenBy = Nothing
            }
        )
    , \order ->
        ( "dateOfBirth"
        , FormField.dateOfBirth
            { required = IsRequired.Nullable
            , label = "Date of Birth"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , disabled = False
            , hidden = False
            , unhiddenBy = Nothing
            }
        )
    , \order ->
        ( "datePast"
        , FormField.datePast
            { required = IsRequired.Nullable
            , label = "Claim Started"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , disabled = False
            , hidden = False
            , unhiddenBy = Nothing
            }
        )
    , \order ->
        ( "dateFuture"
        , FormField.dateFuture
            { required = IsRequired.Nullable
            , label = "Start Date"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , disabled = False
            , hidden = False
            , unhiddenBy = Nothing
            }
        )
    , \order ->
        ( "something"
        , FormField.select
            { required = IsRequired.No
            , label = "Something"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , default = Nothing
            , options =
                [ { label = Nothing, value = "One" }
                , { label = Nothing, value = "Two" }
                ]
            , disabled = True
            , hidden = False
            , unhiddenBy = Nothing
            , placeholder = ""
            , hasSelectablePlaceholder = True
            }
        )
    , \order ->
        ( "state"
        , FormField.select
            { required = IsRequired.Nullable
            , label = "State"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , default = Nothing
            , options =
                [ { label = Nothing, value = "Australian Capital Territory" }
                , { label = Nothing, value = "New South Wales" }
                , { label = Nothing, value = "Northern Territory" }
                , { label = Nothing, value = "Queensland" }
                , { label = Nothing, value = "South Australian" }
                , { label = Nothing, value = "Tasmania" }
                , { label = Nothing, value = "Victorian" }
                , { label = Nothing, value = "Western Australia" }
                ]
            , disabled = False
            , hidden = False
            , unhiddenBy = Nothing
            , placeholder = "State"
            , hasSelectablePlaceholder = False
            }
        )
    , \order ->
        ( "modes"
        , FormField.multiSelect
            { required = IsRequired.Yes
            , label = "What modes of transport do you use?"
            , placeholder = "Mode"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = Set.empty
            , showDropdown = False
            , options =
                [ { label = Nothing, value = "Car" }
                , { label = Nothing, value = "Tram" }
                , { label = Nothing, value = "Bus" }
                , { label = Nothing, value = "Train" }
                , { label = Nothing, value = "Cycle" }
                ]
            , disabled = False
            , hidden = False
            , unhiddenBy = Nothing
            }
        )
    , \order ->
        ( "workdays"
        , FormField.searchableMultiSelect
            { required = IsRequired.Yes
            , label = "What days of the week do you work?"
            , placeholder = "Workdays"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = Set.empty
            , showDropdown = False
            , options =
                [ { label = Just "Saturday", value = "Sat" }
                , { label = Just "Sunday", value = "Sun" }
                ]
            , searchableOptions =
                [ { label = Just "Monday", value = "Mon" }
                , { label = Just "Tuesday", value = "Tue" }
                , { label = Just "Wednesday", value = "Wed" }
                , { label = Just "Thursday", value = "Thu" }
                , { label = Just "Friday", value = "Fri" }
                ]
            , searchInput = ""
            , disabled = False
            , hidden = False
            , unhiddenBy = Nothing
            }
        )
    , \order ->
        ( "updates"
        , FormField.radio
            { required = IsRequired.Yes
            , label = "Are you up to date with your updates?"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , default = Nothing
            , options =
                [ { label = Nothing, value = "Yes" }
                , { label = Nothing, value = "No" }
                , { label = Nothing, value = "Unsure" }
                ]
            , direction = Direction.Row
            , disabled = False
            , hidden = False
            , unhiddenBy = Nothing
            }
        )
    , \order ->
        ( "newsletter"
        , FormField.radioBool
            { required = IsRequired.Yes
            , label = "Would you like to sign up to our newsletter?"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = Nothing
            , disabled = False
            , hidden = False
            , unhiddenBy = Nothing
            }
        )
    , \order ->
        ( "newsletterFreq"
        , FormField.radioBool
            { required = IsRequired.Nullable
            , label = "How often would you like to receive our newsletter?"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = Nothing
            , disabled = False
            , hidden = False
            , unhiddenBy = Just "newsletter"
            }
        )
    , \order ->
        ( "NewsletterTags"
        , FormField.tag
            { required = IsRequired.Yes
            , label = "Newsletter Tags"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , inputBar = ""
            , value = Set.fromList [ "Hello", "Goodbye", "Beta" ]
            , disabled = False
            , hidden = False
            , unhiddenBy = Nothing
            , placeholder = Just "Add new tag..."
            }
        )
    ]
        |> List.indexedMap (\index field -> field index)
        |> Dict.fromList
