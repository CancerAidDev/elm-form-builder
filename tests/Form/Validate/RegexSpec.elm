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
                , locale = Locale.enAU
                }
            ]
        , Test.describe "validate phone number field containing custom regex"
            [ HelperSpec.simpleFieldTest (FieldType.SimpleType FieldType.Phone)
                HelperSpec.phoneFieldWithCustomRegex
                { valid =
                    [ { value = "312345123", name = "Valid NZ 9-digit landline" }
                    , { value = "91245632", name = "Valid NZ 8-digit landline" }
                    ]
                , invalid =
                    [ { value = "512345678", error = Types.RegexIncongruence "Invalid landline number (example: 3, 4, 6, 7, 9 XXX XXX [XX])", name = "Fails to match expected regex - invalid area code" }
                    , { value = "712345", error = Types.RegexIncongruence "Invalid landline number (example: 3, 4, 6, 7, 9 XXX XXX [XX])", name = "Fails to match expected regex - landline number is too short" }
                    , { value = "91234567898", error = Types.RegexIncongruence "Invalid landline number (example: 3, 4, 6, 7, 9 XXX XXX [XX])", name = "Fails to match expected regex - landline number is too long" }
                    ]
                , locale = Locale.enNZ
                }
            ]
        ]
