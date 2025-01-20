module Form.Field.DecoderForOptionsSpec exposing (suite)

import Expect
import Form.Field.DecoderForOptions as DecoderForOptions
import Json.Decode as Decode
import Test


suite : Test.Test
suite =
    Test.describe "Form.Field.DecoderForOptions"
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
                    Decode.decodeString DecoderForOptions.decoder json
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
                    Decode.decodeString DecoderForOptions.decoder json
                        |> Expect.err
            , Test.test "Missing value field" <|
                \_ ->
                    let
                        json =
                            """{ 
                            "label": "Label"
                        }"""
                    in
                    Decode.decodeString DecoderForOptions.decoder json
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
                    Decode.decodeString DecoderForOptions.decoder json
                        |> Expect.err
            ]
        , Test.describe "remoteOptionsDecoder"
            [ Test.test "Valid decoder - list format" <|
                \_ ->
                    let
                        json =
                            """
                            [{ 
                                "uuid": "12345",
                                "name": "Label"
                            }]
                            """
                    in
                    Decode.decodeString (DecoderForOptions.remoteOptionsDecoder DecoderForOptions.default) json
                        |> Expect.equal
                            (Ok
                                [ { label = Just "Label"
                                  , value = "12345"
                                  }
                                ]
                            )
            , Test.test "Valid decoder - paginated format" <|
                \_ ->
                    let
                        json =
                            """{
                                "count": 1,
                                "data": [{ 
                                    "uuid": "12345",
                                    "name": "Label"
                                }]
                            }"""
                    in
                    Decode.decodeString (DecoderForOptions.remoteOptionsDecoder DecoderForOptions.default) json
                        |> Expect.equal
                            (Ok
                                [ { label = Just "Label"
                                  , value = "12345"
                                  }
                                ]
                            )
            , Test.test "Missing name field" <|
                \_ ->
                    let
                        json =
                            """
                            [{ 
                                "uuid": "12345"
                            }]
                            """
                    in
                    Decode.decodeString (DecoderForOptions.remoteOptionsDecoder DecoderForOptions.default) json
                        |> Expect.err
            , Test.test "Missing uuid field" <|
                \_ ->
                    let
                        json =
                            """
                            [{
                                "name": "Label"
                            }]
                            """
                    in
                    Decode.decodeString (DecoderForOptions.remoteOptionsDecoder DecoderForOptions.default) json
                        |> Expect.err
            ]
        ]
