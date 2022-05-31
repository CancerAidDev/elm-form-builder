module Form.Field.RadioEnumSpec exposing (suite)

import Expect
import Form.Field.RadioEnum as RadioEnum
import Json.Decode as Decode
import Test


suite : Test.Test
suite =
    Test.describe "Form.Field.RadioEnum.decoder"
        [ Test.test "True RadioEnum option" <|
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
        , Test.test "False RadioEnum option" <|
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
        , Test.test "N/A RadioEnum option" <|
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
        , Test.test "Incorrect RadioEnum option" <|
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
