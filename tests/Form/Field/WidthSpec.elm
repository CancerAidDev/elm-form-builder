module Form.Field.WidthSpec exposing (suite)

import Expect
import Form.Field.Width as Width
import Json.Decode as Decode
import Test


suite : Test.Test
suite =
    Test.describe "Form.Field.Width.decoder"
        [ Test.test "Half Sized Width field" <|
            \_ ->
                let
                    json =
                        """
                            "50%"
                        """
                in
                Decode.decodeString Width.decoder json
                    |> Expect.equal
                        (Ok
                            Width.HalfSize
                        )
        , Test.test "Full Sized Width field" <|
            \_ ->
                let
                    json =
                        """
                            "100%"
                        """
                in
                Decode.decodeString Width.decoder json
                    |> Expect.equal
                        (Ok
                            Width.FullSize
                        )
        , Test.test "Invalid Width field" <|
            \_ ->
                let
                    json =
                        """
                            "75%"
                        """
                in
                Decode.decodeString Width.decoder json
                    |> Expect.err
        ]
