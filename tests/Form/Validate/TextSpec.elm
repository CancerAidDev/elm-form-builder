module Form.Validate.TextSpec exposing (suite)

import Form.Field.FieldType as FieldType
import Form.Locale as Locale
import Form.Validate.HelperSpec as HelperSpec
import Test


suite : Test.Test
suite =
    Test.describe "Form.Validate.Text and Form.Validate.TextArea"
        [ Test.describe "validate"
            [ HelperSpec.simpleFieldTest (FieldType.SimpleType FieldType.Text)
                (HelperSpec.simpleField FieldType.Text)
                { valid = [ { value = "asdf", name = "Simple text" } ]
                , invalid = []
                , locale = Locale.enAU
                }
            , HelperSpec.simpleFieldTest (FieldType.SimpleType FieldType.TextArea)
                (HelperSpec.simpleField FieldType.TextArea)
                { valid = [ { value = "asdf", name = "Simple text" } ]
                , invalid = []
                , locale = Locale.enAU
                }
            ]
        ]
