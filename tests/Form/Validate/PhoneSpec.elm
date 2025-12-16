module Form.Validate.PhoneSpec exposing (suite)

import Form.Field.FieldType as FieldType
import Form.Locale as Locale
import Form.Validate.HelperSpec as HelperSpec
import Form.Validate.Types as Types
import Test


suite : Test.Test
suite =
    Test.describe "Form.Validate.Phone"
        [ Test.describe "validate"
            [ HelperSpec.simpleFieldTest (FieldType.SimpleType FieldType.Phone)
                (HelperSpec.simpleField FieldType.Phone)
                { valid = [ { value = "432432432", name = "Correct format and length" } ]
                , invalid =
                    [ { value = "123456789", error = Types.InvalidMobilePhoneNumber, name = "Doesn't begin with 4" }
                    , { value = "0432432432", error = Types.InvalidPhoneNumber, name = "Leading 0" }
                    , { value = "4234567890", error = Types.InvalidPhoneNumber, name = "> 9 digits" }
                    , { value = "42345678", error = Types.InvalidPhoneNumber, name = "< 9 digits" }
                    , { value = "asdf", error = Types.InvalidPhoneNumber, name = "not digits" }
                    ]
                , locale = Locale.enAU
                }
            , HelperSpec.simpleFieldTest (FieldType.SimpleType FieldType.Phone)
                (HelperSpec.simpleField FieldType.Phone)
                { valid =
                    [ { value = "21234567", name = "Correct format and length 8" }
                    , { value = "212345678", name = "Correct format and length 9" }
                    , { value = "2123456789", name = "Correct format and length 10" }
                    ]
                , invalid =
                    [ { value = "12345678", error = Types.InvalidMobilePhoneNumber, name = "Doesn't begin with 2" }
                    , { value = "021700000", error = Types.InvalidMobilePhoneNumber, name = "Leading 0" }
                    , { value = "234567", error = Types.InvalidMobilePhoneNumber, name = "< 8 digits" }
                    , { value = "23456789012", error = Types.InvalidMobilePhoneNumber, name = "> 10 digits" }
                    , { value = "asdf", error = Types.InvalidPhoneNumber, name = "not digits" }
                    ]
                , locale = Locale.enNZ
                }
            , HelperSpec.simpleFieldTest (FieldType.SimpleType FieldType.Phone)
                (HelperSpec.simpleField FieldType.Phone)
                { valid =
                    [ { value = "2342340000", name = "Correct format and length (US number)" }
                    , { value = "6475555678", name = "Correct format and length (Canadian number)" }
                    ]
                , invalid =
                    [ { value = "123123000", error = Types.InvalidMobilePhoneNumber, name = "Doesn't begin with 2-9" }
                    , { value = "02342340000", error = Types.InvalidMobilePhoneNumber, name = "Leading 0" }
                    , { value = "23423400000", error = Types.InvalidMobilePhoneNumber, name = "> 10 digits" }
                    , { value = "234234000", error = Types.InvalidMobilePhoneNumber, name = "< 10 digits" }
                    , { value = "9115555678", error = Types.InvalidMobilePhoneNumber, name = "Canadian service number" }
                    , { value = "asdf", error = Types.InvalidPhoneNumber, name = "not digits" }
                    ]
                , locale = Locale.enUS
                }
            , HelperSpec.simpleFieldTest (FieldType.SimpleType FieldType.Phone)
                (HelperSpec.simpleField FieldType.Phone)
                { valid =
                    [ { value = "6475555678", name = "Valid Canadian number (Toronto)" }
                    , { value = "6045551234", name = "Valid Canadian number (Vancouver)" }
                    ]
                , invalid =
                    [ { value = "123123000", error = Types.InvalidMobilePhoneNumber, name = "Doesn't begin with 2-9" }
                    , { value = "06475555678", error = Types.InvalidMobilePhoneNumber, name = "Leading 0" }
                    , { value = "647555567", error = Types.InvalidMobilePhoneNumber, name = "< 10 digits" }
                    , { value = "64755556789", error = Types.InvalidMobilePhoneNumber, name = "> 10 digits" }
                    , { value = "9115555678", error = Types.InvalidMobilePhoneNumber, name = "Canadian service number" }
                    , { value = "asdf", error = Types.InvalidPhoneNumber, name = "not digits" }
                    ]
                , locale = Locale.enCA
                }
            ]
        ]
