module Form.Field.LabelExtraContentSpec exposing (suite)

import Expect
import Form.Field.LabelExtraContent as LabelExtraContent
import Json.Decode as Decode
import Test


suite : Test.Test
suite =
    Test.describe "Form.Field.LabelExtraContent"
        [ Test.describe "decoder"
            [ Test.test "Valid Label Extra Content" <|
                \_ ->
                    let
                        json =
                            """{ 
                            "content": "Label"
                        }"""
                    in
                    Decode.decodeString LabelExtraContent.decoder json
                        |> Expect.equal
                            (Ok
                                { content = "Label"
                                , classes = Nothing
                                }
                            )
            , Test.test "Valid Label Extra Content with classes" <|
                \_ ->
                    let
                        json =
                            """{ 
                            "content": "Label",
                            "classes": "classname"
                        }"""
                    in
                    Decode.decodeString LabelExtraContent.decoder json
                        |> Expect.equal
                            (Ok
                                { content = "Label"
                                , classes = Just "classname"
                                }
                            )
            , Test.test "Missing content field" <|
                \_ ->
                    let
                        json =
                            """{ 
                           "classes": "classname"
                        }"""
                    in
                    Decode.decodeString LabelExtraContent.decoder json
                        |> Expect.err
            , Test.test "Incorrect Select field" <|
                \_ ->
                    let
                        json =
                            """{ 
                            "id": "id"
                        }"""
                    in
                    Decode.decodeString LabelExtraContent.decoder json
                        |> Expect.err
            ]
        ]
