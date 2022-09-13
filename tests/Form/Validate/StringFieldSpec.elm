module Form.Validate.StringFieldSpec exposing (suite)

import Expect
import Form.Field.FieldType
import Form.Field.Required as IsRequired
import Form.Locale as Locale
import Form.Validate.HelperSpec as HelperSpec
import Form.Validate.StringField as StringField
import Form.Validate.Types as Types
import Fuzz
import Test


suite : Test.Test
suite =
    Test.describe "Form.Validate.StringField"
        [ Test.describe "errorToMessage"
            [ Test.fuzz (Fuzz.intRange 20 29) "en-NZ mobile errors 20-29" <|
                \startPhoneNumber ->
                    let
                        startPhoneNumberStr =
                            String.fromInt startPhoneNumber

                        phoneNumber =
                            HelperSpec.simpleField Form.Field.FieldType.Phone { required = IsRequired.Yes, value = startPhoneNumberStr ++ " 000" }
                    in
                    StringField.errorToMessage Locale.enNZ phoneNumber Types.InvalidMobilePhoneNumber |> Expect.equal ("Invalid mobile number (example: " ++ startPhoneNumberStr ++ " XXX XXX[XX])")
            , Test.test "en-NZ mobile too short - default prefix 20" <|
                \_ ->
                    let
                        phoneNumber =
                            HelperSpec.simpleField Form.Field.FieldType.Phone { required = IsRequired.Yes, value = "1" }
                    in
                    StringField.errorToMessage Locale.enNZ phoneNumber Types.InvalidMobilePhoneNumber |> Expect.equal "Invalid mobile number (example: 20 XXX XXX[XX])"
            , Test.test "en-AU incorrect number" <|
                \_ ->
                    let
                        phoneNumber =
                            HelperSpec.simpleField Form.Field.FieldType.Phone { required = IsRequired.Yes, value = "400" }
                    in
                    StringField.errorToMessage Locale.enAU phoneNumber Types.InvalidMobilePhoneNumber |> Expect.equal "Invalid mobile number (example: 4XX XXX XXX)"
            , Test.test "en-US incorrect number" <|
                \_ ->
                    let
                        phoneNumber =
                            HelperSpec.simpleField Form.Field.FieldType.Phone { required = IsRequired.Yes, value = "212 3" }
                    in
                    StringField.errorToMessage Locale.enUS phoneNumber Types.InvalidMobilePhoneNumber |> Expect.equal "Invalid mobile number (example: 212 2XX XXXX)"
            ]
        ]
