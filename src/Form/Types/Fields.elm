module Form.Types.Fields exposing
    ( Fields
    , decoder
    , encode
    , hasCheckboxConsentField
    , isEnabled
    , updateBoolField
    , updateEnabledByFields
    , updateFieldRemoteOptions
    , updateNumericField
    , updateOptionField
    , updateRadioBoolField
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
        >> updateEnabledByFields


updateOptionField : String -> Option.Option -> Fields -> Fields
updateOptionField key value =
    Dict.update key (Maybe.map (Field.updateStringValue value.value))
        >> updateEnabledByFields


updateBoolField : String -> Bool -> Fields -> Fields
updateBoolField key value =
    Dict.update key (Maybe.map (Field.updateBoolValue value))
        >> updateEnabledByFields


updateRadioEnumField : String -> RadioEnum.Value -> Fields -> Fields
updateRadioEnumField key value =
    Dict.update key (Maybe.map (Field.updateRadioEnumValue (Just value)))
        >> updateEnabledByFields


updateRadioBoolField : String -> Bool -> Fields -> Fields
updateRadioBoolField key value =
    Dict.update key (Maybe.map (Field.updateRadioBoolValue (Just value)))
        >> updateEnabledByFields


updateEnabledByFields : Fields -> Fields
updateEnabledByFields fields =
    -- Fold through list sorted by order so that enabledBy field has to preceed the field
    Dict.toList fields
        |> List.sortBy (Tuple.second >> Field.getOrder)
        |> List.foldl
            (\( key, field ) acc ->
                Dict.insert key (updateFieldRequired acc field) acc
            )
            Dict.empty


updateFieldRequired : Fields -> Field.Field -> Field.Field
updateFieldRequired fields field =
    case Field.getEnabledBy field of
        Just enabledBy ->
            let
                enabled =
                    getEnabledByValue enabledBy fields
                        |> Maybe.withDefault True

                updatedField =
                    Field.setRequired enabled field
            in
            if enabled then
                updatedField

            else
                Field.resetValueToDefault updatedField

        Nothing ->
            field


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
    case Field.getEnabledBy field of
        Just key ->
            getEnabledByValue key fields
                |> Maybe.withDefault True

        Nothing ->
            True


getEnabledByValue : String -> Fields -> Maybe Bool
getEnabledByValue key fields =
    case Dict.get key fields of
        Just (Field.BoolField_ (Field.RadioBoolField { value })) ->
            case value of
                Nothing ->
                    Just False

                Just bool ->
                    Just bool

        Just (Field.BoolField_ (Field.CheckboxField { value })) ->
            Just value

        _ ->
            Nothing
