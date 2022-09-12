module Form.Validate.HelperSpec exposing (simpleFieldTest)

import Expect
import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.Required as Required
import Form.Field.Width as Width
import Form.Locale as Locale
import Form.Validate.StringField as StringField
import Form.Validate.Types as Types
import Test


simpleFieldTest : FieldType.SimpleFieldType -> { valid : List { value : String, name : String }, invalid : List { value : String, error : Types.StringError, name : String }, locale : Locale.Locale } -> Test.Test
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
                            |> Expect.equal (Err Types.RequiredError)
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
        , hidden = False
        , unhiddenBy = Nothing
        }
