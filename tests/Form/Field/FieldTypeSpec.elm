module Form.Field.FieldTypeSpec exposing (suite)

import Expect
import Form.Field.FieldType as FieldType
import Json.Decode as Decode
import Test


suite : Test.Test
suite =
    Test.describe "Form.Field.FieldType.decoder"
        [ Test.test "Text field type" <|
            \_ ->
                let
                    json =
                        """
                            "text"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.StringType (FieldType.SimpleType FieldType.Text)))
        , Test.test "Email field type" <|
            \_ ->
                let
                    json =
                        """
                            "email"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.StringType (FieldType.SimpleType FieldType.Email)))
        , Test.test "Date field type" <|
            \_ ->
                let
                    json =
                        """
                            "date_birth"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.StringType (FieldType.DateType FieldType.dateOfBirth)))
        , Test.test "Date past field type" <|
            \_ ->
                let
                    json =
                        """
                            "date_past"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.StringType (FieldType.DateType FieldType.datePast)))
        , Test.test "Date future field type" <|
            \_ ->
                let
                    json =
                        """
                            "date_future"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.StringType (FieldType.DateType FieldType.dateFuture)))
        , Test.test "Phone field type" <|
            \_ ->
                let
                    json =
                        """
                            "phone"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.StringType (FieldType.SimpleType FieldType.Phone)))
        , Test.test "URL field type" <|
            \_ ->
                let
                    json =
                        """
                            "url"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.StringType (FieldType.SimpleType FieldType.Url)))
        , Test.test "TextArea field type" <|
            \_ ->
                let
                    json =
                        """
                            "textarea"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.StringType (FieldType.SimpleType FieldType.TextArea)))
        , Test.test "Select field type" <|
            \_ ->
                let
                    json =
                        """
                            "select"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.StringType FieldType.Select))
        , Test.test "SearchableSelect field type" <|
            \_ ->
                let
                    json =
                        """
                            "searchable_select"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.StringType FieldType.SearchableSelect))
        , Test.test "Http select field type" <|
            \_ ->
                let
                    json =
                        """
                            "httpSelect"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.StringType FieldType.HttpSelect))
        , Test.test "Checkbox field type" <|
            \_ ->
                let
                    json =
                        """
                            "checkbox"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.BoolType (FieldType.CheckboxType FieldType.Checkbox)))
        , Test.test "Checkbox consent field type" <|
            \_ ->
                let
                    json =
                        """
                            "checkbox_consent"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.BoolType (FieldType.CheckboxType FieldType.CheckboxConsent)))
        , Test.test "Radio string field type" <|
            \_ ->
                let
                    json =
                        """
                            "radio"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.StringType FieldType.Radio))
        , Test.test "Radio bool field type" <|
            \_ ->
                let
                    json =
                        """
                            "radio_bool"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.BoolType FieldType.RadioBool))
        , Test.test "Radio enum field type" <|
            \_ ->
                let
                    json =
                        """
                            "radio_enum"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.BoolType FieldType.RadioEnum))
        , Test.test "Non-existing field type" <|
            \_ ->
                let
                    json =
                        """
                            "input"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.err
        , Test.test "Multi-select field type" <|
            \_ ->
                let
                    json =
                        """
                            "multi_select"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.MultiStringType FieldType.MultiSelect))
        , Test.test "Searchable multi-select field type" <|
            \_ ->
                let
                    json =
                        """
                            "searchable_multi_select"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.MultiStringType FieldType.SearchableMultiSelect))
        , Test.test "Multi http select field type" <|
            \_ ->
                let
                    json =
                        """
                            "multi_http_select"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.MultiStringType FieldType.MultiHttpSelect))
        , Test.test "Tags Field Type" <|
            \_ ->
                let
                    json =
                        """ 
                            "tags"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.MultiStringType FieldType.Tags))
        , Test.test "Integer Field Type" <|
            \_ ->
                let
                    json =
                        """ 
                            "integer"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.IntegerType FieldType.defaultInt))
        ]
