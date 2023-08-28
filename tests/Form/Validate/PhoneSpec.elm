module Form.Validate.PhoneSpec exposing (suite)

import Form.Field.FieldType as FieldType
import Form.Locale as Locale
import Form.Locale.CountryCode as CountryCode
import Form.Locale.LanguageCode as LanguageCode
import Form.Validate.HelperSpec as HelperSpec
import Form.Validate.Types as Types
import Test


suite : Test.Test
suite =
    Test.describe "Form.Validate.Phone"
        [ Test.describe "validate"
            [ HelperSpec.simpleFieldTest FieldType.Phone
                (HelperSpec.phoneField (Just CountryCode.AU))
                { valid = [ { value = "432432432", name = "Correct format and length" } ]
                , invalid =
                    [ { value = "123456789", error = Types.InvalidMobilePhoneNumber, name = "Doesn't begin with 4" }
                    , { value = "4234567890", error = Types.InvalidPhoneNumber, name = "> 9 digits" }
                    , { value = "42345678", error = Types.InvalidPhoneNumber, name = "< 9 digits" }
                    , { value = "asdf", error = Types.InvalidPhoneNumber, name = "not digits" }
                    ]
                , locale = Just Locale.enAU
                }
            , HelperSpec.simpleFieldTest FieldType.Phone
                (HelperSpec.phoneField (Just CountryCode.NZ))
                { valid =
                    [ { value = "21234567", name = "Correct format and length 8" }
                    , { value = "212345678", name = "Correct format and length 9" }
                    , { value = "2123456789", name = "Correct format and length 10" }
                    ]
                , invalid =
                    [ { value = "12345678", error = Types.InvalidMobilePhoneNumber, name = "Doesn't begin with 2" }
                    , { value = "234567", error = Types.InvalidMobilePhoneNumber, name = "< 8 digits" }
                    , { value = "23456789012", error = Types.InvalidMobilePhoneNumber, name = "> 10 digits" }
                    , { value = "asdf", error = Types.InvalidPhoneNumber, name = "not digits" }
                    ]
                , locale = Just Locale.enNZ
                }
            , HelperSpec.simpleFieldTest FieldType.Phone
                (HelperSpec.phoneField (Just CountryCode.US))
                { valid = [ { value = "2342340000", name = "Correct format and length" } ]
                , invalid =
                    [ { value = "123123000", error = Types.InvalidMobilePhoneNumber, name = "Doesn't begin with 2-9" }
                    , { value = "23423400000", error = Types.InvalidMobilePhoneNumber, name = "> 10 digits" }
                    , { value = "234234000", error = Types.InvalidMobilePhoneNumber, name = "< 10 digits" }
                    , { value = "asdf", error = Types.InvalidPhoneNumber, name = "Doesn't begin with 2" }
                    ]
                , locale = Just Locale.enUS
                }
            , HelperSpec.simpleFieldTest FieldType.Phone
                (HelperSpec.phoneField Nothing)
                { valid = []
                , invalid =
                    [ { value = "123123000", error = Types.InvalidMobilePhoneNumber, name = "Invalid without a locale" }
                    ]
                , locale = Nothing
                }
            , HelperSpec.simpleFieldTest FieldType.Phone
                (HelperSpec.phoneField (Just CountryCode.ES))
                { valid = [ { value = "123456789", name = "Correct format and length" } ]
                , invalid =
                    [ { value = "123456", error = Types.InvalidMobilePhoneNumber, name = "<7 digits" }
                    , { value = "1234567890123456", error = Types.InvalidMobilePhoneNumber, name = ">15 digits" }
                    ]
                , locale = Just <| Locale.Locale LanguageCode.ES CountryCode.ES
                }
            ]
        ]
