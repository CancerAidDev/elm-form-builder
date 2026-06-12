module Form.Validate.ColorSpec exposing (suite)

import Form.Field.FieldType as FieldType
import Form.Locale as Locale
import Form.Validate.HelperSpec as HelperSpec
import Test


suite : Test.Test
suite =
    Test.describe "Form.Validate.Color"
        [ Test.describe "validate"
            [ HelperSpec.simpleFieldTest FieldType.Color
                HelperSpec.colorField
                { valid = [ { value = "#ff0000", name = "Hex colour" } ]
                , invalid = []
                , locale = Locale.enAU
                }
            ]
        ]
