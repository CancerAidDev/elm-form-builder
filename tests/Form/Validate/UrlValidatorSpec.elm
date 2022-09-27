module Form.Validate.UrlValidatorSpec exposing (suite)

import Form.Field.FieldType as FieldType
import Form.Locale as Locale
import Form.Validate.HelperSpec as HelperSpec
import Form.Validate.Types as Types
import Test


suite : Test.Test
suite =
    Test.describe "Form.Validate.Url"
        [ Test.describe "validate"
            [ HelperSpec.simpleFieldTest (FieldType.SimpleType FieldType.Url)
                (HelperSpec.simpleField FieldType.Url)
                { valid = [ { value = "https://canceraid.com", name = "Simple url" } ]
                , invalid = [ { value = "asdf", error = Types.InvalidUrl, name = "Not url format" } ]
                , locale = Locale.enAU
                }
            ]
        ]
