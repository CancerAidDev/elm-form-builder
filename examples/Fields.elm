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
        ( "Uneditable field"
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
            , regexValidation = Nothing
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
            , regexValidation = Nothing
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
                        Nothing
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
                        Just
                            { pattern = regex
                            , message = "Please enter your full name"
                            }
                    }
        )
    , \order ->
        ( "email"
          -- regex that forbids strings that end with @bigcompany.com
        , case Regex.fromString "([^@].{14}|.{1}[^b].{13}|.{2}[^i].{12}|.{3}[^g].{11}|.{4}[^c].{10}|.{5}[^o].{9}|.{6}[^m].{8}|.{7}[^p].{7}|.{8}[^a].{6}|.{9}[^n].{5}|.{10}[^y].{4}|.{11}[^.].{3}|.{12}[^c].{2}|.{13}[^o].{1}|.{14}[^m]$|^.{0,14})$" of
            Nothing ->
                FormField.text
                    { required = IsRequired.Yes
                    , label = "Email Address"
                    , width = Width.FullSize
                    , enabledBy = Nothing
                    , order = order
                    , value = "Regex does not compile"
                    , disabled = True
                    , hidden = False
                    , unhiddenBy = Nothing
                    , regexValidation =
                        Nothing
                    }

            Just regex ->
                FormField.email
                    { required = IsRequired.Yes
                    , label = "Email Address"
                    , width = Width.FullSize
                    , enabledBy = Nothing
                    , order = order
                    , value = ""
                    , disabled = False
                    , hidden = False
                    , unhiddenBy = Nothing
                    , regexValidation =
                        Just
                            { pattern = regex
                            , message = "Please use the employee's personal email address"
                            }
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
            , regexValidation = Nothing
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
            , regexValidation = Nothing
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
    ]
        |> List.indexedMap (\index field -> field index)
        |> Dict.fromList
