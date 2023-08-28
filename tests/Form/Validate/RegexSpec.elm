module Form.Validate.RegexSpec exposing (suite)

import Form.Field.FieldType as FieldType
import Form.Validate.HelperSpec as HelperSpec
import Form.Validate.Types as Types
import Test


suite : Test.Test
suite =
    Test.describe "Form.Validate.Regex"
        [ Test.describe "validate email"
            [ HelperSpec.simpleFieldTest (FieldType.SimpleType FieldType.Email)
                HelperSpec.regexNonEmployeeEmailField
                { valid =
                    [ { value = "test@example.com", name = "Valid email" }
                    , { value = "company@company.com", name = "Valid company email" }
                    , { value = "test@organisation.org", name = "Valid organisation email" }
                    ]
                , invalid =
                    [ { value = "test@bigorganisation.org", error = Types.RegexIncongruence "Please don't use the organisation email", name = "Fail if email ends in forbidden regex" }
                    , { value = "test@au.bigcompany.com", error = Types.RegexIncongruence "Please don't use the company email", name = "Fail if email ends in forbidden regex" }
                    , { value = "test@", error = Types.InvalidEmail, name = "Still fails based on default email regex criteria if custom criteria is passed" }
                    ]
                , locale = Nothing
                }
            ]
        ]
