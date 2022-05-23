module Fields exposing (..)

import Dict
import Form.Field as FormField
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
                , title = "Age"
                , width = Width.FullSize
                , enabledBy = Nothing
                , order = 3
                , value = Nothing
                }
          )
        ]
