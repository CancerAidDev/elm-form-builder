module Form.Validate.StringFieldSpec exposing (suite)

import Expect
import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.Required as Required
import Form.Field.Width as Width
import Form.Locale as Locale
import Form.Validate.StringField as StringField
import Test


suite : Test.Test
suite =
    Test.describe "Form.Validate.StringField"
        [ Test.describe "validate"
            [ simpleFieldTest
                FieldType.Text
                { valid = [ { value = "asdf", name = "Simple text" } ]
                , invalid = []
                , locale = Locale.enAU
                }
            , simpleFieldTest
                FieldType.Email
                { valid = [ { value = "test@canceraid.com", name = "Simple email" } ]
                , invalid = [ { value = "asdf", error = StringField.InvalidEmail, name = "Email without @ .com" } ]
                , locale = Locale.enAU
                }
            , simpleFieldTest
                (FieldType.Date FieldType.DatePast)
                { valid = [ { value = "2022-05-30", name = "Simple date" } ]
                , invalid = [ { value = "asdf", error = StringField.InvalidDate, name = "Text as date" } ]
                , locale = Locale.enAU
                }
            , simpleFieldTest
                (FieldType.Date FieldType.DateOfBirth)
                { valid = [ { value = "2022-05-30", name = "Simple date" } ]
                , invalid = [ { value = "asdf", error = StringField.InvalidDate, name = "Text as date" } ]
                , locale = Locale.enAU
                }
            , simpleFieldTest
                FieldType.Phone
                { valid = [ { value = "432432432", name = "Correct format and length" } ]
                , invalid =
                    [ { value = "123456789", error = StringField.InvalidMobilePhoneNumber, name = "Doesn't begin with 4" }
                    , { value = "4234567890", error = StringField.InvalidPhoneNumber, name = "> 9 digits" }
                    , { value = "42345678", error = StringField.InvalidPhoneNumber, name = "< 9 digits" }
                    , { value = "asdf", error = StringField.InvalidPhoneNumber, name = "not digits" }
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
                    [ { value = "12345678", error = StringField.InvalidMobilePhoneNumber, name = "Doesn't begin with 2" }
                    , { value = "234567", error = StringField.InvalidMobilePhoneNumber, name = "< 8 digits" }
                    , { value = "23456789012", error = StringField.InvalidMobilePhoneNumber, name = "> 10 digits" }
                    , { value = "asdf", error = StringField.InvalidPhoneNumber, name = "not digits" }
                    ]
                , locale = Locale.enNZ
                }
            , simpleFieldTest
                FieldType.Phone
                { valid = [ { value = "2342340000", name = "Correct format and length" } ]
                , invalid =
                    [ { value = "123123000", error = StringField.InvalidMobilePhoneNumber, name = "Doesn't begin with 2-9" }
                    , { value = "23423400000", error = StringField.InvalidMobilePhoneNumber, name = "> 10 digits" }
                    , { value = "234234000", error = StringField.InvalidMobilePhoneNumber, name = "< 10 digits" }
                    , { value = "asdf", error = StringField.InvalidPhoneNumber, name = "Doesn't begin with 2" }
                    ]
                , locale = Locale.enUS
                }
            , simpleFieldTest
                FieldType.Url
                { valid = [ { value = "https://canceraid.com", name = "Simple url" } ]
                , invalid = [ { value = "asdf", error = StringField.InvalidUrl, name = "Not url format" } ]
                , locale = Locale.enAU
                }
            , simpleFieldTest
                FieldType.TextArea
                { valid = [ { value = "asdf", name = "Simple text" } ]
                , invalid = []
                , locale = Locale.enAU
                }
            ]
        ]


simpleFieldTest : FieldType.SimpleFieldType -> { valid : List { value : String, name : String }, invalid : List { value : String, error : StringField.StringError, name : String }, locale : Locale.Locale } -> Test.Test
simpleFieldTest tipe { valid, invalid, locale } =
    let
        field : { required : Required.IsRequired, value : String } -> Field.StringField
        field =
            simpleField tipe

        validTest : { required : Required.IsRequired } -> List Test.Test
        validTest { required } =
            List.map
                (\{ value, name } ->
                    Test.test ("valid - " ++ name) <|
                        \_ ->
                            field { required = required, value = value }
                                |> StringField.validate locale
                                |> Expect.ok
                )
                valid

        invalidTest : { required : Required.IsRequired } -> List Test.Test
        invalidTest { required } =
            List.map
                (\{ value, error, name } ->
                    Test.test ("invalid - " ++ name ++ " " ++ Debug.toString error) <|
                        \_ ->
                            field { required = required, value = value }
                                |> StringField.validate locale
                                |> Expect.equal (Err error)
                )
                invalid

        nonemptyTest : { required : Required.IsRequired } -> Test.Test
        nonemptyTest config =
            Test.describe "non-empty"
                (validTest config ++ invalidTest config)

        requiredFieldTest : Test.Test
        requiredFieldTest =
            let
                required : Required.IsRequired
                required =
                    Required.Yes
            in
            Test.describe "required"
                [ Test.test "empty" <|
                    \_ ->
                        field { required = required, value = "" }
                            |> StringField.validate Locale.enAU
                            |> Expect.equal (Err StringField.EmptyError)
                , nonemptyTest { required = required }
                ]

        optionalFieldTest : Test.Test
        optionalFieldTest =
            let
                required : Required.IsRequired
                required =
                    Required.No
            in
            Test.describe "optional"
                [ Test.test "empty" <|
                    \_ ->
                        field { required = required, value = "" }
                            |> StringField.validate Locale.enAU
                            |> Expect.ok
                , nonemptyTest { required = required }
                ]
    in
    Test.describe (Debug.toString tipe ++ " - " ++ Locale.toString locale)
        [ requiredFieldTest
        , optionalFieldTest
        ]


simpleField : FieldType.SimpleFieldType -> { required : Required.IsRequired, value : String } -> Field.StringField
simpleField tipe { required, value } =
    Field.SimpleField
        { required = required
        , label = "Field"
        , width = Width.FullSize
        , enabledBy = Nothing
        , order = 1
        , value = value
        , tipe = tipe
        , disabled = False
        }
