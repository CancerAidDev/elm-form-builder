module Form.Field.RemoteOptionDecoderSpec exposing (suite)

import Expect
import Form.Field.RemoteOptionDecoder as RemoteOptionDecoder
import Json.Decode as Decode
import Test


suite : Test.Test
suite =
    Test.describe "Form.Field.RemoteOptionDecoder"
        [ Test.describe "decoder"
            [ Test.test "Valid remote option decoder" <|
                \_ ->
                    let
                        json =
                            """{ 
                            "label": "Label", 
                            "value": "value"
                        }"""
                    in
                    Decode.decodeString RemoteOptionDecoder.decoder json
                        |> Expect.equal
                            (Ok
                                { label = "Label"
                                , value = "value"
                                }
                            )
            , Test.test "Missing label field" <|
                \_ ->
                    let
                        json =
                            """{ 
                            "value": "value"
                        }"""
                    in
                    Decode.decodeString RemoteOptionDecoder.decoder json
                        |> Expect.err
            , Test.test "Missing value field" <|
                \_ ->
                    let
                        json =
                            """{ 
                            "label": "Label"
                        }"""
                    in
                    Decode.decodeString RemoteOptionDecoder.decoder json
                        |> Expect.err
            , Test.test "Incorrect field" <|
                \_ ->
                    let
                        json =
                            """{ 
                            "id": "id", 
                            "name": "Name"
                        }"""
                    in
                    Decode.decodeString RemoteOptionDecoder.decoder json
                        |> Expect.err
            ]
        , Test.describe "remoteOptionDecoder"
            [ Test.test "Valid decoder" <|
                \_ ->
                    let
                        json =
                            """{ 
                            "uuid": "12345",
                            "name": "Label"
                        }"""
                    in
                    Decode.decodeString (RemoteOptionDecoder.remoteOptionDecoder RemoteOptionDecoder.default) json
                        |> Expect.equal
                            (Ok
                                { label = Just "Label"
                                , value = "12345"
                                }
                            )
            , Test.test "Missing name field" <|
                \_ ->
                    let
                        json =
                            """{ 
                            "uuid": "value"
                        }"""
                    in
                    Decode.decodeString (RemoteOptionDecoder.remoteOptionDecoder RemoteOptionDecoder.default) json
                        |> Expect.err
            , Test.test "Missing uuid field" <|
                \_ ->
                    let
                        json =
                            """{ 
                            "name": "label"
                        }"""
                    in
                    Decode.decodeString (RemoteOptionDecoder.remoteOptionDecoder RemoteOptionDecoder.default) json
                        |> Expect.err
            ]
        ]
