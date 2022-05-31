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
            [ describe "email"
                [ describe "required"
                    [ test "empty string error" <|
                        \_ ->
                            simpleField { tipe = FieldType.Email, required = True, value = "" }
                                |> StringField.validate Locale.enAU
                                |> Expect.equal (Err StringField.EmptyError)
                    , test "invalid email error" <|
                        \_ ->
                            simpleField { tipe = FieldType.Email, required = True, value = "asdf" }
                                |> StringField.validate Locale.enAU
                                |> Expect.equal (Err StringField.InvalidEmail)
                    , test "valid email ok" <|
                        \_ ->
                            simpleField { tipe = FieldType.Email, required = True, value = "test@canceraid.com" }
                                |> StringField.validate Locale.enAU
                                |> Expect.ok
                    ]
                , describe "optional"
                    [ test "empty string ok" <|
                        \_ ->
                            simpleField { tipe = FieldType.Email, required = False, value = "" }
                                |> StringField.validate Locale.enAU
                                |> Expect.ok
                    , test "invalid email error" <|
                        \_ ->
                            simpleField { tipe = FieldType.Email, required = False, value = "asdf" }
                                |> StringField.validate Locale.enAU
                                |> Expect.equal (Err StringField.InvalidEmail)
                    , test "valid email ok" <|
                        \_ ->
                            simpleField { tipe = FieldType.Email, required = False, value = "test@canceraid.com" }
                                |> StringField.validate Locale.enAU
                                |> Expect.ok
                    ]
                ]
            ]
        ]


simpleField : { tipe : FieldType.SimpleFieldType, required : Bool, value : String } -> Field.StringField
simpleField { tipe, required, value } =
    Field.SimpleField
        { required = required
        , label = "Field"
        , width = Width.FullSize
        , enabledBy = Nothing
        , order = 1
        , value = value
        , tipe = tipe
        }
