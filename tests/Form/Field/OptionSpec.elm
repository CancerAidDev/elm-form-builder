module Form.Field.OptionSpec exposing (suite)

import Expect
import Form.Field.Option as Option
import Json.Decode as Decode
import Test


suite : Test.Test
suite =
    Test.describe "Form.Field.Option"
        [ Test.describe "decoder"
            [ Test.test "Valid Select options" <|
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
            , Test.test "Missing label field" <|
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
            , Test.test "Missing value field" <|
                \_ ->
                    let
                        json =
                            """{ 
                            "label": "Label"
                        }"""
                    in
                    Decode.decodeString Option.decoder json
                        |> Expect.err
            , Test.test "Incorrect Select field" <|
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
        ]
