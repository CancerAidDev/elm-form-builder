module Form.Field.FieldTypeSpec exposing (..)

import Expect
import Form.Field.FieldType as FieldType
import Json.Decode as Decode
import Test exposing (..)


suite : Test
suite =
    describe "Form.Types.FieldType.decoder"
        [ test "Text field type" <|
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
        , test "Email field type" <|
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
        , test "Date field type" <|
            \_ ->
                let
                    json =
                        """
                            "date_birth"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.StringType (FieldType.SimpleType (FieldType.Date FieldType.DateOfBirth))))
        , test "Date past field type" <|
            \_ ->
                let
                    json =
                        """
                            "date_past"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.StringType (FieldType.SimpleType (FieldType.Date FieldType.DatePast))))
        , test "Phone field type" <|
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
        , test "TextArea field type" <|
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
        , test "Select field type" <|
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
        , test "Http select field type" <|
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
        , test "Checkbox field type" <|
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
        , test "Checkbox consent field type" <|
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
        , test "Radio string field type" <|
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
        , test "Radio bool field type" <|
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
        , test "Radio enum field type" <|
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
        , test "Numeric field type" <|
            \_ ->
                let
                    json =
                        """
                            "age"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.equal
                        (Ok (FieldType.NumericType FieldType.Age))
        , test "Non-existing field type" <|
            \_ ->
                let
                    json =
                        """
                            "input"
                        """
                in
                Decode.decodeString FieldType.decoder json
                    |> Expect.err
        ]
