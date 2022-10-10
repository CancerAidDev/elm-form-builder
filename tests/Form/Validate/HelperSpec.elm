module Form.Validate.HelperSpec exposing (NewStringField, dateField, regexNonEmployeeEmailField, simpleField, simpleFieldTest)

import Either
import Expect
import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.Required as Required
import Form.Field.Width as Width
import Form.Locale as Locale
import Form.Validate.StringField as StringField
import Form.Validate.Types as Types
import Regex
import Test


type alias NewStringField =
    { required : Required.IsRequired, value : String } -> Field.StringField


type alias TestSuite =
    { valid : List { value : String, name : String }
    , invalid : List { value : String, error : Types.StringFieldError, name : String }
    , locale : Locale.Locale
    }


simpleFieldTest : FieldType.StringFieldType -> NewStringField -> TestSuite -> Test.Test
simpleFieldTest tipe field { valid, invalid, locale } =
    let
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


simpleField : FieldType.SimpleFieldType -> NewStringField
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
        , regexValidation = Nothing
        }


regexNonEmployeeEmailField : FieldType.SimpleFieldType -> Either.Either String NewStringField
regexNonEmployeeEmailField tipe =
    let
        regexString : String
        regexString =
            -- regex that forbids strings that end with @bigcompany.com
            "([^@].{14}|.{1}[^b].{13}|.{2}[^i].{12}|.{3}[^g].{11}|.{4}[^c].{10}|.{5}[^o].{9}|.{6}[^m].{8}|.{7}[^p].{7}|.{8}[^a].{6}|.{9}[^n].{5}|.{10}[^y].{4}|.{11}[^.].{3}|.{12}[^c].{2}|.{13}[^o].{1}|.{14}[^m]$|^.{0,14})$"
    in
    case Regex.fromString regexString of
        Nothing ->
            Either.Left <| "Regex /" ++ regexString ++ "/ in test suite definition failed to compile"

        Just regex ->
            Either.Right <|
                \{ required, value } ->
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
                        , regexValidation =
                            Just
                                { pattern = regex
                                , message = "Please use the employee's personal email address"
                                }
                        }


dateField : FieldType.DateFieldType -> NewStringField
dateField tipe { required, value } =
    Field.DateField
        { required = required
        , label = "Field"
        , width = Width.FullSize
        , enabledBy = Nothing
        , order = 1
        , value = value
        , parsedDate = Nothing
        , tipe = tipe
        , disabled = False
        , hidden = False
        , unhiddenBy = Nothing
        }
