module Form.LocaleSpec exposing (suite)

import Expect
import Form.Locale as Locale
import Test


suite : Test.Test
suite =
    Test.describe "Form.Locale round trip"
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


locales : List Locale.Locale
locales =
    [ Locale.enAU ]
