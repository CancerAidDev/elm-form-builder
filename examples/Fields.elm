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
        , FormField.mkInput <|
            FormField.setLabel "Uneditable Field"
                >> FormField.setOrder order
                >> FormField.setDisabled True
        )
    , \order ->
        ( "not a valid email field"
        , FormField.mkInput <|
            FormField.setEmail
                >> FormField.setLabel "Not relevant Email Address"
                >> FormField.setOrder order
                >> FormField.setDisabled True
        )
    , \order ->
        ( "name"
        , case Regex.fromString "\\b[A-Z][a-z]* [A-Z][a-z]*( [A-Z])?\\b" of
            Nothing ->
                FormField.mkInput <|
                    FormField.setIsRequired IsRequired.Yes
                        >> FormField.setLabel "Full Name"
                        >> FormField.setOrder order
                        >> FormField.setValue "Regex does not compile"
                        >> FormField.setDisabled True

            Just regex ->
                FormField.mkInput <|
                    FormField.setIsRequired IsRequired.Yes
                        >> FormField.setLabel "Full Name"
                        >> FormField.setOrder order
                        >> FormField.setRegexValidation
                            [ { pattern = regex
                              , message = "Please enter your full name"
                              }
                            ]
        )
    , \order ->
        ( "email"
          -- forbid emails from bigcompany.com or bigorganisation.org
        , FormField.mkInput <|
            FormField.setEmail
                >> FormField.setIsRequired IsRequired.Yes
                >> FormField.setLabel "Email Address"
                >> FormField.setOrder order
                >> FormField.setForbiddenEmailDomains
                    [ { domain = "bigcompany.com"
                      , message = "Please don't use the company email address"
                      }
                    , { domain = "bigorganisation.org"
                      , message = "Please don't use the organisation email address"
                      }
                    ]
        )
    , \order ->
        ( "secondaryEmail"
        , FormField.mkInput <|
            FormField.setEmail
                >> FormField.setIsRequired IsRequired.Nullable
                >> FormField.setLabel "Secondary Email Address"
                >> FormField.setOrder order
        )
    , \order ->
        ( "phone"
        , FormField.mkInput <|
            FormField.setPhone
                >> FormField.setIsRequired IsRequired.Yes
                >> FormField.setLabel "Phone"
                >> FormField.setOrder order
        )
    , \order ->
        ( "age"
        , FormField.mkAgeField <|
            FormField.setIsRequired IsRequired.Nullable
                >> FormField.setLabel "Age"
                >> FormField.setOrder order
        )
    , \order ->
        ( "dateOfBirth"
        , FormField.mkDate <|
            FormField.setDateOfBirth
                >> FormField.setIsRequired IsRequired.Nullable
                >> FormField.setLabel "Date of Birth"
                >> FormField.setOrder order
        )
    , \order ->
        ( "datePast"
        , FormField.mkDate <|
            FormField.setIsRequired IsRequired.Nullable
                >> FormField.setLabel "Claim Started"
                >> FormField.setOrder order
        )
    , \order ->
        ( "dateFuture"
        , FormField.mkDate <|
            FormField.setDateFuture
                >> FormField.setIsRequired IsRequired.Nullable
                >> FormField.setLabel "Start Date"
                >> FormField.setOrder order
        )
    , \order ->
        ( "something"
        , FormField.mkSelect <|
            FormField.setLabel "Something"
                >> FormField.setOrder order
                >> FormField.setOptions
                    [ { label = Nothing, value = "One" }
                    , { label = Nothing, value = "Two" }
                    ]
                >> FormField.setDisabled True
                >> FormField.setSelectablePlaceholder
        )
    , \order ->
        ( "state"
        , FormField.mkSelect <|
            FormField.setIsRequired IsRequired.Nullable
                >> FormField.setLabel "State"
                >> FormField.setOrder order
                >> FormField.setOptions
                    [ { label = Nothing, value = "Australian Capital Territory" }
                    , { label = Nothing, value = "New South Wales" }
                    , { label = Nothing, value = "Northern Territory" }
                    , { label = Nothing, value = "Queensland" }
                    , { label = Nothing, value = "South Australian" }
                    , { label = Nothing, value = "Tasmania" }
                    , { label = Nothing, value = "Victorian" }
                    , { label = Nothing, value = "Western Australia" }
                    ]
                >> FormField.setPlaceholder "State"
        )
    , \order ->
        ( "modes"
        , FormField.mkMultiSelect <|
            FormField.setIsRequired IsRequired.Yes
                >> FormField.setLabel "What modes of transport do you use?"
                >> FormField.setOrder order
                >> FormField.setOptions
                    [ { label = Nothing, value = "Car" }
                    , { label = Nothing, value = "Tram" }
                    , { label = Nothing, value = "Bus" }
                    , { label = Nothing, value = "Train" }
                    , { label = Nothing, value = "Cycle" }
                    ]
                >> FormField.setPlaceholder "Mode"
        )
    , \order ->
        ( "workdays"
        , FormField.mkSearchableMultiSelect <|
            FormField.setIsRequired IsRequired.Yes
                >> FormField.setLabel "What days of the week do you work?"
                >> FormField.setOrder order
                >> FormField.setOptions
                    [ { label = Just "Saturday", value = "Sat" }
                    , { label = Just "Sunday", value = "Sun" }
                    ]
                >> FormField.setSearchableOptions
                    [ { label = Just "Monday", value = "Mon" }
                    , { label = Just "Tuesday", value = "Tue" }
                    , { label = Just "Wednesday", value = "Wed" }
                    , { label = Just "Thursday", value = "Thu" }
                    , { label = Just "Friday", value = "Fri" }
                    ]
                >> FormField.setPlaceholder "Workdays"
        )
    , \order ->
        ( "updates"
        , FormField.mkRadio <|
            FormField.setIsRequired IsRequired.Yes
                >> FormField.setLabel "Are you up to date with your updates?"
                >> FormField.setOrder order
                >> FormField.setOptions
                    [ { label = Nothing, value = "Yes" }
                    , { label = Nothing, value = "No" }
                    , { label = Nothing, value = "Unsure" }
                    ]
                >> FormField.setDirection Direction.Row
        )
    , \order ->
        ( "newsletter"
        , FormField.mkRadio <|
            FormField.setIsRequired IsRequired.Yes
                >> FormField.setLabel "Would you like to sign up to our newsletter?"
                >> FormField.setOrder order
        )
    , \order ->
        ( "newsletterFreq"
        , FormField.mkRadioBool <|
            FormField.setIsRequired IsRequired.Nullable
                >> FormField.setLabel "How often would you like to receive our newsletter?"
                >> FormField.setOrder order
                >> FormField.setUnhiddenBy "newsletter"
        )
    , \order ->
        ( "NewsletterTags"
        , FormField.mkTag <|
            FormField.setIsRequired IsRequired.Yes
                >> FormField.setLabel "Newsletter Tags"
                >> FormField.setOrder order
                >> FormField.setPlaceholder (Just "Add new tag...")
                >> FormField.setValue (Set.fromList [ "Hello", "Goodbye", "Beta" ])
        )
    ]
        |> List.indexedMap (\index field -> field index)
        |> Dict.fromList
