module Form.Validate.PhoneSpec exposing (suite)

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
                FieldType.Phone
                { valid = [ { value = "432432432", name = "Correct format and length" } ]
                , invalid =
                    [ { value = "123456789", error = Types.InvalidMobilePhoneNumber, name = "Doesn't begin with 4" }
                    , { value = "4234567890", error = Types.InvalidPhoneNumber, name = "> 9 digits" }
                    , { value = "42345678", error = Types.InvalidPhoneNumber, name = "< 9 digits" }
                    , { value = "asdf", error = Types.InvalidPhoneNumber, name = "not digits" }
                    ]
                , locale = Locale.enAU
                }
            , simpleFieldTest
                FieldType.Phone
                { valid =
                    [ { value = "23456789", name = "Correct format and length 8" }
                    , { value = "234567890", name = "Correct format and length 9" }
                    , { value = "2345678901", name = "Correct format and length 10" }
                    ]
                , invalid =
                    [ { value = "12345678", error = Types.InvalidMobilePhoneNumber, name = "Doesn't begin with 2" }
                    , { value = "234567", error = Types.InvalidMobilePhoneNumber, name = "< 8 digits" }
                    , { value = "23456789012", error = Types.InvalidMobilePhoneNumber, name = "> 10 digits" }
                    , { value = "asdf", error = Types.InvalidPhoneNumber, name = "not digits" }
                    ]
                , locale = Locale.enNZ
                }
            , simpleFieldTest
                FieldType.Phone
                { valid = [ { value = "2342340000", name = "Correct format and length" } ]
                , invalid =
                    [ { value = "123123000", error = Types.InvalidMobilePhoneNumber, name = "Doesn't begin with 2-9" }
                    , { value = "23423400000", error = Types.InvalidMobilePhoneNumber, name = "> 10 digits" }
                    , { value = "234234000", error = Types.InvalidMobilePhoneNumber, name = "< 10 digits" }
                    , { value = "asdf", error = Types.InvalidPhoneNumber, name = "Doesn't begin with 2" }
                    ]
                , locale = Locale.enUS
                }
            ]
        ]
