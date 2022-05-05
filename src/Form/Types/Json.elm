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
    = JsonSimpleField JsonSimpleFieldProperties
    | JsonSelectField JsonSelectFieldProperties
    | JsonHttpSelectField JsonHttpSelectFieldProperties
    | JsonRadioField JsonRadioFieldProperties
    | JsonCheckboxField JsonCheckboxFieldProperties
    | JsonRadioBoolField JsonRadioBoolFieldProperties
    | JsonRadioEnumField JsonRadioEnumFieldProperties
    | JsonNumericField JsonNumericFieldProperties


type alias JsonSimpleFieldProperties =
    { required : Bool
    , key : String
    , label : String
    , width : Width.Width
    , enabledBy : Maybe String
    , tipe : FieldType.SimpleFieldType
    }


type alias JsonSelectFieldProperties =
    { required : Bool
    , key : String
    , label : String
    , width : Width.Width
    , enabledBy : Maybe String
    , default : Maybe String
    , options : List Option.Option
    }


type alias JsonHttpSelectFieldProperties =
    { required : Bool
    , key : String
    , label : String
    , width : Width.Width
    , enabledBy : Maybe String
    , default : Maybe String
    , url : String
    }


type alias JsonCheckboxFieldProperties =
    { required : Bool
    , key : String
    , label : String
    , width : Width.Width
    , enabledBy : Maybe String
    , tipe : FieldType.CheckboxFieldType
    }


type alias JsonRadioFieldProperties =
    { required : Bool
    , key : String
    , label : String
    , width : Width.Width
    , enabledBy : Maybe String
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
    , enabledBy : Maybe String
    , default : Maybe String
    , options : List Bool
    , title : String
    }


type alias JsonRadioEnumFieldProperties =
    { required : Bool
    , key : String
    , label : String
    , width : Width.Width
    , enabledBy : Maybe String
    , default : Maybe RadioEnum.Value
    , options : List RadioEnum.Value
    , title : String
    }


type alias JsonNumericFieldProperties =
    { required : Bool
    , key : String
    , label : String
    , width : Width.Width
    , enabledBy : Maybe String
    , title : String
    , tipe : FieldType.NumericFieldType
    }


decoder : Time.Posix -> Int -> Decode.Decoder ( String, Field.Field )
decoder time order =
    Decode.field "type" FieldType.decoder
        |> Decode.andThen
            (\tipe ->
                case tipe of
                    FieldType.StringType (FieldType.SimpleType simpleType) ->
                        Decode.map JsonSimpleField (decoderSimpleJson simpleType)

                    FieldType.StringType FieldType.Select ->
                        Decode.map JsonSelectField decoderSelectJson

                    FieldType.StringType FieldType.HttpSelect ->
                        Decode.map JsonHttpSelectField decoderHttpSelectJson

                    FieldType.StringType FieldType.Radio ->
                        Decode.map JsonRadioField decoderRadioJson

                    FieldType.BoolType (FieldType.CheckboxType checkboxFieldType) ->
                        Decode.map JsonCheckboxField (decoderCheckboxJson checkboxFieldType)

                    FieldType.BoolType FieldType.RadioBool ->
                        Decode.map JsonRadioBoolField decoderRadioBoolJson

                    FieldType.BoolType FieldType.RadioEnum ->
                        Decode.map JsonRadioEnumField decoderRadioEnumJson

                    FieldType.NumericType numericFieldType ->
                        Decode.map JsonNumericField (decoderNumericJson numericFieldType)
            )
        |> Decode.map (toField time order)


toField : Time.Posix -> Int -> JsonField -> ( String, Field.Field )
toField time order field =
    case field of
        JsonSimpleField { tipe, required, key, label, width, enabledBy } ->
            ( key
            , Field.StringField_ <|
                Field.SimpleField
                    { required = required
                    , label = label
                    , width = width
                    , tipe = tipe
                    , enabledBy = enabledBy
                    , order = order
                    , value = FieldType.defaultValue time tipe |> Maybe.withDefault ""
                    }
            )

        JsonCheckboxField { tipe, required, key, label, width, enabledBy } ->
            ( key
            , Field.BoolField_ <|
                Field.CheckboxField
                    { required = required
                    , label = label
                    , width = width
                    , tipe = tipe
                    , enabledBy = enabledBy
                    , order = order
                    , value = False
                    }
            )

        JsonSelectField { required, key, label, width, default, enabledBy, options } ->
            ( key
            , Field.StringField_ <|
                Field.SelectField
                    { required = required
                    , label = label
                    , width = width
                    , enabledBy = enabledBy
                    , order = order
                    , default = default
                    , options = options
                    , value = Maybe.withDefault "" default
                    }
            )

        JsonHttpSelectField { required, key, label, width, default, enabledBy, url } ->
            ( key
            , Field.StringField_ <|
                Field.HttpSelectField
                    { required = required
                    , label = label
                    , width = width
                    , enabledBy = enabledBy
                    , order = order
                    , url = url
                    , default = default
                    , options = RemoteData.NotAsked
                    , value = Maybe.withDefault "" default
                    }
            )

        JsonRadioField { required, key, label, width, default, enabledBy, options, title, direction } ->
            ( key
            , Field.StringField_ <|
                Field.RadioField
                    { required = required
                    , label = label
                    , width = width
                    , enabledBy = enabledBy
                    , order = order
                    , default = default
                    , options = options
                    , value = Maybe.withDefault "" default
                    , title = title
                    , direction = direction
                    }
            )

        JsonNumericField { tipe, required, key, label, width, title, enabledBy } ->
            ( key
            , Field.NumericField_ <|
                Field.NumericField
                    { required = required
                    , label = label
                    , width = width
                    , enabledBy = enabledBy
                    , order = order
                    , tipe = tipe
                    , value = Nothing
                    , title = title
                    }
            )

        JsonRadioEnumField { required, key, label, width, default, enabledBy, options, title } ->
            ( key
            , Field.BoolField_ <|
                Field.RadioEnumField
                    { required = required
                    , label = label
                    , width = width
                    , enabledBy = enabledBy
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


decoderSimpleJson : FieldType.SimpleFieldType -> Decode.Decoder JsonSimpleFieldProperties
decoderSimpleJson tipe =
    Decode.succeed JsonSimpleFieldProperties
        |> DecodePipeline.required "required" Decode.bool
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
        |> DecodePipeline.hardcoded tipe


decoderCheckboxJson : FieldType.CheckboxFieldType -> Decode.Decoder JsonCheckboxFieldProperties
decoderCheckboxJson tipe =
    Decode.succeed JsonCheckboxFieldProperties
        |> DecodePipeline.required "required" Decode.bool
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
        |> DecodePipeline.hardcoded tipe


decoderSelectJson : Decode.Decoder JsonSelectFieldProperties
decoderSelectJson =
    Decode.succeed JsonSelectFieldProperties
        |> DecodePipeline.required "required" Decode.bool
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
        |> DecodePipeline.optional "default" (Decode.maybe Decode.string) Nothing
        |> DecodePipeline.required "options" (Decode.list Option.decoder)


decoderHttpSelectJson : Decode.Decoder JsonHttpSelectFieldProperties
decoderHttpSelectJson =
    Decode.succeed JsonHttpSelectFieldProperties
        |> DecodePipeline.required "required" Decode.bool
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
        |> DecodePipeline.optional "default" (Decode.maybe Decode.string) Nothing
        |> DecodePipeline.required "url" Decode.string


decoderRadioJson : Decode.Decoder JsonRadioFieldProperties
decoderRadioJson =
    Decode.succeed JsonRadioFieldProperties
        |> DecodePipeline.required "required" Decode.bool
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
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
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
        |> DecodePipeline.optional "default" (Decode.maybe Decode.string) Nothing
        |> DecodePipeline.required "options" (Decode.list RadioBool.decoder)
        |> DecodePipeline.required "title" Decode.string


decoderRadioEnumJson : Decode.Decoder JsonRadioEnumFieldProperties
decoderRadioEnumJson =
    Decode.succeed JsonRadioEnumFieldProperties
        |> DecodePipeline.required "required" Decode.bool
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
        |> DecodePipeline.optional "default" (Decode.maybe RadioEnum.decoder) Nothing
        |> DecodePipeline.required "options" (Decode.list RadioEnum.decoder)
        |> DecodePipeline.required "title" Decode.string


decoderNumericJson : FieldType.NumericFieldType -> Decode.Decoder JsonNumericFieldProperties
decoderNumericJson tipe =
    Decode.succeed JsonNumericFieldProperties
        |> DecodePipeline.required "required" Decode.bool
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
        |> DecodePipeline.required "title" Decode.string
        |> DecodePipeline.hardcoded tipe
