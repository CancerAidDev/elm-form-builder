module Fields exposing (..)

import Dict
import Form.Field as FormField
import Form.Field.Direction as Direction
import Form.Field.Width as Width
import Form.Fields as FormFields


fields : FormFields.Fields
fields =
    Dict.fromList
        [ ( "name"
          , FormField.text
                { required = True
                , label = "Name"
                , width = Width.FullSize
                , enabledBy = Nothing
                , order = 1
                , value = ""
                }
          )
        , ( "email"
          , FormField.email
                { required = True
                , label = "Email Address"
                , width = Width.FullSize
                , enabledBy = Nothing
                , order = 2
                , value = ""
                }
          )
        , ( "age"
          , FormField.age
                { required = True
                , label = "Age"
                , width = Width.FullSize
                , enabledBy = Nothing
                , order = 3
                , value = Nothing
                }
          )
        , ( "dateOfBirth"
          , FormField.dateOfBirth
                { required = True
                , label = "Date of Birth"
                , width = Width.FullSize
                , enabledBy = Nothing
                , order = 4
                , value = ""
                }
          )
        , ( "state"
          , FormField.select
                { required = True
                , label = "State"
                , width = Width.FullSize
                , enabledBy = Nothing
                , order = 5
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
                }
          )
        , ( "updates"
          , FormField.radio
                { required = True
                , label = "Are you up to date with your updates?"
                , width = Width.FullSize
                , enabledBy = Nothing
                , order = 6
                , value = ""
                , default = Nothing
                , options =
                    [ { label = Nothing, value = "Yes" }
                    , { label = Nothing, value = "No" }
                    , { label = Nothing, value = "Unsure" }
                    ]
                , direction = Direction.Row
                }
          )
        , ( "newsletter"
          , FormField.radioBool
                { required = True
                , label = "Would you like to sign up to our newsletter?"
                , width = Width.FullSize
                , enabledBy = Nothing
                , order = 7
                , value = Nothing
                }
          )
        ]
