module Fields exposing (..)

import Dict
import Form.Field as FormField
import Form.Field.Direction as Direction
import Form.Field.Required as IsRequired
import Form.Field.Width as Width
import Form.Fields as FormFields
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
            }
        )
    , \order ->
        ( "name"
        , FormField.text
            { required = IsRequired.Yes
            , label = "Name"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , disabled = False
            }
        )
    , \order ->
        ( "email"
        , FormField.email
            { required = IsRequired.Yes
            , label = "Email Address"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , disabled = False
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
            }
        )
    , \order ->
        ( "age"
        , FormField.age
            { required = IsRequired.Yes
            , label = "Age"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = Nothing
            , disabled = False
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
                , { label = Nothing, value = "Tasmanian" }
                , { label = Nothing, value = "Victorian" }
                , { label = Nothing, value = "Western Australia" }
                ]
            , disabled = False
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
            }
        )
    ]
        |> List.indexedMap (\index field -> field index)
        |> Dict.fromList
