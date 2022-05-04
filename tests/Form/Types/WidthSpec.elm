module Form.Types.WidthSpec exposing (..)

import Expect
import Form.Types.Width as Width
import Json.Decode as Decode
import Test exposing (..)


suite : Test
suite =
    describe "Types.Form.Width.decoder"
        [ test "Half Sized Width field" <|
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
        , test "Full Sized Width field" <|
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
        , test "Invalid Width field" <|
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
