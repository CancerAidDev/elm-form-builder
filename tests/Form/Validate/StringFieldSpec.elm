module Form.Validate.StringFieldSpec exposing (suite)

import Expect
import Form.Field.Required as IsRequired
import Form.Locale as Locale
import Form.Locale.CountryCode as CountryCode
import Form.Locale.LanguageCode as LanguageCode
import Form.Validate.HelperSpec as HelperSpec
import Form.Validate.StringField as StringField
import Form.Validate.Types as Types
import Fuzz
import Test


suite : Test.Test
suite =
    Test.describe "Form.Validate."
        [ Test.describe "errorToMessage"
            [ Test.fuzz (Fuzz.intRange 20 29) "en-NZ mobile errors 20-29 - too short" <|
                \startPhoneNumber ->
                    let
                        startPhoneNumberStr =
                            String.fromInt startPhoneNumber

                        phoneNumber =
                            HelperSpec.phoneField (Just Locale.enNZ) { required = IsRequired.Yes, value = startPhoneNumberStr ++ " 000" }
                    in
                    StringField.errorToMessage phoneNumber Types.InvalidMobilePhoneNumber |> Expect.equal ("Invalid mobile number (example: " ++ startPhoneNumberStr ++ " XXX XXX[XX])")
            , Test.test "en-NZ mobile too short - default prefix 20 - too short - not even a prefix" <|
                \_ ->
                    let
                        phoneNumber =
                            HelperSpec.phoneField (Just Locale.enNZ) { required = IsRequired.Yes, value = "1" }
                    in
                    StringField.errorToMessage phoneNumber Types.InvalidMobilePhoneNumber |> Expect.equal "Invalid mobile number (example: 2X XXX XXX[XX])"
            , Test.test "en-NZ mobile too short - default prefix 20 - wrong prefix" <|
                \_ ->
                    let
                        phoneNumber =
                            HelperSpec.phoneField (Just Locale.enNZ) { required = IsRequired.Yes, value = "31 123" }
                    in
                    StringField.errorToMessage phoneNumber Types.InvalidMobilePhoneNumber |> Expect.equal "Invalid mobile number (example: 2X XXX XXX[XX])"
            , Test.test "en-AU incorrect number" <|
                \_ ->
                    let
                        phoneNumber =
                            HelperSpec.phoneField (Just Locale.enAU) { required = IsRequired.Yes, value = "400" }
                    in
                    StringField.errorToMessage phoneNumber Types.InvalidMobilePhoneNumber |> Expect.equal "Invalid mobile number (example: 4XX XXX XXX)"
            , Test.test "en-US incorrect number" <|
                \_ ->
                    let
                        phoneNumber =
                            HelperSpec.phoneField (Just Locale.enUS) { required = IsRequired.Yes, value = "212 3" }
                    in
                    StringField.errorToMessage phoneNumber Types.InvalidMobilePhoneNumber |> Expect.equal "Invalid mobile number (example: 212 2XX XXXX)"
            , Test.test "incorrect number with no country code" <|
                \_ ->
                    let
                        phoneNumber =
                            HelperSpec.phoneField Nothing { required = IsRequired.Yes, value = "925 2952" }
                    in
                    StringField.errorToMessage phoneNumber Types.InvalidMobilePhoneNumber |> Expect.equal "Invalid mobile number"
            , Test.test "incorrect number for unknown locale" <|
                \_ ->
                    let
                        phoneNumber =
                            HelperSpec.phoneField (Just <| Locale.Locale LanguageCode.ES CountryCode.ES) { required = IsRequired.Yes, value = "925 295" }
                    in
                    StringField.errorToMessage phoneNumber Types.InvalidMobilePhoneNumber |> Expect.equal "Invalid mobile number"
            ]
        ]
