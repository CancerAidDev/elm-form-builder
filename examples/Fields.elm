module Fields exposing (..)

import Dict
import Form.Field as FormField
import Form.Field.FieldType as FieldType
import Form.Field.Width as Width
import Form.Fields as FormFields


fields : FormFields.Fields
fields =
    Dict.fromList
        [ ( "name"
          , FormField.StringField_ <|
                FormField.SimpleField
                    { required = True
                    , label = "Name"
                    , width = Width.FullSize
                    , enabledBy = Nothing
                    , order = 1
                    , tipe = FieldType.Text
                    , value = ""
                    }
          )
        , ( "email"
          , FormField.StringField_ <|
                FormField.SimpleField
                    { required = True
                    , label = "Email Address"
                    , width = Width.FullSize
                    , enabledBy = Nothing
                    , order = 2
                    , tipe = FieldType.Email
                    , value = ""
                    }
          )
        ]
