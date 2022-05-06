module Form.LocaleSpec exposing (..)

import Expect
import Form.Locale as Locale
import Test exposing (..)


suite : Test
suite =
    describe "Forms.Locale round trip"
        (locales
            |> List.map
                (\locale ->
                    test (Locale.toString locale) <|
                        \_ ->
                            Locale.toString locale
                                |> Locale.fromString
                                |> Expect.equal (Just locale)
                )
        )


locales : List Locale.Locale
locales =
    [ Locale.enAU ]
