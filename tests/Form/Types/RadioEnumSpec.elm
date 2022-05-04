module Form.Types.RadioEnumSpec exposing (..)

import Expect
import Form.Types.RadioEnum as RadioEnum
import Json.Decode as Decode
import Test exposing (..)


suite : Test
suite =
    describe "Types.Form.RadioEnum.decoder"
        [ test "True RadioEnum option" <|
            \_ ->
                let
                    json =
                        """
                          "Yes"
                        """
                in
                Decode.decodeString RadioEnum.decoder json
                    |> Expect.equal
                        (Ok
                            RadioEnum.Yes
                        )
        , test "False RadioEnum option" <|
            \_ ->
                let
                    json =
                        """
                          "No"
                        """
                in
                Decode.decodeString RadioEnum.decoder json
                    |> Expect.equal
                        (Ok
                            RadioEnum.No
                        )
        , test "N/A RadioEnum option" <|
            \_ ->
                let
                    json =
                        """
                          "N/A"
                        """
                in
                Decode.decodeString RadioEnum.decoder json
                    |> Expect.equal
                        (Ok
                            RadioEnum.NA
                        )
        , test "Incorrect RadioEnum option" <|
            \_ ->
                let
                    json =
                        """
                          "Female"
                        """
                in
                Decode.decodeString RadioEnum.decoder json
                    |> Expect.err
        ]
