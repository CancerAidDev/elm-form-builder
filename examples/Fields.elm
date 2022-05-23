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
        , ( "age"
          , FormField.NumericField_ <|
                FormField.NumericField
                    { required = True
                    , label = "Age"
                    , title = "Age"
                    , width = Width.FullSize
                    , enabledBy = Nothing
                    , order = 3
                    , tipe = FieldType.Age
                    , value = Nothing
                    }
          )
        ]
