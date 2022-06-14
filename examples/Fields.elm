module Fields exposing (..)

import Dict
import Form.Field as FormField
import Form.Field.Direction as Direction
import Form.Field.Width as Width
import Form.Fields as FormFields
import Set


fields : FormFields.Fields
fields =
    [ \order ->
        ( "Uneditable field"
        , FormField.text
            { required = False
            , label = "Uneditable Field"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , disabled = True
            , nullable = False
            }
        )
    , \order ->
        ( "not a valid email field"
        , FormField.email
            { required = False
            , label = "Not relevant Email Address"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , disabled = True
            , nullable = False
            }
        )
    , \order ->
        ( "name"
        , FormField.text
            { required = True
            , label = "Name"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , disabled = False
            , nullable = True
            }
        )
    , \order ->
        ( "email"
        , FormField.email
            { required = True
            , label = "Email Address"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , disabled = False
            , nullable = False
            }
        )
    , \order ->
        ( "secondaryEmail"
        , FormField.email
            { required = False
            , label = "Secondary Email Address"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , disabled = False
            , nullable = False
            }
        )
    , \order ->
        ( "age"
        , FormField.age
            { required = False
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
            { required = False
            , label = "Date of Birth"
            , width = Width.FullSize
            , enabledBy = Nothing
            , order = order
            , value = ""
            , disabled = False
            , nullable = True
            }
        )
    , \order ->
        ( "something"
        , FormField.select
            { required = False
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
            , nullable = False
            }
        )
    , \order ->
        ( "state"
        , FormField.select
            { required = False
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
            , nullable = True
            }
        )
    , \order ->
        ( "modes"
        , FormField.multiSelect
            { required = False
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
            { required = False
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
            { required = True
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
