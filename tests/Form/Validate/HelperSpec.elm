module Form.Validate.HelperSpec exposing (IntegerField, NewStringField, colorField, dateField, integerField, integerFieldTest, linearScaleField, regexNonEmployeeEmailField, simpleField, simpleFieldTest)

import Expect
import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.Required as Required
import Form.Field.Width as Width
import Form.Lib.RegexValidation as RegexValidation
import Form.Locale as Locale
import Form.Validate as Validate
import Form.Validate.StringField as StringField
import Form.Validate.Types as Types
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
        , labelExtraContent = Nothing
        , width = Width.FullSize
        , enabledBy = Nothing
        , order = 1
        , value = value
        , tipe = tipe
        , disabled = False
        , hidden = False
        , unhiddenBy = Nothing
        , regexValidation = []
        }


colorField : NewStringField
colorField { required, value } =
    Field.ColorField
        { required = required
        , label = "Field"
        , labelExtraContent = Nothing
        , width = Width.FullSize
        , enabledBy = Nothing
        , order = 1
        , value = value
        , disabled = False
        , hidden = False
        , unhiddenBy = Nothing
        , showHexValue = False
        }


regexNonEmployeeEmailField : NewStringField
regexNonEmployeeEmailField { required, value } =
    Field.SimpleField
        { required = required
        , label = "Field"
        , labelExtraContent = Nothing
        , width = Width.FullSize
        , enabledBy = Nothing
        , order = 1
        , value = value
        , tipe = FieldType.Email
        , disabled = False
        , hidden = False
        , unhiddenBy = Nothing
        , regexValidation =
            RegexValidation.fromSuffixConstraints <|
                List.map
                    (\forbiddenDomain -> ( forbiddenDomain.domain, forbiddenDomain.message ))
                    [ { domain = "bigorganisation.org"
                      , message = "Please don't use the organisation email"
                      }
                    , { domain = "bigcompany.com"
                      , message = "Please don't use the company email"
                      }
                    ]
        }


dateField : FieldType.DateFieldType -> NewStringField
dateField tipe { required, value } =
    Field.DateField
        { required = required
        , label = "Field"
        , labelExtraContent = Nothing
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


type alias IntegerField =
    { required : Required.IsRequired, value : Maybe Int } -> Field.IntegerField


integerField : Maybe Int -> Maybe Int -> IntegerField
integerField min max { required, value } =
    Field.SimpleIntegerField
        { required = required
        , label = "Field"
        , labelExtraContent = Nothing
        , width = Width.FullSize
        , enabledBy = Nothing
        , order = 1
        , value = value
        , disabled = False
        , hidden = False
        , unhiddenBy = Nothing
        , min = min
        , max = max
        }


linearScaleField : IntegerField
linearScaleField { required, value } =
    Field.LinearScaleField
        { required = required
        , label = "Field"
        , labelExtraContent = Nothing
        , width = Width.FullSize
        , enabledBy = Nothing
        , order = 1
        , value = value
        , min = 1
        , max = 5
        , leftLabel = Nothing
        , rightLabel = Nothing
        , disabled = False
        , hidden = False
        , unhiddenBy = Nothing
        }


integerFieldTest : String -> IntegerField -> List { value : Maybe Int, name : String } -> List { value : Maybe Int, error : Validate.IntegerError, name : String } -> Test.Test
integerFieldTest label field valid invalid =
    let
        validTests : Required.IsRequired -> List Test.Test
        validTests required =
            List.map
                (\{ value, name } ->
                    Test.test name <|
                        \_ ->
                            field { required = required, value = value }
                                |> Validate.validateIntegerField
                                |> Expect.ok
                )
                valid

        invalidTests : Required.IsRequired -> List Test.Test
        invalidTests required =
            List.map
                (\{ value, error, name } ->
                    Test.test name <|
                        \_ ->
                            field { required = required, value = value }
                                |> Validate.validateIntegerField
                                |> Expect.equal (Err error)
                )
                invalid
    in
    Test.describe label
        [ Test.describe "required"
            ((Test.test "empty" <|
                \_ ->
                    field { required = Required.Yes, value = Nothing }
                        |> Validate.validateIntegerField
                        |> Expect.equal (Err Validate.EmptyIntegerError)
             )
                :: validTests Required.Yes
                ++ invalidTests Required.Yes
            )
        , Test.describe "optional"
            ((Test.test "empty" <|
                \_ ->
                    field { required = Required.No, value = Nothing }
                        |> Validate.validateIntegerField
                        |> Expect.ok
             )
                :: validTests Required.No
                ++ invalidTests Required.No
            )
        ]
