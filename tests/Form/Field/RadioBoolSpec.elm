module Form.Field.RadioBoolSpec exposing (suite)

import Expect
import Form.Field.RadioBool as RadioBool
import Test


suite : Test.Test
suite =
    Test.describe "Form.Field.RadioBool.decoder"
        [ Test.test "True RadioBool option" <|
            \_ ->
                RadioBool.fromString "Yes"
                    |> Expect.equal (Just True)
        , Test.test "False RadioBool option" <|
            \_ ->
                RadioBool.fromString "No"
                    |> Expect.equal (Just False)
        , Test.test "Incorrect RadioBool option" <|
            \_ ->
                RadioBool.fromString "N/A"
                    |> Expect.equal Nothing
        ]
