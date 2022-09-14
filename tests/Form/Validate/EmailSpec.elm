module Form.Validate.EmailSpec exposing (suite)

import Form.Field.FieldType as FieldType
import Form.Locale as Locale
import Form.Validate.HelperSpec as HelperSpec
import Form.Validate.Types as Types
import Test


suite : Test.Test
suite =
    Test.describe "Form.Validate.Email"
        [ Test.describe "validate"
            [ HelperSpec.simpleFieldTest (FieldType.SimpleType FieldType.Email)
                (HelperSpec.simpleField FieldType.Email)
                { valid = [ { value = "test@canceraid.com", name = "Simple email" } ]
                , invalid = [ { value = "asdf", error = Types.InvalidEmail, name = "Email without @ .com" } ]
                , locale = Locale.enAU
                }
            ]
        ]
