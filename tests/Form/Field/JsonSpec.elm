module Form.Field.JsonSpec exposing (suite)

import Dict
import Expect
import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.Json as Json
import Form.Field.Required as Required
import Form.Field.Width as Width
import Form.Fields as Fields
import Json.Decode as Decode
import Json.Encode as Encode
import RemoteData
import Test
import Time


suite : Test.Test
suite =
    let
        time =
            Time.millisToPosix 0

        order =
            0

        decoder =
            Json.decoder time order

        encode =
            Encode.dict identity identity << Fields.encode
    in
    Test.describe "Form.Field.Json"
        [ Test.describe "Decoding Fields"
            [ Test.test "Simple field decoder" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": true,
                                "key": "name",
                                "label": "Full Name",
                                "type": "text",
                                "width": "50%",
                                "nullable": true
                            }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "name"
                                , Field.StringField_ <|
                                    Field.SimpleField
                                        { tipe = FieldType.Text
                                        , label = "Full Name"
                                        , required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , order = order
                                        , value = ""
                                        , disabled = False
                                        }
                                )
                            )
            , Test.test "Simple field decoder with select type" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": true,
                                "key": "name",
                                "label": "Full Name",
                                "type": "select",
                                "width": "50%"
                            }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.err
            , Test.test "Simple field decoder with incorrect simple type" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": true,
                                "key": "name",
                                "label": "Full Name",
                                "type": "color",
                                "width": "50%"
                            }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.err
            , Test.test "Simple field decoder with missing field" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": true,
                                "key": "name",
                                "label": "Full Name",
                                "type": "text",
                            }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.err
            , Test.test "Simple field decoder with incorrect field" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": "true",
                                "key": "name",
                                "label": "Full Name",
                                "type": "text",
                                "width": "50%"
                            }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.err
            , Test.test "Select field decoder" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "metadata.pet",
                            "label": "Pet",
                            "type": "select",
                            "width": "50%",
                            "default": "Dog",
                            "nullable": true,
                            "options": [
                                { "value": "Dog" },
                                { "value": "Cat" },
                                { "value": "Parrot" }
                            ]
                        }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "metadata.pet"
                                , Field.StringField_
                                    (Field.SelectField
                                        { required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , label = "Pet"
                                        , default = Just "Dog"
                                        , options =
                                            [ { label = Nothing
                                              , value = "Dog"
                                              }
                                            , { label = Nothing
                                              , value = "Cat"
                                              }
                                            , { label = Nothing
                                              , value = "Parrot"
                                              }
                                            ]
                                        , value = "Dog"
                                        , order = order
                                        , disabled = False
                                        }
                                    )
                                )
                            )
            , Test.test "Select field decoder with http select type" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "metadata.pet",
                            "label": "Pet",
                            "type": "httpSelect",
                            "width": "50%",
                            "options": [
                                { "value": "Dog" },
                                { "value": "Cat" },
                                { "value": "Parrot" }
                            ]
                        }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.err
            , Test.test "Select field decoder with missing field" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "metadata.pet",
                            "label": "Pet",
                            "width": "50%",
                            "options": [
                                { "value": "Dog" },
                                { "value": "Cat" },
                                { "value": "Parrot" }
                            ]
                        }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.err
            , Test.test "Http Select field decoder" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "metadata.tag",
                            "label": "Tag",
                            "type": "httpSelect",
                            "width": "50%",
                            "url": "tags",
                            "nullable": true
                        }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "metadata.tag"
                                , Field.StringField_
                                    (Field.HttpSelectField
                                        { required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , default = Nothing
                                        , label = "Tag"
                                        , url = "tags"
                                        , options = RemoteData.NotAsked
                                        , value = ""
                                        , order = order
                                        , disabled = False
                                        }
                                    )
                                )
                            )
            , Test.test "Http Select field decoder with select type" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "metadata.tag",
                            "label": "Tag",
                            "type": "select",
                            "width": "50%",
                            "url": "tags"
                        }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.err
            , Test.test "Http Select field decoder with missing field" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "metadata.tag",
                            "label": "Tag",
                            "type": "select",
                            "width": "50%"
                        }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.err
            , Test.test "Checkbox field decoder" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": false,
                                "key": "isFoo",
                                "label": "Foo?",
                                "type": "checkbox",
                                "width": "100%"
                            }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "isFoo"
                                , Field.BoolField_
                                    (Field.CheckboxField
                                        { required = Required.No
                                        , width = Width.FullSize
                                        , enabledBy = Nothing
                                        , label = "Foo?"
                                        , tipe = FieldType.Checkbox
                                        , order = order
                                        , value = False
                                        , disabled = False
                                        }
                                    )
                                )
                            )
            , Test.test "Checkbox field decoder with missing field" <|
                \_ ->
                    let
                        json =
                            """{
                                "key": "isFoo",
                                "label": "Foo?",
                                "type": "checkbox",
                                "width": "100%"
                            }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.err
            , Test.test "Checkbox consent field decoder" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": true,
                                "key": "consent",
                                "label": "I agree",
                                "type": "checkbox_consent",
                                "width": "100%"
                            }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "consent"
                                , Field.BoolField_
                                    (Field.CheckboxField
                                        { tipe = FieldType.CheckboxConsent
                                        , required = Required.Yes
                                        , width = Width.FullSize
                                        , enabledBy = Nothing
                                        , label = "I agree"
                                        , order = order
                                        , value = False
                                        , disabled = False
                                        }
                                    )
                                )
                            )
            , Test.test "Checkbox consent field decoder with missing field" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": true,
                                "label": "I agree",
                                "type": "checkbox_consent",
                                "width": "100%"
                            }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.err
            ]
        , Test.describe "Encoding Fields"
            [ Test.test "Metadata encoding without metadata form elements" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "name"
                                  , Field.StringField_ <|
                                        Field.SimpleField
                                            { required = Required.Yes
                                            , label = "Full Name"
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , tipe = FieldType.Text
                                            , order = order
                                            , value = "Foo Bar"
                                            , disabled = False
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"name":"Foo Bar"}"""
            , Test.test "Metadata encoding with a metadata simple form element" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "metadata.tag"
                                  , Field.StringField_ <|
                                        Field.SimpleField
                                            { required = Required.Yes
                                            , label = "Tag"
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , tipe = FieldType.Text
                                            , order = order
                                            , value = "bar"
                                            , disabled = False
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"metadata":{"tag":"bar"}}"""
            , Test.test "Metadata encoding with a metadata select form element" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "metadata.pet"
                                  , Field.StringField_ <|
                                        Field.SelectField
                                            { required = Required.Yes
                                            , label = "Pet"
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , order = order
                                            , value = "Dog"
                                            , default = Nothing
                                            , options =
                                                [ { label = Nothing
                                                  , value = "Dog"
                                                  }
                                                , { label = Nothing
                                                  , value = "Cat"
                                                  }
                                                , { label = Nothing
                                                  , value = "Parrot"
                                                  }
                                                ]
                                            , disabled = False
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"metadata":{"pet":"Dog"}}"""
            , Test.test "Metadata encoding with a metadata httpSelect form element" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "metadata.tag"
                                  , Field.StringField_ <|
                                        Field.HttpSelectField
                                            { required = Required.Yes
                                            , label = "Tag"
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , order = order
                                            , value = "foo"
                                            , default = Nothing
                                            , options = RemoteData.NotAsked
                                            , url = "tags"
                                            , disabled = False
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"metadata":{"tag":"foo"}}"""
            , Test.test "Metadata encoding with multiple metadata form element" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "metadata.date"
                                  , Field.StringField_ <|
                                        Field.SimpleField
                                            { required = Required.Yes
                                            , label = "Date"
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , tipe = FieldType.Date FieldType.DatePast
                                            , order = 1
                                            , value = "2022-01-01"
                                            , disabled = False
                                            }
                                  )
                                , ( "metadata.email"
                                  , Field.StringField_ <|
                                        Field.SimpleField
                                            { required = Required.Yes
                                            , label = "Email"
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , tipe = FieldType.Email
                                            , order = order
                                            , value = "foo@example.com"
                                            , disabled = False
                                            }
                                  )
                                , ( "metadata.name"
                                  , Field.StringField_ <|
                                        Field.SimpleField
                                            { required = Required.Yes
                                            , label = "Name"
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , tipe = FieldType.Text
                                            , order = 2
                                            , value = "Foo Bar"
                                            , disabled = False
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"metadata":{"date":"2022-01-01","email":"foo@example.com","name":"Foo Bar"}}"""
            ]
        ]
