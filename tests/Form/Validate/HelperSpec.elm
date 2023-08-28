module Form.Validate.HelperSpec exposing (NewStringField, dateField, phoneField, regexNonEmployeeEmailField, simpleField, simpleFieldTest)

import Expect
import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.Required as Required
import Form.Field.Width as Width
import Form.Lib.RegexValidation as RegexValidation
import Form.Locale as Locale
import Form.Locale.CountryCode as CountryCode
import Form.Validate.StringField as StringField
import Form.Validate.Types as Types
import Test


type alias NewStringField =
    { required : Required.IsRequired, value : String } -> Field.StringField


type alias TestSuite =
    { valid : List { value : String, name : String }
    , invalid : List { value : String, error : Types.StringFieldError, name : String }
    , locale : Maybe Locale.Locale
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
                                |> StringField.validate
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
                                |> StringField.validate
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
                            |> StringField.validate
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
                            |> StringField.validate
                            |> Expect.ok
                , nonemptyTest { required = required }
                ]
    in
    Test.describe (Debug.toString tipe ++ " - " ++ (Maybe.map Locale.toString locale |> Maybe.withDefault "no locale"))
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
        , regexValidation = []
        }


phoneField : Maybe CountryCode.CountryCode -> NewStringField
phoneField countryCode { required, value } =
    Field.PhoneField
        { required = required
        , label = "Field"
        , width = Width.FullSize
        , enabledBy = Nothing
        , order = 1
        , value = value
        , disabled = False
        , hidden = False
        , unhiddenBy = Nothing
        , countryCode = countryCode
        , countryCodeDropdown = { value = countryCode, showDropdown = False, searchInput = "" }
        }


regexNonEmployeeEmailField : NewStringField
regexNonEmployeeEmailField { required, value } =
    Field.SimpleField
        { required = required
        , label = "Field"
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
