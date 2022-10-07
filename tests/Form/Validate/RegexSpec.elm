module Form.Validate.RegexSpec exposing (suite)

import Form.Field.FieldType as FieldType
import Form.Locale as Locale
import Form.Validate.HelperSpec as HelperSpec
import Form.Validate.Types as Types
import Test


suite : Test.Test
suite =
    Test.describe "Form.Validate.Regex"
        [ Test.describe "validate email"
            [ HelperSpec.simpleFieldTest (FieldType.SimpleType FieldType.Email)
                (HelperSpec.regexNonEmployeeEmailField FieldType.Email)
                { valid = [ { value = "test@example.com", name = "Valid email" } ]
                , invalid =
                    [ { value = "test@bigcompany.com", error = Types.RegexIncongruence "Please use the employee's personal email address", name = "Fail if email ends in forbidden regex" }
                    , { value = "test@", error = Types.InvalidEmail, name = "Still fails based on default email regex criteria if custom criteria is passed" }
                    ]
                , locale = Locale.enAU
                }
            ]
        , Test.describe "illegal regex field"
            [ HelperSpec.simpleFieldTest (FieldType.SimpleType FieldType.Email)
                (HelperSpec.illegalRegexField FieldType.Email)
                { valid = []
                , invalid =
                    [ { value = "test@bigcompany.com", error = Types.IllegalRegex, name = "Fail if the pattern given is not a valid regex" } ]
                , locale = Locale.enAU
                }
            ]
        ]
