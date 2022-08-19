module Form.LocaleSpec exposing (suite)

import Expect
import Form.Locale as Locale
import Json.Decode as Decode
import Test


suite : Test.Test
suite =
    Test.describe "Form.Locale"
        [ Test.describe "string round trip"
            (locales
                |> List.map
                    (\locale ->
                        Test.test (Locale.toString locale) <|
                            \_ ->
                                Locale.toString locale
                                    |> Locale.fromString
                                    |> Expect.equal (Just locale)
                    )
            )
        , Test.describe "json round trip"
            (locales
                |> List.map
                    (\locale ->
                        Test.test (Locale.toString locale) <|
                            \_ ->
                                Locale.encode locale
                                    |> Decode.decodeValue Locale.decoder
                                    |> Expect.equal (Ok locale)
                    )
            )
        ]


locales : List Locale.Locale
locales =
    [ Locale.enAU ]
