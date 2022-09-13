module Form.Validate.TextSpec exposing (suite)

import Form.Field.FieldType as FieldType
import Form.Locale as Locale
import Form.Validate.HelperSpec exposing (simpleFieldTest)
import Test


suite : Test.Test
suite =
    Test.describe "Form.Validate.Text and Form.Validate.TextArea"
        [ Test.describe "validate"
            [ simpleFieldTest
                FieldType.Text
                { valid = [ { value = "asdf", name = "Simple text" } ]
                , invalid = []
                , locale = Locale.enAU
                }
            , simpleFieldTest
                FieldType.TextArea
                { valid = [ { value = "asdf", name = "Simple text" } ]
                , invalid = []
                , locale = Locale.enAU
                }
            ]
        ]
