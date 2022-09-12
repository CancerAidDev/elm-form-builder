module Form.Validate.UrlValidatorSpec exposing (suite)

import Form.Field.FieldType as FieldType
import Form.Locale as Locale
import Form.Validate.HelperSpec exposing (simpleFieldTest)
import Form.Validate.Types as Types
import Test


suite : Test.Test
suite =
    Test.describe "Form.Validate.Date"
        [ Test.describe "validate"
            [ simpleFieldTest
                FieldType.Url
                { valid = [ { value = "https://canceraid.com", name = "Simple url" } ]
                , invalid = [ { value = "asdf", error = Types.InvalidUrl, name = "Not url format" } ]
                , locale = Locale.enAU
                }
            ]
        ]
