module Form.Types.RadioBoolSpec exposing (..)

import Expect
import Form.Types.RadioBool as RadioBool
import Json.Decode as Decode
import Test exposing (..)


suite : Test
suite =
    describe "Types.Form.RadioBool.decoder"
        [ test "True RadioBool option" <|
            \_ ->
                let
                    json =
                        """
                          "Yes"
                        """
                in
                Decode.decodeString RadioBool.decoder json
                    |> Expect.equal
                        (Ok
                            True
                        )
        , test "False RadioBool option" <|
            \_ ->
                let
                    json =
                        """
                          "No"
                        """
                in
                Decode.decodeString RadioBool.decoder json
                    |> Expect.equal
                        (Ok
                            False
                        )
        , test "Incorrect RadioBool option" <|
            \_ ->
                let
                    json =
                        """
                          "N/A"
                        """
                in
                Decode.decodeString RadioBool.decoder json
                    |> Expect.err
        ]
