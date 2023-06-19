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
import Regex
import RemoteData
import Set
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
                                "width": "50%"
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
                                        , hidden = False
                                        , unhiddenBy = Nothing
                                        , rounded = True
                                        , regexValidation = []
                                        }
                                )
                            )
            , Test.test "Simple field decoder with regex" <|
                \_ ->
                    case Regex.fromString "^[a-zA-Z]+$" of
                        Just regex ->
                            let
                                json =
                                    """{
                                        "required": true,
                                        "key": "name",
                                        "label": "Full Name",
                                        "type": "text",
                                        "width": "50%",
                                        "regex_validation": [{ "pattern": "^[a-zA-Z]+$", "message": "Only letters allowed" }]
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
                                                , hidden = False
                                                , unhiddenBy = Nothing
                                                , rounded = True
                                                , regexValidation = [ { pattern = regex, message = "Only letters allowed" } ]
                                                }
                                        )
                                    )

                        Nothing ->
                            Expect.fail "Regex failed to compile"
            , Test.test "Email field decoder with regex" <|
                \_ ->
                    case Regex.fromString "([^t].{7}|.{1}[^e].{6}|.{2}[^s].{5}|.{3}[^t].{4}|.{4}[^.].{3}|.{5}[^c].{2}|.{6}[^o].{1}|.{7}[^m]$|^.{0,7})$" of
                        Just regex ->
                            let
                                json =
                                    """{
                                        "required": true,
                                        "key": "personal_email",
                                        "label": "Personal Email",
                                        "type": "email",
                                        "width": "50%",
                                        "forbidden_domains": [{ "domain": "test.com", "message": "Don't use company email" }]
                                    }"""
                            in
                            Decode.decodeString decoder json
                                |> Expect.equal
                                    (Ok
                                        ( "personal_email"
                                        , Field.StringField_ <|
                                            Field.SimpleField
                                                { tipe = FieldType.Email
                                                , label = "Personal Email"
                                                , required = Required.Yes
                                                , width = Width.HalfSize
                                                , enabledBy = Nothing
                                                , order = order
                                                , value = ""
                                                , disabled = False
                                                , hidden = False
                                                , unhiddenBy = Nothing
                                                , rounded = True
                                                , regexValidation = [ { pattern = regex, message = "Don't use company email" } ]
                                                }
                                        )
                                    )

                        Nothing ->
                            Expect.fail "Regex failed to compile"
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
            , Test.test "Simple field decoder with searchable select type" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": true,
                                "key": "name",
                                "label": "Full Name",
                                "type": "searchable_select",
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
            , Test.test "Simple field decoder with invalid regex record" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": true,
                                "key": "name",
                                "label": "Full Name",
                                "type": "text",
                                "width": "50%",
                                "regex_validation": { "mmmmm": "im hungry" }
                            }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.err
            , Test.test "Simple field decoder with illegal regex" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": true,
                                "key": "name",
                                "label": "Full Name",
                                "type": "text",
                                "width": "50%",
                                "regex_validation": [{ "pattern": "[", "message": "Only letters allowed" }, { "pattern": "^[a-zA-Z]+$", "message": "Valid Regex" }]
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
                                        , hidden = False
                                        , unhiddenBy = Nothing
                                        , rounded = True
                                        , placeholder = ""
                                        , hasSelectablePlaceholder = True
                                        }
                                    )
                                )
                            )
            , Test.test "Searchable select field decoder" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "metadata.pet",
                            "label": "Pet",
                            "type": "searchable_select",
                            "width": "50%",
                            "default": "Dog",
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
                                    (Field.SearchableSelectField
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
                                        , hidden = False
                                        , unhiddenBy = Nothing
                                        , rounded = True
                                        , placeholder = ""
                                        , hasSelectablePlaceholder = True
                                        , showDropdown = False
                                        , searchInput = ""
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
            , Test.test "Searchable select field decoder with missing field" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "metadata.pet",
                            "type": "searchable_select",
                            "label": "Pet",
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
                            "url": "tags"
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
                                        , hidden = False
                                        , unhiddenBy = Nothing
                                        , rounded = True
                                        , placeholder = ""
                                        , hasSelectablePlaceholder = True
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
                                        , hidden = False
                                        , unhiddenBy = Nothing
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
                                        , hidden = False
                                        , unhiddenBy = Nothing
                                        }
                                    )
                                )
                            )
            , Test.test "List string field decoder" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": true,
                                "key": "petNames",
                                "label": "Pet Name",
                                "width": "50%"
                            }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.err
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
            , Test.test "Multi-select field decoder" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "metadata.pet",
                            "label": "Pet",
                            "type": "multi_select",
                            "width": "50%",
                            "options": [
                                { "value": "Dog"
                                , "label": "Doggo" },
                                { "value": "Cat" },
                                { "value": "Parrot" }
                            ],
                            "placeholder": "Pet"
                        }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "metadata.pet"
                                , Field.MultiStringField_
                                    (Field.MultiSelectField
                                        { required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , label = "Pet"
                                        , options =
                                            [ { label = Just "Doggo"
                                              , value = "Dog"
                                              }
                                            , { label = Nothing
                                              , value = "Cat"
                                              }
                                            , { label = Nothing
                                              , value = "Parrot"
                                              }
                                            ]
                                        , placeholder = "Pet"
                                        , value = Set.empty
                                        , order = order
                                        , disabled = False
                                        , hidden = False
                                        , unhiddenBy = Nothing
                                        , rounded = True
                                        , showDropdown = False
                                        }
                                    )
                                )
                            )
            , Test.test "Searchable multi select field decoder" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "metadata.pet",
                            "label": "Pet",
                            "type": "searchable_multi_select",
                            "width": "50%",
                            "options": [
                                { "value": "Dog"
                                , "label": "Doggo" },
                                { "value": "Cat" },
                                { "value": "Parrot" }
                            ],
                            "placeholder": "Pet",
                            "searchableOptions": [
                                { "value": "Tiger" },
                                { "value": "Lion" }
                            ]
                        }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "metadata.pet"
                                , Field.MultiStringField_
                                    (Field.SearchableMultiSelectField
                                        { required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , label = "Pet"
                                        , options =
                                            [ { label = Just "Doggo"
                                              , value = "Dog"
                                              }
                                            , { label = Nothing
                                              , value = "Cat"
                                              }
                                            , { label = Nothing
                                              , value = "Parrot"
                                              }
                                            ]
                                        , placeholder = "Pet"
                                        , value = Set.empty
                                        , order = order
                                        , disabled = False
                                        , hidden = False
                                        , unhiddenBy = Nothing
                                        , rounded = True
                                        , showDropdown = False
                                        , searchInput = ""
                                        , searchableOptions =
                                            [ { label = Nothing
                                              , value = "Tiger"
                                              }
                                            , { label = Nothing
                                              , value = "Lion"
                                              }
                                            ]
                                        }
                                    )
                                )
                            )
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
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , rounded = True
                                            , regexValidation = []
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"name":"Foo Bar"}"""
            , Test.test "Metadata encoding with a list form element" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "name"
                                  , Field.MultiStringField_ <|
                                        Field.TagField
                                            { required = Required.Yes
                                            , label = "Full Name"
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , order = order
                                            , inputBar = "Foo Bar"
                                            , value = Set.empty
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , rounded = True
                                            , placeholder = Nothing
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"name":[]}"""
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
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , rounded = True
                                            , regexValidation = []
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
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , rounded = True
                                            , placeholder = ""
                                            , hasSelectablePlaceholder = True
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"metadata":{"pet":"Dog"}}"""
            , Test.test "Metadata encoding with a metadata searchable select form element" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "metadata.pet"
                                  , Field.StringField_ <|
                                        Field.SearchableSelectField
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
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , rounded = True
                                            , placeholder = ""
                                            , hasSelectablePlaceholder = True
                                            , showDropdown = False
                                            , searchInput = ""
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
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , rounded = True
                                            , placeholder = ""
                                            , hasSelectablePlaceholder = True
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"metadata":{"tag":"foo"}}"""
            , Test.test "Metadata encoding with a metadata multi-select form element" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "metadata.pet"
                                  , Field.MultiStringField_ <|
                                        Field.MultiSelectField
                                            { required = Required.Yes
                                            , label = "Pet"
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , order = order
                                            , value = Set.fromList [ "Dog", "Cat" ]
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
                                            , placeholder = "Pets"
                                            , showDropdown = True
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , rounded = True
                                            }
                                  )
                                ]

                        encodedStr =
                            Encode.encode 0 (encode testDict)
                    in
                    -- set makes no guarantee of order of results
                    ( String.contains "Cat" encodedStr
                    , String.contains "Dog" encodedStr
                    )
                        |> Expect.equal ( True, True )
            , Test.test "Metadata encoding with a metadata multi-select form element with invalid field" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "metadata.pet"
                                  , Field.MultiStringField_ <|
                                        Field.MultiSelectField
                                            { required = Required.Yes
                                            , label = "Pet"
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , order = order
                                            , value = Set.fromList [ "Dog", "Parrot" ]
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
                                            , placeholder = "Pets"
                                            , showDropdown = True
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , rounded = True
                                            }
                                  )
                                ]

                        encodedStr =
                            Encode.encode 0 (encode testDict)
                    in
                    -- set makes no guarantee of order of results
                    ( String.contains "Cat" encodedStr
                    , String.contains "Dog" encodedStr
                    )
                        |> Expect.equal ( False, True )
            , Test.test "Metadata encoding with a metadata searchable-multi-select form element" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "metadata.pet"
                                  , Field.MultiStringField_ <|
                                        Field.SearchableMultiSelectField
                                            { required = Required.Yes
                                            , label = "Pet"
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , order = order
                                            , value = Set.fromList [ "Dog", "Lion" ]
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
                                            , searchableOptions =
                                                [ { label = Nothing
                                                  , value = "Lion"
                                                  }
                                                ]
                                            , searchInput = ""
                                            , placeholder = "Pets"
                                            , showDropdown = True
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , rounded = True
                                            }
                                  )
                                ]

                        encodedStr =
                            Encode.encode 0 (encode testDict)
                    in
                    -- set makes no guarantee of order of results
                    ( String.contains "Cat" encodedStr
                    , String.contains "Dog" encodedStr
                    , String.contains "Lion" encodedStr
                    )
                        |> Expect.equal ( False, True, True )
            , Test.test "Metadata encoding with multiple metadata form element" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "metadata.date"
                                  , Field.StringField_ <|
                                        Field.DateField
                                            { required = Required.Yes
                                            , label = "Date"
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , tipe = FieldType.DatePast
                                            , order = 1
                                            , value = "2022-01-01"
                                            , parsedDate = Nothing
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , rounded = True
                                            }
                                  )
                                , ( "metadata.dateFuture"
                                  , Field.StringField_ <|
                                        Field.DateField
                                            { required = Required.Yes
                                            , label = "Date"
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , tipe = FieldType.DateFuture
                                            , order = 1
                                            , value = "2023-01-01"
                                            , parsedDate = Nothing
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , rounded = True
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
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , rounded = True
                                            , regexValidation = []
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
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , rounded = True
                                            , regexValidation = []
                                            }
                                  )
                                , ( "name"
                                  , Field.MultiStringField_ <|
                                        Field.TagField
                                            { required = Required.Yes
                                            , label = "Full Name"
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , order = order
                                            , inputBar = "Foo Bar"
                                            , value = Set.empty
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , rounded = True
                                            , placeholder = Nothing
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"metadata":{"date":"2022-01-01","dateFuture":"2023-01-01","email":"foo@example.com","name":"Foo Bar"},"name":[]}"""
            ]
        ]
