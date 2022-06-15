module Form.Field.Json exposing (decoder)

{-| Decode Field from Json


# Json

@docs decoder

-}

import Form.Field as Field
import Form.Field.Direction as Direction
import Form.Field.FieldType as FieldType
import Form.Field.Option as Option
import Form.Field.RadioEnum as RadioEnum
import Form.Field.Required as Required
import Form.Field.Width as Width
import Json.Decode as Decode
import Json.Decode.Pipeline as DecodePipeline
import RemoteData
import Set
import Time


type JsonField
    = JsonSimpleField JsonSimpleFieldProperties
    | JsonSelectField JsonSelectFieldProperties
    | JsonHttpSelectField JsonHttpSelectFieldProperties
    | JsonMultiSelectField JsonMultiSelectFieldProperties
    | JsonMultiHttpSelectField JsonMultiHttpSelectFieldProperties
    | JsonRadioField JsonRadioFieldProperties
    | JsonCheckboxField JsonCheckboxFieldProperties
    | JsonRadioBoolField JsonRadioBoolFieldProperties
    | JsonRadioEnumField JsonRadioEnumFieldProperties
    | JsonAgeField JsonAgeFieldProperties


type alias JsonSimpleFieldProperties =
    { required : Required.IsRequired
    , key : String
    , label : String
    , width : Width.Width
    , enabledBy : Maybe String
    , tipe : FieldType.SimpleFieldType
    , disabled : Maybe Bool
    }


type alias JsonSelectFieldProperties =
    { required : Required.IsRequired
    , key : String
    , label : String
    , width : Width.Width
    , enabledBy : Maybe String
    , default : Maybe String
    , options : List Option.Option
    , disabled : Maybe Bool
    }


type alias JsonHttpSelectFieldProperties =
    { required : Required.IsRequired
    , key : String
    , label : String
    , width : Width.Width
    , enabledBy : Maybe String
    , default : Maybe String
    , url : String
    , disabled : Maybe Bool
    }


type alias JsonMultiSelectFieldProperties =
    { required : Required.IsRequired
    , key : String
    , label : String
    , width : Width.Width
    , enabledBy : Maybe String
    , placeholder : String
    , options : List Option.Option
    , showDropdown : Bool
    , disabled : Maybe Bool
    }


type alias JsonMultiHttpSelectFieldProperties =
    { required : Required.IsRequired
    , key : String
    , label : String
    , width : Width.Width
    , enabledBy : Maybe String
    , placeholder : String
    , url : String
    , showDropdown : Bool
    , disabled : Maybe Bool
    }


type alias JsonCheckboxFieldProperties =
    { required : Required.IsRequired
    , key : String
    , label : String
    , width : Width.Width
    , enabledBy : Maybe String
    , tipe : FieldType.CheckboxFieldType
    , disabled : Maybe Bool
    }


type alias JsonRadioFieldProperties =
    { required : Required.IsRequired
    , key : String
    , label : String
    , width : Width.Width
    , enabledBy : Maybe String
    , default : Maybe String
    , options : List Option.Option
    , direction : Direction.Direction
    , disabled : Maybe Bool
    }


type alias JsonRadioBoolFieldProperties =
    { required : Required.IsRequired
    , key : String
    , label : String
    , width : Width.Width
    , enabledBy : Maybe String
    , disabled : Maybe Bool
    }


type alias JsonRadioEnumFieldProperties =
    { required : Required.IsRequired
    , key : String
    , label : String
    , width : Width.Width
    , enabledBy : Maybe String
    , default : Maybe RadioEnum.Value
    , options : List RadioEnum.Value
    , disabled : Maybe Bool
    }


type alias JsonAgeFieldProperties =
    { required : Required.IsRequired
    , key : String
    , label : String
    , width : Width.Width
    , enabledBy : Maybe String
    , disabled : Maybe Bool
    }


{-| -}
decoder : Time.Posix -> Int -> Decode.Decoder ( String, Field.Field )
decoder time order =
    Decode.field "type" FieldType.decoder
        |> Decode.andThen decoderForType
        |> Decode.map (toField time order)


decoderForType : FieldType.FieldType -> Decode.Decoder JsonField
decoderForType fieldType =
    case fieldType of
        FieldType.StringType (FieldType.SimpleType simpleType) ->
            Decode.map JsonSimpleField (decoderSimpleJson simpleType)

        FieldType.StringType FieldType.Select ->
            Decode.map JsonSelectField decoderSelectJson

        FieldType.StringType FieldType.HttpSelect ->
            Decode.map JsonHttpSelectField decoderHttpSelectJson

        FieldType.MultiStringType FieldType.MultiSelect ->
            Decode.map JsonMultiSelectField decoderMultiSelectJson

        FieldType.MultiStringType FieldType.MultiHttpSelect ->
            Decode.map JsonMultiHttpSelectField decoderMultiHttpSelectJson

        FieldType.StringType FieldType.Radio ->
            Decode.map JsonRadioField decoderRadioJson

        FieldType.BoolType (FieldType.CheckboxType checkboxFieldType) ->
            Decode.map JsonCheckboxField (decoderCheckboxJson checkboxFieldType)

        FieldType.BoolType FieldType.RadioBool ->
            Decode.map JsonRadioBoolField decoderRadioBoolJson

        FieldType.BoolType FieldType.RadioEnum ->
            Decode.map JsonRadioEnumField decoderRadioEnumJson

        FieldType.NumericType FieldType.Age ->
            Decode.map JsonAgeField decoderAgeJson


toField : Time.Posix -> Int -> JsonField -> ( String, Field.Field )
toField time order field =
    case field of
        JsonSimpleField { tipe, required, key, label, width, enabledBy, disabled } ->
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
                    , disabled = Maybe.withDefault False disabled
                    }
            )

        JsonCheckboxField { tipe, required, key, label, width, enabledBy, disabled } ->
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
                    , disabled = Maybe.withDefault False disabled
                    }
            )

        JsonSelectField { required, key, label, width, default, enabledBy, options, disabled } ->
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
                    , disabled = Maybe.withDefault False disabled
                    }
            )

        JsonHttpSelectField { required, key, label, width, default, enabledBy, url, disabled } ->
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
                    , disabled = Maybe.withDefault False disabled
                    }
            )

        JsonRadioField { required, key, label, width, default, enabledBy, options, direction, disabled } ->
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
                    , direction = direction
                    , disabled = Maybe.withDefault False disabled
                    }
            )

        JsonAgeField { required, key, label, width, enabledBy, disabled } ->
            ( key
            , Field.NumericField_ <|
                Field.AgeField
                    { required = required
                    , label = label
                    , width = width
                    , enabledBy = enabledBy
                    , order = order
                    , value = Nothing
                    , disabled = Maybe.withDefault False disabled
                    }
            )

        JsonRadioEnumField { required, key, label, width, default, enabledBy, options, disabled } ->
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
                    , disabled = Maybe.withDefault False disabled
                    }
            )

        JsonRadioBoolField { required, key, label, width, enabledBy, disabled } ->
            ( key
            , Field.BoolField_ <|
                Field.RadioBoolField
                    { required = required
                    , label = label
                    , width = width
                    , enabledBy = enabledBy
                    , order = order
                    , value = Nothing
                    , disabled = Maybe.withDefault False disabled
                    }
            )

        JsonMultiSelectField { required, key, label, width, placeholder, showDropdown, enabledBy, options, disabled } ->
            ( key
            , Field.MultiStringField_ <|
                Field.MultiSelectField
                    { required = required
                    , label = label
                    , width = width
                    , enabledBy = enabledBy
                    , order = order
                    , placeholder = placeholder
                    , showDropdown = showDropdown
                    , options = options
                    , value = Set.empty
                    , disabled = Maybe.withDefault False disabled
                    }
            )

        JsonMultiHttpSelectField { required, key, label, width, placeholder, showDropdown, enabledBy, url, disabled } ->
            ( key
            , Field.MultiStringField_ <|
                Field.MultiHttpSelectField
                    { required = required
                    , label = label
                    , width = width
                    , enabledBy = enabledBy
                    , order = order
                    , url = url
                    , placeholder = placeholder
                    , showDropdown = showDropdown
                    , options = RemoteData.NotAsked
                    , value = Set.empty
                    , disabled = Maybe.withDefault False disabled
                    }
            )


decoderSimpleJson : FieldType.SimpleFieldType -> Decode.Decoder JsonSimpleFieldProperties
decoderSimpleJson tipe =
    Decode.succeed JsonSimpleFieldProperties
        |> DecodePipeline.required "required" Required.decoder
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
        |> DecodePipeline.hardcoded tipe
        |> DecodePipeline.optional "disabled" (Decode.map Just Decode.bool) Nothing


decoderCheckboxJson : FieldType.CheckboxFieldType -> Decode.Decoder JsonCheckboxFieldProperties
decoderCheckboxJson tipe =
    Decode.succeed JsonCheckboxFieldProperties
        |> DecodePipeline.required "required" Required.decoder
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
        |> DecodePipeline.hardcoded tipe
        |> DecodePipeline.optional "disabled" (Decode.map Just Decode.bool) Nothing


decoderSelectJson : Decode.Decoder JsonSelectFieldProperties
decoderSelectJson =
    Decode.succeed JsonSelectFieldProperties
        |> DecodePipeline.required "required" Required.decoder
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
        |> DecodePipeline.optional "default" (Decode.maybe Decode.string) Nothing
        |> DecodePipeline.required "options" (Decode.list Option.decoder)
        |> DecodePipeline.optional "disabled" (Decode.map Just Decode.bool) Nothing


decoderHttpSelectJson : Decode.Decoder JsonHttpSelectFieldProperties
decoderHttpSelectJson =
    Decode.succeed JsonHttpSelectFieldProperties
        |> DecodePipeline.required "required" Required.decoder
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
        |> DecodePipeline.optional "default" (Decode.maybe Decode.string) Nothing
        |> DecodePipeline.required "url" Decode.string
        |> DecodePipeline.optional "disabled" (Decode.map Just Decode.bool) Nothing


decoderMultiSelectJson : Decode.Decoder JsonMultiSelectFieldProperties
decoderMultiSelectJson =
    Decode.succeed JsonMultiSelectFieldProperties
        |> DecodePipeline.required "required" Required.decoder
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
        |> DecodePipeline.required "placeholder" Decode.string
        |> DecodePipeline.required "options" (Decode.list Option.decoder)
        |> DecodePipeline.hardcoded False
        |> DecodePipeline.optional "disabled" (Decode.map Just Decode.bool) Nothing


decoderMultiHttpSelectJson : Decode.Decoder JsonMultiHttpSelectFieldProperties
decoderMultiHttpSelectJson =
    Decode.succeed JsonMultiHttpSelectFieldProperties
        |> DecodePipeline.required "required" Required.decoder
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
        |> DecodePipeline.required "placeholder" Decode.string
        |> DecodePipeline.required "url" Decode.string
        |> DecodePipeline.hardcoded False
        |> DecodePipeline.optional "disabled" (Decode.map Just Decode.bool) Nothing


decoderRadioJson : Decode.Decoder JsonRadioFieldProperties
decoderRadioJson =
    Decode.succeed JsonRadioFieldProperties
        |> DecodePipeline.required "required" Required.decoder
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
        |> DecodePipeline.optional "default" (Decode.maybe Decode.string) Nothing
        |> DecodePipeline.required "options" (Decode.list Option.decoder)
        |> DecodePipeline.optional "direction" Direction.decoder Direction.Column
        |> DecodePipeline.optional "disabled" (Decode.map Just Decode.bool) Nothing


decoderRadioBoolJson : Decode.Decoder JsonRadioBoolFieldProperties
decoderRadioBoolJson =
    Decode.succeed JsonRadioBoolFieldProperties
        |> DecodePipeline.required "required" Required.decoder
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
        |> DecodePipeline.optional "disabled" (Decode.map Just Decode.bool) Nothing


decoderRadioEnumJson : Decode.Decoder JsonRadioEnumFieldProperties
decoderRadioEnumJson =
    Decode.succeed JsonRadioEnumFieldProperties
        |> DecodePipeline.required "required" Required.decoder
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
        |> DecodePipeline.optional "default" (Decode.maybe RadioEnum.decoder) Nothing
        |> DecodePipeline.required "options" (Decode.list RadioEnum.decoder)
        |> DecodePipeline.optional "disabled" (Decode.map Just Decode.bool) Nothing


decoderAgeJson : Decode.Decoder JsonAgeFieldProperties
decoderAgeJson =
    Decode.succeed JsonAgeFieldProperties
        |> DecodePipeline.required "required" Required.decoder
        |> DecodePipeline.required "key" Decode.string
        |> DecodePipeline.required "label" Decode.string
        |> DecodePipeline.required "width" Width.decoder
        |> DecodePipeline.optional "enabledBy" (Decode.map Just Decode.string) Nothing
        |> DecodePipeline.optional "disabled" (Decode.map Just Decode.bool) Nothing
