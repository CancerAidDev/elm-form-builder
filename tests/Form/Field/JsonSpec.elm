module Form.Field.JsonSpec exposing (suite)

import Dict
import Expect
import Form.Field as Field
import Form.Field.DecoderForOptions as DecoderForOptions
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
                                        , labelExtraContent = Nothing
                                        , required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , order = order
                                        , value = ""
                                        , disabled = False
                                        , hidden = False
                                        , unhiddenBy = Nothing
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
                                                , labelExtraContent = Nothing
                                                , required = Required.Yes
                                                , width = Width.HalfSize
                                                , enabledBy = Nothing
                                                , order = order
                                                , value = ""
                                                , disabled = False
                                                , hidden = False
                                                , unhiddenBy = Nothing
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
                                                , labelExtraContent = Nothing
                                                , required = Required.Yes
                                                , width = Width.HalfSize
                                                , enabledBy = Nothing
                                                , order = order
                                                , value = ""
                                                , disabled = False
                                                , hidden = False
                                                , unhiddenBy = Nothing
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
            , Test.test "Simple field decoder with color type" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": true,
                                "key": "favourite_colour",
                                "label": "Favourite Colour",
                                "type": "color",
                                "width": "50%"
                            }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "favourite_colour"
                                , Field.StringField_ <|
                                    Field.ColorField
                                        { label = "Favourite Colour"
                                        , labelExtraContent = Nothing
                                        , required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , order = order
                                        , value = "#000000"
                                        , disabled = False
                                        , hidden = False
                                        , unhiddenBy = Nothing
                                        , showHexValue = False
                                        }
                                )
                            )
            , Test.test "Color field decoder with value and show_hex" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": true,
                                "key": "favourite_colour",
                                "label": "Favourite Colour",
                                "type": "color",
                                "width": "50%",
                                "value": "#3273dc",
                                "show_hex": true
                            }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "favourite_colour"
                                , Field.StringField_ <|
                                    Field.ColorField
                                        { label = "Favourite Colour"
                                        , labelExtraContent = Nothing
                                        , required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , order = order
                                        , value = "#3273dc"
                                        , disabled = False
                                        , hidden = False
                                        , unhiddenBy = Nothing
                                        , showHexValue = True
                                        }
                                )
                            )
            , Test.test "Simple field decoder with incorrect simple type" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": true,
                                "key": "name",
                                "label": "Full Name",
                                "type": "not_a_real_type",
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
                            "key": "customDict1.pet",
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
                                ( "customDict1.pet"
                                , Field.StringField_
                                    (Field.SelectField
                                        { required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , label = "Pet"
                                        , labelExtraContent = Nothing
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
                                        , placeholder = ""
                                        , hasSelectablePlaceholder = True
                                        , nullableOptionLabel = Nothing
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
                            "key": "customDict1.pet",
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
                                ( "customDict1.pet"
                                , Field.StringField_
                                    (Field.SearchableSelectField
                                        { required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , label = "Pet"
                                        , labelExtraContent = Nothing
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
                                        , placeholder = ""
                                        , hasSelectablePlaceholder = True
                                        , showDropdown = False
                                        , searchInput = ""
                                        , nullableOptionLabel = Nothing
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
                            "key": "customDict1.pet",
                            "label": "Pet",
                            "type": "httpSelect",
                            "width": "50%",
                            "options": [
                                { "value": "Dog" },
                                { "value": "Cat" },
                                { "value": "Parrot" }
                            ],
                            "decoderForOptions": {
                                "value": "uuid",
                                "label": "name"
                            }
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
                            "key": "customDict1.pet",
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
                            "key": "customDict1.pet",
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
                            "key": "customDict1.tag",
                            "label": "Tag",
                            "labelExtraContent": {
                                "content": "customDict1"
                            },
                            "type": "httpSelect",
                            "width": "50%",
                            "url": "tags",
                            "decoderForOptions": {
                                "value": "uuid",
                                "label": "name"
                            }
                        }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "customDict1.tag"
                                , Field.StringField_
                                    (Field.HttpSelectField
                                        { required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , default = Nothing
                                        , label = "Tag"
                                        , labelExtraContent = Just { content = "customDict1", classes = Nothing }
                                        , url = "tags"
                                        , options = RemoteData.NotAsked
                                        , value = ""
                                        , order = order
                                        , disabled = False
                                        , hidden = False
                                        , unhiddenBy = Nothing
                                        , placeholder = ""
                                        , hasSelectablePlaceholder = True
                                        , decoderForOptions = DecoderForOptions.default
                                        , nullableOptionLabel = Nothing
                                        }
                                    )
                                )
                            )
            , Test.test "Http Select field decoder - no decoder for options" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "customDict1.tag",
                            "label": "Tag",
                            "type": "httpSelect",
                            "width": "50%",
                            "url": "tags"
                        }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.err
            , Test.test "Http Select field decoder with select type" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "customDict1.tag",
                            "label": "Tag",
                            "type": "select",
                            "width": "50%",
                            "url": "tags",
                            "decoderForOptions": {
                                "value": "uuid",
                                "label": "name"
                            }
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
                            "key": "customDict1.tag",
                            "label": "Tag",
                            "type": "select",
                            "width": "50%",
                            "decoderForOptions": {
                                "value": "uuid",
                                "label": "name"
                            }
                        }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.err
            , Test.test "Http Searchable Select field decoder" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "customDict1.httpSearchableSelect",
                            "label": "Http Searchable Select",
                            "type": "http_searchable_select",
                            "width": "50%",
                            "url": "httpSearchableSelect",
                            "decoderForOptions": {
                                "value": "uuid",
                                "label": "name"
                            }
                        }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "customDict1.httpSearchableSelect"
                                , Field.StringField_
                                    (Field.HttpSearchableSelectField
                                        { required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , default = Nothing
                                        , label = "Http Searchable Select"
                                        , labelExtraContent = Nothing
                                        , url = "httpSearchableSelect"
                                        , options = RemoteData.NotAsked
                                        , value = ""
                                        , order = order
                                        , disabled = False
                                        , hidden = False
                                        , unhiddenBy = Nothing
                                        , placeholder = ""
                                        , hasSelectablePlaceholder = True
                                        , showDropdown = False
                                        , searchInput = ""
                                        , decoderForOptions = DecoderForOptions.default
                                        , nullableOptionLabel = Nothing
                                        }
                                    )
                                )
                            )
            , Test.test "Http Searchable Select field decoder with incorrect field" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "customDict1.httpSearchableSelect",
                            "label": "Http Searchable Select",
                            "type": "http_searchable_select",
                            "width": "50%",
                            "options": [
                                { "value": "Dog" },
                                { "value": "Cat" },
                                { "value": "Parrot" }
                            ],
                            "decoderForOptions": {
                                "value": "uuid",
                                "label": "name"
                            }
                        }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.err
            , Test.test "Http Searchable Select field decoder with missing field" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "customDict1.httpSearchableSelect",
                            "label": "Http Searchable Select",
                            "type": "http_searchable_select",
                            "width": "50%",
                            "decoderForOptions": {
                                "value": "uuid",
                                "label": "name"
                            }
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
                                        , labelExtraContent = Nothing
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
                                        , labelExtraContent = Nothing
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
                            "key": "customDict1.pet",
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
                                ( "customDict1.pet"
                                , Field.MultiStringField_
                                    (Field.MultiSelectField
                                        { required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , label = "Pet"
                                        , labelExtraContent = Nothing
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
                            "key": "customDict1.pet",
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
                                ( "customDict1.pet"
                                , Field.MultiStringField_
                                    (Field.SearchableMultiSelectField
                                        { required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , label = "Pet"
                                        , labelExtraContent = Nothing
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
            , Test.test "Age field decoder uses default min/max" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": true,
                                "key": "age",
                                "label": "Age",
                                "type": "age",
                                "width": "100%"
                            }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "age"
                                , Field.IntegerField_ <|
                                    Field.SimpleIntegerField
                                        { required = Required.Yes
                                        , label = "Age"
                                        , labelExtraContent = Nothing
                                        , width = Width.FullSize
                                        , enabledBy = Nothing
                                        , order = order
                                        , value = Nothing
                                        , disabled = False
                                        , hidden = False
                                        , unhiddenBy = Nothing
                                        , min = Just 18
                                        , max = Just 99
                                        }
                                )
                            )
            , Test.test "Age field decoder overrides default min/max" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": false,
                                "key": "age",
                                "label": "Age",
                                "type": "age",
                                "width": "100%",
                                "min": 0,
                                "max": 100
                            }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "age"
                                , Field.IntegerField_ <|
                                    Field.SimpleIntegerField
                                        { required = Required.No
                                        , label = "Age"
                                        , labelExtraContent = Nothing
                                        , width = Width.FullSize
                                        , enabledBy = Nothing
                                        , order = order
                                        , value = Nothing
                                        , disabled = False
                                        , hidden = False
                                        , unhiddenBy = Nothing
                                        , min = Just 0
                                        , max = Just 100
                                        }
                                )
                            )
            , Test.test "Linear scale field decoder" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": true,
                                "key": "linearScale",
                                "label": "Linear Scale",
                                "type": "linear_scale",
                                "width": "100%",
                                "min": 1,
                                "max": 5
                            }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "linearScale"
                                , Field.IntegerField_ <|
                                    Field.LinearScaleField
                                        { required = Required.Yes
                                        , label = "Linear Scale"
                                        , labelExtraContent = Nothing
                                        , width = Width.FullSize
                                        , enabledBy = Nothing
                                        , order = order
                                        , value = Nothing
                                        , disabled = False
                                        , hidden = False
                                        , unhiddenBy = Nothing
                                        , min = 1
                                        , max = 5
                                        , leftLabel = Nothing
                                        , rightLabel = Nothing
                                        }
                                )
                            )
            , Test.test "Linear scale field decoder with labels" <|
                \_ ->
                    let
                        json =
                            """{
                                "required": false,
                                "key": "difficulty",
                                "label": "Difficulty",
                                "type": "linear_scale",
                                "width": "100%",
                                "min": 1,
                                "max": 10,
                                "leftLabel": "Easy",
                                "rightLabel": "Hard"
                            }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "difficulty"
                                , Field.IntegerField_ <|
                                    Field.LinearScaleField
                                        { required = Required.No
                                        , label = "Difficulty"
                                        , labelExtraContent = Nothing
                                        , width = Width.FullSize
                                        , enabledBy = Nothing
                                        , order = order
                                        , value = Nothing
                                        , disabled = False
                                        , hidden = False
                                        , unhiddenBy = Nothing
                                        , min = 1
                                        , max = 10
                                        , leftLabel = Just "Easy"
                                        , rightLabel = Just "Hard"
                                        }
                                )
                            )
            ]
        , Test.describe "Encoding Fields"
            [ Test.test "Dictonary field encoding without any dictionary field form elements" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "name"
                                  , Field.StringField_ <|
                                        Field.SimpleField
                                            { required = Required.Yes
                                            , label = "Full Name"
                                            , labelExtraContent = Nothing
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , tipe = FieldType.Text
                                            , order = order
                                            , value = "Foo Bar"
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , regexValidation = []
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"name":"Foo Bar"}"""
            , Test.test "Dictonary field encoding with a list form element" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "name"
                                  , Field.MultiStringField_ <|
                                        Field.TagField
                                            { required = Required.Yes
                                            , label = "Full Name"
                                            , labelExtraContent = Nothing
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , order = order
                                            , inputBar = "Foo Bar"
                                            , value = Set.empty
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , placeholder = Nothing
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"name":[]}"""
            , Test.test "Dictonary field encoding with a dictionary key for a field form element" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "customDict1.tag"
                                  , Field.StringField_ <|
                                        Field.SimpleField
                                            { required = Required.Yes
                                            , label = "Tag"
                                            , labelExtraContent = Nothing
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , tipe = FieldType.Text
                                            , order = order
                                            , value = "bar"
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , regexValidation = []
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"customDict1":{"tag":"bar"}}"""
            , Test.test "Dictonary field encoding with a dictionary key for a select form element" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "customDict1.pet"
                                  , Field.StringField_ <|
                                        Field.SelectField
                                            { required = Required.Yes
                                            , label = "Pet"
                                            , labelExtraContent = Nothing
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
                                            , placeholder = ""
                                            , hasSelectablePlaceholder = True
                                            , nullableOptionLabel = Nothing
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"customDict1":{"pet":"Dog"}}"""
            , Test.test "Dictonary field encoding with a dictionary key for a searchable select form element" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "customDict1.pet"
                                  , Field.StringField_ <|
                                        Field.SearchableSelectField
                                            { required = Required.Yes
                                            , label = "Pet"
                                            , labelExtraContent = Nothing
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
                                            , placeholder = ""
                                            , hasSelectablePlaceholder = True
                                            , showDropdown = False
                                            , searchInput = ""
                                            , nullableOptionLabel = Nothing
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"customDict1":{"pet":"Dog"}}"""
            , Test.test "Dictonary field encoding with a dictionary key for a httpSelect form element" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "customDict1.tag"
                                  , Field.StringField_ <|
                                        Field.HttpSelectField
                                            { required = Required.Yes
                                            , label = "Tag"
                                            , labelExtraContent = Nothing
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
                                            , placeholder = ""
                                            , hasSelectablePlaceholder = True
                                            , decoderForOptions = DecoderForOptions.default
                                            , nullableOptionLabel = Nothing
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"customDict1":{"tag":"foo"}}"""
            , Test.test "Dictionary field encoding with a dictionary key for a multi-select form element" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "customDict1.pet"
                                  , Field.MultiStringField_ <|
                                        Field.MultiSelectField
                                            { required = Required.Yes
                                            , label = "Pet"
                                            , labelExtraContent = Nothing
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
            , Test.test "Dictionary field encoding with a dictionary key for a multi-select form element with invalid field" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "customDict1.pet"
                                  , Field.MultiStringField_ <|
                                        Field.MultiSelectField
                                            { required = Required.Yes
                                            , label = "Pet"
                                            , labelExtraContent = Nothing
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
            , Test.test "Dictionary field encoding with a dictionary key for a searchable-multi-select form element" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "customDict1.pet"
                                  , Field.MultiStringField_ <|
                                        Field.SearchableMultiSelectField
                                            { required = Required.Yes
                                            , label = "Pet"
                                            , labelExtraContent = Nothing
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
            , Test.test "Dictionary field encoding with multiple dictionary keys for form elements" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "customDict1.date"
                                  , Field.StringField_ <|
                                        Field.DateField
                                            { required = Required.Yes
                                            , label = "Date"
                                            , labelExtraContent = Nothing
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , tipe = FieldType.dateDefault
                                            , order = 1
                                            , value = "2022-01-01"
                                            , parsedDate = Nothing
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            }
                                  )
                                , ( "customDict1.dateFuture"
                                  , Field.StringField_ <|
                                        Field.DateField
                                            { required = Required.Yes
                                            , label = "Date"
                                            , labelExtraContent = Nothing
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , tipe = FieldType.dateFuture
                                            , order = 1
                                            , value = "2023-01-01"
                                            , parsedDate = Nothing
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            }
                                  )
                                , ( "customDict1.email"
                                  , Field.StringField_ <|
                                        Field.SimpleField
                                            { required = Required.Yes
                                            , label = "Email"
                                            , labelExtraContent = Nothing
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , tipe = FieldType.Email
                                            , order = order
                                            , value = "foo@example.com"
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , regexValidation = []
                                            }
                                  )
                                , ( "customDict1.name"
                                  , Field.StringField_ <|
                                        Field.SimpleField
                                            { required = Required.Yes
                                            , label = "Name"
                                            , labelExtraContent = Nothing
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , tipe = FieldType.Text
                                            , order = 2
                                            , value = "Foo Bar"
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , regexValidation = []
                                            }
                                  )
                                , ( "name"
                                  , Field.MultiStringField_ <|
                                        Field.TagField
                                            { required = Required.Yes
                                            , label = "Full Name"
                                            , labelExtraContent = Nothing
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , order = order
                                            , inputBar = "Foo Bar"
                                            , value = Set.empty
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , placeholder = Nothing
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"customDict1":{"date":"2022-01-01","dateFuture":"2023-01-01","email":"foo@example.com","name":"Foo Bar"},"name":[]}"""
            , Test.test "Dictionary field encoding with multiple unique dictionary keys" <|
                \_ ->
                    let
                        testDict =
                            Dict.fromList
                                [ ( "customDict1.date"
                                  , Field.StringField_ <|
                                        Field.DateField
                                            { required = Required.Yes
                                            , label = "Date"
                                            , labelExtraContent = Nothing
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , tipe = FieldType.dateDefault
                                            , order = 1
                                            , value = "2022-01-01"
                                            , parsedDate = Nothing
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            }
                                  )
                                , ( "customDict2.email"
                                  , Field.StringField_ <|
                                        Field.SimpleField
                                            { required = Required.Yes
                                            , label = "Email"
                                            , labelExtraContent = Nothing
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , tipe = FieldType.Email
                                            , order = order
                                            , value = "foo@example.com"
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , regexValidation = []
                                            }
                                  )
                                , ( "customDict1.name"
                                  , Field.StringField_ <|
                                        Field.SimpleField
                                            { required = Required.Yes
                                            , label = "Name"
                                            , labelExtraContent = Nothing
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , tipe = FieldType.Text
                                            , order = 2
                                            , value = "Foo Bar"
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , regexValidation = []
                                            }
                                  )
                                , ( "customDict2.customField"
                                  , Field.StringField_ <|
                                        Field.SimpleField
                                            { required = Required.Yes
                                            , label = "Custom Field"
                                            , labelExtraContent = Nothing
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , tipe = FieldType.Text
                                            , order = 2
                                            , value = "Foo Bar"
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , regexValidation = []
                                            }
                                  )
                                , ( "normalField"
                                  , Field.MultiStringField_ <|
                                        Field.TagField
                                            { required = Required.Yes
                                            , label = "Field"
                                            , labelExtraContent = Nothing
                                            , width = Width.HalfSize
                                            , enabledBy = Nothing
                                            , order = order
                                            , inputBar = "Foo Bar"
                                            , value = Set.empty
                                            , disabled = False
                                            , hidden = False
                                            , unhiddenBy = Nothing
                                            , placeholder = Nothing
                                            }
                                  )
                                ]
                    in
                    Encode.encode 0 (encode testDict)
                        |> Expect.equal
                            """{"customDict1":{"date":"2022-01-01","name":"Foo Bar"},"customDict2":{"customField":"Foo Bar","email":"foo@example.com"},"normalField":[]}"""
            , Test.test "Select field decoder with nullable option" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "customDict1.pet",
                            "label": "Pet",
                            "type": "select",
                            "width": "50%",
                            "default": "Dog",
                            "options": [
                                { "value": "Dog" },
                                { "value": "Cat" },
                                { "value": "Parrot" }
                            ],
                            "nullableOptionLabel": "Other"
                        }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "customDict1.pet"
                                , Field.StringField_
                                    (Field.SelectField
                                        { required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , label = "Pet"
                                        , labelExtraContent = Nothing
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
                                        , placeholder = ""
                                        , hasSelectablePlaceholder = True
                                        , nullableOptionLabel = Just "Other"
                                        }
                                    )
                                )
                            )
            , Test.test "Searchable select field decoder with nullable option" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "customDict1.pet",
                            "label": "Pet",
                            "type": "searchable_select",
                            "width": "50%",
                            "default": "Dog",
                            "options": [
                                { "value": "Dog" },
                                { "value": "Cat" },
                                { "value": "Parrot" }
                            ],
                            "nullableOptionLabel": "Other"
                        }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "customDict1.pet"
                                , Field.StringField_
                                    (Field.SearchableSelectField
                                        { required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , label = "Pet"
                                        , labelExtraContent = Nothing
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
                                        , placeholder = ""
                                        , hasSelectablePlaceholder = True
                                        , showDropdown = False
                                        , searchInput = ""
                                        , nullableOptionLabel = Just "Other"
                                        }
                                    )
                                )
                            )
            , Test.test "Http Select field decoder with nullable option" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "customDict1.tag",
                            "label": "Tag",
                            "type": "httpSelect",
                            "width": "50%",
                            "url": "tags",
                            "decoderForOptions": {
                                "value": "uuid",
                                "label": "name"
                            },
                            "nullableOptionLabel": "Other"
                        }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "customDict1.tag"
                                , Field.StringField_
                                    (Field.HttpSelectField
                                        { required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , default = Nothing
                                        , label = "Tag"
                                        , labelExtraContent = Nothing
                                        , url = "tags"
                                        , options = RemoteData.NotAsked
                                        , value = ""
                                        , order = order
                                        , disabled = False
                                        , hidden = False
                                        , unhiddenBy = Nothing
                                        , placeholder = ""
                                        , hasSelectablePlaceholder = True
                                        , decoderForOptions = DecoderForOptions.default
                                        , nullableOptionLabel = Just "Other"
                                        }
                                    )
                                )
                            )
            , Test.test "Http Searchable Select field decoder with nullable option" <|
                \_ ->
                    let
                        json =
                            """{
                            "required": true,
                            "key": "customDict1.httpSearchableSelect",
                            "label": "Http Searchable Select",
                            "type": "http_searchable_select",
                            "width": "50%",
                            "url": "httpSearchableSelect",
                            "decoderForOptions": {
                                "value": "uuid",
                                "label": "name"
                            },
                            "nullableOptionLabel": "Other"
                        }"""
                    in
                    Decode.decodeString decoder json
                        |> Expect.equal
                            (Ok
                                ( "customDict1.httpSearchableSelect"
                                , Field.StringField_
                                    (Field.HttpSearchableSelectField
                                        { required = Required.Yes
                                        , width = Width.HalfSize
                                        , enabledBy = Nothing
                                        , default = Nothing
                                        , label = "Http Searchable Select"
                                        , labelExtraContent = Nothing
                                        , url = "httpSearchableSelect"
                                        , options = RemoteData.NotAsked
                                        , value = ""
                                        , order = order
                                        , disabled = False
                                        , hidden = False
                                        , unhiddenBy = Nothing
                                        , placeholder = ""
                                        , hasSelectablePlaceholder = True
                                        , showDropdown = False
                                        , searchInput = ""
                                        , decoderForOptions = DecoderForOptions.default
                                        , nullableOptionLabel = Just "Other"
                                        }
                                    )
                                )
                            )
            ]
        ]
