module Form.Validate.StringFieldSpec exposing (..)

import Expect
import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.Width as Width
import Form.Locale as Locale
import Form.Validate.StringField as StringField
import Test exposing (..)


suite : Test
suite =
    describe "Form.Validate.StringField"
        [ describe "validate"
            [ simpleFieldTest FieldType.Text
                { valid = "asdf"
                , invalid = []
                }
            , simpleFieldTest FieldType.Email
                { valid = "test@canceraid.com"
                , invalid = [ { value = "asdf", error = StringField.InvalidEmail } ]
                }
            , simpleFieldTest (FieldType.Date FieldType.DatePast)
                { valid = "2022-05-30"
                , invalid = [ { value = "asdf", error = StringField.InvalidDate } ]
                }
            , simpleFieldTest (FieldType.Date FieldType.DateOfBirth)
                { valid = "2022-05-30"
                , invalid = [ { value = "asdf", error = StringField.InvalidDate } ]
                }
            , simpleFieldTest FieldType.Phone
                { valid = "432432432"
                , invalid =
                    [ { value = "123456789", error = StringField.InvalidMobilePhoneNumber }
                    , { value = "asdf", error = StringField.InvalidPhoneNumber }
                    ]
                }
            , simpleFieldTest FieldType.Url
                { valid = "https://canceraid.com"
                , invalid = [ { value = "asdf", error = StringField.InvalidUrl } ]
                }
            , simpleFieldTest FieldType.TextArea
                { valid = "asdf"
                , invalid = []
                }
            ]
        ]


simpleFieldTest : FieldType.SimpleFieldType -> { valid : String, invalid : List { value : String, error : StringField.StringError } } -> Test
simpleFieldTest tipe { valid, invalid } =
    let
        field =
            simpleField tipe

        validTest { required } =
            test "valid" <|
                \_ ->
                    field { required = required, value = valid }
                        |> StringField.validate Locale.enAU
                        |> Expect.ok

        invalidTest { required } =
            List.map
                (\{ value, error } ->
                    test ("invalid " ++ Debug.toString error) <|
                        \_ ->
                            field { required = required, value = value }
                                |> StringField.validate Locale.enAU
                                |> Expect.equal (Err error)
                )
                invalid

        nonemptyTest config =
            describe "non-empty"
                (validTest config :: invalidTest config)

        requiredFieldTest =
            let
                required =
                    True
            in
            describe "required"
                [ test "empty" <|
                    \_ ->
                        field { required = required, value = "" }
                            |> StringField.validate Locale.enAU
                            |> Expect.equal (Err StringField.EmptyError)
                , nonemptyTest { required = required }
                ]

        optionalFieldTest =
            let
                required =
                    False
            in
            describe "optional"
                [ test "empty" <|
                    \_ ->
                        field { required = required, value = "" }
                            |> StringField.validate Locale.enAU
                            |> Expect.ok
                , nonemptyTest { required = required }
                ]
    in
    describe (Debug.toString tipe)
        [ requiredFieldTest
        , optionalFieldTest
        ]


simpleField : FieldType.SimpleFieldType -> { required : Bool, value : String } -> Field.StringField
simpleField tipe { required, value } =
    Field.SimpleField
        { required = required
        , label = "Field"
        , width = Width.FullSize
        , enabledBy = Nothing
        , order = 1
        , value = value
        , tipe = tipe
        }
