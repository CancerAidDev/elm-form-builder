module Form.Types.OptionSpec exposing (..)

import Expect
import Form.Types.Option as Option
import Json.Decode as Decode
import Test exposing (..)


suite : Test
suite =
    describe "Types.Form.Option"
        [ describe "decoder"
            [ test "Valid Select options" <|
                \_ ->
                    let
                        json =
                            """{ 
                            "label": "Label", 
                            "value": "value"
                        }"""
                    in
                    Decode.decodeString Option.decoder json
                        |> Expect.equal
                            (Ok
                                { label = Just "Label"
                                , value = "value"
                                }
                            )
            , test "Missing label field" <|
                \_ ->
                    let
                        json =
                            """{ 
                            "value": "value"
                        }"""
                    in
                    Decode.decodeString Option.decoder json
                        |> Expect.equal
                            (Ok
                                { label = Nothing
                                , value = "value"
                                }
                            )
            , test "Missing value field" <|
                \_ ->
                    let
                        json =
                            """{ 
                            "label": "Label"
                        }"""
                    in
                    Decode.decodeString Option.decoder json
                        |> Expect.err
            , test "Incorrect Select field" <|
                \_ ->
                    let
                        json =
                            """{ 
                            "id": "id", 
                            "name": "Name"
                        }"""
                    in
                    Decode.decodeString Option.decoder json
                        |> Expect.err
            ]
        , describe "remoteOptionDecoderr"
            [ test "Valid Http Select options" <|
                \_ ->
                    let
                        json =
                            """
                            {
                                "id": "qE9cRJ",
                                "name": "Lang, Runte and Lesch"
                            }
                            """
                    in
                    Decode.decodeString Option.remoteOptionDecoder json
                        |> Expect.equal
                            (Ok
                                { label = Just "Lang, Runte and Lesch"
                                , value = "qE9cRJ"
                                }
                            )
            , test "Missing id field" <|
                \_ ->
                    let
                        json =
                            """
                            {
                                "name": "Lang, Runte and Lesch"
                            }
                            """
                    in
                    Decode.decodeString Option.remoteOptionDecoder json
                        |> Expect.err
            , test "Incorrect field" <|
                \_ ->
                    let
                        json =
                            """
                            {
                                "label": "qE9cRJ",
                                "name": "Lang, Runte and Lesch"
                            }
                            """
                    in
                    Decode.decodeString Option.remoteOptionDecoder json
                        |> Expect.err
            ]
        ]
