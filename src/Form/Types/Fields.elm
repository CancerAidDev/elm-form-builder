module Form.Types.Fields exposing
    ( Fields
    , decoder
    , encode
    , getEnabledParentValue
    , hasCheckboxConsentField
    , isEnabled
    , updateBoolField
    , updateEnabledByField
    , updateFieldRemoteOptions
    , updateNumericField
    , updateOptionField
    , updateRadioBoolField
    , updateRadioBoolFieldRequired
    , updateRadioEnumField
    , updateStringField
    )

import Dict
import Form.Types.Field as Field
import Form.Types.FieldType as FieldType
import Form.Types.Json as Json
import Form.Types.Option as Option
import Form.Types.RadioEnum as RadioEnum
import Http.Detailed as HttpDetailed
import Json.Decode as Decode
import Json.Decode.Extra as DecodeExtra
import Json.Encode as Encode
import RemoteData
import Time


type alias Fields =
    Dict.Dict String Field.Field


decoder : Time.Posix -> Decode.Decoder (Dict.Dict String Field.Field)
decoder time =
    DecodeExtra.indexedList (Json.decoder time)
        |> Decode.map Dict.fromList


encode : Fields -> Dict.Dict String Encode.Value
encode =
    Dict.foldl
        (\key field ( dict, metadataDict ) ->
            case Field.metadataKey key of
                Just metadataKey ->
                    ( dict, Dict.insert metadataKey (Field.encode field) metadataDict )

                Nothing ->
                    ( Dict.insert key (Field.encode field) dict, metadataDict )
        )
        ( Dict.empty, Dict.empty )
        >> (\( dict, metadataDict ) ->
                if Dict.isEmpty metadataDict then
                    dict

                else
                    Dict.insert "metadata" (Encode.dict identity identity metadataDict) dict
           )


updateStringField : String -> String -> Fields -> Fields
updateStringField key value =
    Dict.update key (Maybe.map (Field.updateStringValue value))


updateOptionField : String -> Option.Option -> Fields -> Fields
updateOptionField key value =
    Dict.update key (Maybe.map (Field.updateStringValue value.value))


updateBoolField : String -> Bool -> Fields -> Fields
updateBoolField key value =
    Dict.update key (Maybe.map (Field.updateBoolValue value))


updateRadioEnumField : String -> RadioEnum.Value -> Fields -> Fields
updateRadioEnumField key value =
    Dict.update key (Maybe.map (Field.updateRadioEnumValue (Just value)))


updateRadioBoolField : String -> Bool -> Fields -> Fields
updateRadioBoolField key value =
    Dict.update key (Maybe.map (Field.updateRadioBoolValue (Just value)))
        >> updateEnabledByField


updateRadioBoolFieldRequired : Dict.Dict String Field.Field -> String -> Field.Field -> Field.Field
updateRadioBoolFieldRequired fields _ field =
    case Field.hasEnabledBy field of
        Just parentKey ->
            case field of
                Field.BoolField_ (Field.RadioBoolField properties) ->
                    let
                        enabled =
                            getEnabledParentValue parentKey fields
                    in
                    Field.BoolField_
                        (Field.RadioBoolField
                            { properties
                                | required = enabled
                                , value =
                                    if enabled then
                                        properties.value

                                    else
                                        Nothing
                            }
                        )

                _ ->
                    field

        _ ->
            field


updateEnabledByField : Fields -> Fields
updateEnabledByField fields =
    Dict.map (updateRadioBoolFieldRequired fields) fields


updateNumericField : String -> String -> Fields -> Fields
updateNumericField key value =
    Dict.update key (Maybe.map (Field.updateNumericValue value))


updateFieldRemoteOptions : String -> RemoteData.RemoteData (HttpDetailed.Error String) (List Option.Option) -> Fields -> Fields
updateFieldRemoteOptions key options =
    Dict.update key (Maybe.map (Field.updateRemoteOptions options))


hasCheckboxConsentField : Fields -> Bool
hasCheckboxConsentField fields =
    Dict.values fields
        |> List.any (Field.getType >> (==) (FieldType.BoolType (FieldType.CheckboxType FieldType.CheckboxConsent)))


isEnabled : Fields -> Field.Field -> Bool
isEnabled fields field =
    case Field.hasEnabledBy field of
        Just key ->
            getEnabledParentValue key fields

        Nothing ->
            True


getEnabledParentValue : String -> Fields -> Bool
getEnabledParentValue key fields =
    case Dict.get key fields of
        Just (Field.BoolField_ (Field.RadioBoolField { value })) ->
            case value of
                Nothing ->
                    False

                Just bool ->
                    bool

        _ ->
            True
