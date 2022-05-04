module Form.Types.Json exposing (decoder)

import Form.Types.Direction as Direction
import Form.Types.Field as Field
import Form.Types.FieldType as FieldType
import Form.Types.Option as Option
import Form.Types.RadioBool as RadioBool
import Form.Types.RadioEnum as RadioEnum
import Form.Types.Width as Width
import Json.Decode as Decode
import Json.Decode.Pipeline as DecodePipeline
import RemoteData
import Time


type JsonField
    = JsonSimpleField FieldType.SimpleFieldType JsonCommonProperties
    | JsonSelectField JsonSelectFieldProperties
    | JsonHttpSelectField JsonHttpSelectFieldProperties
    | JsonRadioField JsonRadioFieldProperties
    | JsonCheckboxField FieldType.CheckboxFieldType JsonCommonProperties
    | JsonRadioBoolField JsonRadioBoolFieldProperties
    | JsonRadioEnumField JsonRadioEnumFieldProperties
    | JsonNumericField FieldType.NumericFieldType JsonWithTitleFieldProperties


type alias JsonCommonProperties =
    { required : Bool
    , key : String
    , label : String
    , width : Width.Width
    }


type alias JsonSelectFieldProperties =
    { required : Bool
    , key : String
    , label : String
    , width : Width.Width
    , default : Maybe String
    , options : List Option.Option
    }


type alias JsonHttpSelectFieldProperties =
    { required : Bool
    , key : String
    , label : String
    , width : Width.Width
    , default : Maybe String
    , url : String
    }


type alias JsonRadioFieldProperties =
    { required : Bool
    , key : String
    , label : String
    , width : Width.Width
    , default : Maybe String
    , options : List Option.Option
    , title : String
    , direction : Direction.Direction
    }


type alias JsonRadioBoolFieldProperties =
    { required : Bool
    , key : String
    , label : String
    , width : Width.Width
    , default : Maybe String
    , options : List Bool
    , title : String
    , enabledBy : Maybe String
    }


type alias JsonRadioEnumFieldProperties =
    { required : Bool
    , key : String
    , label : String
    , width : Width.Width
    , default : Maybe RadioEnum.Value
    , options : List RadioEnum.Value
    , title : String
    }


type alias JsonWithTitleFieldProperties =
    { required : Bool
    , key : String
    , label : String
    , width : Width.Width
    , title : String
    }


decoder : Time.Posix -> Int -> Decode.Decoder ( String, Field.Field )
decoder time order =
    Decode.field "type" FieldType.decoder
        |> Decode.andThen
            (\tipe ->
                case tipe of
                    FieldType.StringType (FieldType.SimpleType simpleType) ->
                        Decode.map (JsonSimpleField simpleType) decoderCommonJson

                    FieldType.StringType FieldType.Select ->
                        Decode.map JsonSelectField decoderSelectJson

                    FieldType.StringType FieldType.HttpSelect ->
                        Decode.map JsonHttpSelectField decoderHttpSelectJson

                    FieldType.StringType FieldType.Radio ->
                        Decode.map JsonRadioField decoderRadioJson

                    FieldType.BoolType (FieldType.CheckboxType FieldType.Checkbox) ->
                        Decode.map (JsonCheckboxField FieldType.Checkbox) decoderCommonJson

                    FieldType.BoolType (FieldType.CheckboxType FieldType.CheckboxConsent) ->
                        Decode.map (JsonCheckboxField FieldType.CheckboxConsent) decoderCommonJson

                    FieldType.BoolType FieldType.RadioBool ->
                        Decode.map JsonRadioBoolField decoderRadioBoolJson

                    FieldType.BoolType FieldType.RadioEnum ->
                        Decode.map JsonRadioEnumField decoderRadioEnumJson

                    FieldType.NumericType numericFieldType ->
                        Decode.map (JsonNumericField numericFieldType) decoderNumericJson
            )
        |> Decode.map (toField time order)


toField : Time.Posix -> Int -> JsonField -> ( String, Field.Field )
toField time order field =
    case field of
        JsonSimpleField tipe { required, key, label, width } ->
            ( key
            , Field.StringField_ <|
                Field.SimpleField
                    { required = required
                    , label = label
                    , width = width
                    , tipe = tipe
                    , order = order
                    , value = FieldType.defaultValue time tipe |> Maybe.withDefault ""
                    }
            )

        JsonCheckboxField tipe { required, key, label, width } ->
            ( key
            , Field.BoolField_ <|
                Field.CheckboxField
                    { required = required
                    , label = label
                    , width = width
                    , tipe = tipe
                    , order = order
                    , value = False
                    }
            )

        JsonSelectField { required, key, label, width, default, options } ->
            ( key
            , Field.StringField_ <|
                Field.SelectField
                    { required = required
                    , label = label
                    , width = width
                    , order = order
                    , default = default
                    , options = options
                    , value = Maybe.withDefault "" default
                    }
            )

        JsonHttpSelectField { required, key, label, width, default, url } ->
            ( key
            , Field.StringField_ <|
                Field.HttpSelectField
                    { required = required
                    , label = label
                    , width = width
                    , order = order
                    , url = url
                    , default = default
                    , options = RemoteData.NotAsked
                    , value = Maybe.withDefault "" default
                    }
            )

        JsonRadioField { required, key, label, width, default, options, title, direction } ->
            ( key
            , Field.StringField_ <|
                Field.RadioField
                    { required = required
                    , label = label
                    , width = width
                    , order = order
                    , default = default
                    , options = options
                    , value = Maybe.withDefault "" default
                    , title = title
                    , direction = direction
                    }
            )

        JsonNumericField tipe { required, key, label, width, title } ->
            ( key
            , Field.NumericField_ <|
                Field.NumericField
                    { required = required
                    , label = label
                    , width = width
                    , order = order
                    , tipe = tipe
                    , value = Nothing
                    , title = title
                    }
            )

        JsonRadioEnumField { required, key, label, width, default, options, title } ->
            ( key
            , Field.BoolField_ <|
                Field.RadioEnumField
                    { required = required
                    , label = label
                    , width = width
                    , order = order
                    , default = default
                    , options = options
                    , value = default
                    , title = title
                    }
            )

        JsonRadioBoolField { required, key, label, width, default, options, title, enabledBy } ->
            ( key
            , Field.BoolField_ <|
                Field.RadioBoolField
                    { required = required
                    , label = label
                    , width = width
                    , order = order
                    , default = default
                    , options = options
                    , value = default |> Maybe.andThen RadioBool.fromString
                    , title = title
                    , enabledBy = enabledBy
                    }
            )


decoderCommonJson : Decode.Decoder JsonCommonProperties
decoderCommonJson =
    Decode.succeed JsonCommonProperties
        |> DecodePipeline.required "required" Decode.bool
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder


decoderSelectJson : Decode.Decoder JsonSelectFieldProperties
decoderSelectJson =
    Decode.succeed JsonSelectFieldProperties
        |> DecodePipeline.required "required" Decode.bool
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "default" (Decode.maybe Decode.string) Nothing
        |> DecodePipeline.required "options" (Decode.list Option.decoder)


decoderHttpSelectJson : Decode.Decoder JsonHttpSelectFieldProperties
decoderHttpSelectJson =
    Decode.succeed JsonHttpSelectFieldProperties
        |> DecodePipeline.required "required" Decode.bool
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "default" (Decode.maybe Decode.string) Nothing
        |> DecodePipeline.required "url" Decode.string


decoderRadioJson : Decode.Decoder JsonRadioFieldProperties
decoderRadioJson =
    Decode.succeed JsonRadioFieldProperties
        |> DecodePipeline.required "required" Decode.bool
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "default" (Decode.maybe Decode.string) Nothing
        |> DecodePipeline.required "options" (Decode.list Option.decoder)
        |> DecodePipeline.required "title" Decode.string
        |> DecodePipeline.optional "direction" Direction.decoder Direction.Column


decoderRadioBoolJson : Decode.Decoder JsonRadioBoolFieldProperties
decoderRadioBoolJson =
    Decode.succeed JsonRadioBoolFieldProperties
        |> DecodePipeline.required "required" Decode.bool
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "default" (Decode.maybe Decode.string) Nothing
        |> DecodePipeline.required "options" (Decode.list RadioBool.decoder)
        |> DecodePipeline.required "title" Decode.string
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing


decoderRadioEnumJson : Decode.Decoder JsonRadioEnumFieldProperties
decoderRadioEnumJson =
    Decode.succeed JsonRadioEnumFieldProperties
        |> DecodePipeline.required "required" Decode.bool
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "default" (Decode.maybe RadioEnum.decoder) Nothing
        |> DecodePipeline.required "options" (Decode.list RadioEnum.decoder)
        |> DecodePipeline.required "title" Decode.string


decoderNumericJson : Decode.Decoder JsonWithTitleFieldProperties
decoderNumericJson =
    Decode.succeed JsonWithTitleFieldProperties
        |> DecodePipeline.required "required" Decode.bool
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.required "title" Decode.string
