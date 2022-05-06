module Form.Field.WidthSpec exposing (..)

import Expect
import Form.Field.Width as Width
import Json.Decode as Decode
import Test exposing (..)


suite : Test
suite =
    describe "Form.Types.Width.decoder"
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
