module Form.Field.RadioBoolSpec exposing (..)

import Expect
import Form.Field.RadioBool as RadioBool
import Test exposing (..)


suite : Test
suite =
    describe "Form.Field.RadioBool.decoder"
        [ test "True RadioBool option" <|
            \_ ->
                RadioBool.fromString "Yes"
                    |> Expect.equal (Just True)
        , test "False RadioBool option" <|
            \_ ->
                RadioBool.fromString "No"
                    |> Expect.equal (Just False)
        , test "Incorrect RadioBool option" <|
            \_ ->
                RadioBool.fromString "N/A"
                    |> Expect.equal Nothing
        ]
