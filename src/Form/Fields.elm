module Form.Fields exposing
    ( Fields
    , decoder, encode
    , updateBoolField, updateFieldRemoteOptions, updateNumericField, updateOptionField, updateRadioBoolField, updateRadioEnumField, updateStringField, updateMultiStringOptionField, updateShowDropdown, resetValueToDefault, updateSearchbar, updateTags, updateTagInput
    , hasCheckboxConsentField, isEnabled, isShown
    , updateSearchableSelectField
    )

{-| Fields.


# Fields

@docs Fields


# Json

@docs decoder, encode


# Update helpers

@docs updateBoolField, updateFieldRemoteOptions, updateNumericField, updateOptionField, updateRadioBoolField, updateRadioEnumField, updateStringField, updateMultiStringOptionField, updateShowDropdown, resetValueToDefault, updateSearchbar, updateTags, updateTagInput


# Predicates

@docs hasCheckboxConsentField, isEnabled, isShown

-}

import Dict
import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.Json as FieldJson
import Form.Field.Option as Option
import Form.Field.RadioEnum as RadioEnum
import Http.Detailed as HttpDetailed
import Json.Decode as Decode
import Json.Decode.Extra as DecodeExtra
import Json.Encode as Encode
import RemoteData
import Time


{-| -}
type alias Fields =
    Dict.Dict String Field.Field


{-| -}
decoder : Time.Posix -> Decode.Decoder (Dict.Dict String Field.Field)
decoder time =
    DecodeExtra.indexedList (FieldJson.decoder time)
        |> Decode.map Dict.fromList


{-| -}
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


{-| -}
resetValueToDefault : String -> Fields -> Fields
resetValueToDefault key =
    Dict.update key (Maybe.map Field.resetValueToDefault)
        >> updateEnabledByFields


{-| -}
updateStringField : String -> String -> Fields -> Fields
updateStringField key value =
    Dict.update key (Maybe.map (Field.updateStringValue value))
        >> updateEnabledByFields


{-| -}
updateSearchableSelectField : String -> String -> Fields -> Fields
updateSearchableSelectField key value =
    Dict.update key (Maybe.map (Field.updateStringValue value))
        >> updateEnabledByFields
        >> updateShowDropdown key False


{-| -}
updateMultiStringOptionField : String -> Option.Option -> Bool -> Fields -> Fields
updateMultiStringOptionField key option checked =
    Dict.update key (Maybe.map (Field.updateMultiStringOption option checked))
        >> updateEnabledByFields


{-| -}
updateOptionField : String -> Option.Option -> Fields -> Fields
updateOptionField key value =
    Dict.update key (Maybe.map (Field.updateStringValue value.value))
        >> updateEnabledByFields


{-| -}
updateBoolField : String -> Bool -> Fields -> Fields
updateBoolField key value =
    Dict.update key (Maybe.map (Field.updateBoolValue value))
        >> updateEnabledByFields


{-| -}
updateRadioEnumField : String -> RadioEnum.Value -> Fields -> Fields
updateRadioEnumField key value =
    Dict.update key (Maybe.map (Field.updateRadioEnumValue (Just value)))
        >> updateEnabledByFields


{-| -}
updateRadioBoolField : String -> Bool -> Fields -> Fields
updateRadioBoolField key value =
    Dict.update key (Maybe.map (Field.updateRadioBoolValue (Just value)))
        >> updateEnabledByFields


{-| -}
updateEnabledByFields : Fields -> Fields
updateEnabledByFields fields =
    -- Fold through list sorted by order so that enabledBy field has to precede the field
    Dict.toList fields
        |> List.sortBy (Tuple.second >> Field.getOrder)
        |> List.foldl
            (\( key, field ) acc ->
                Dict.insert key (updateFieldRequired acc field) acc
            )
            Dict.empty


{-| -}
updateFieldRequired : Fields -> Field.Field -> Field.Field
updateFieldRequired fields field =
    case Field.getEnabledBy field of
        Just enabledBy ->
            let
                enabled =
                    getTriggersByValue enabledBy fields
                        |> Maybe.withDefault True
            in
            if not enabled then
                Field.resetValueToDefault field

            else
                field

        Nothing ->
            field


{-| -}
updateNumericField : String -> String -> Fields -> Fields
updateNumericField key value =
    Dict.update key (Maybe.map (Field.updateNumericValue value))


{-| -}
updateFieldRemoteOptions : String -> RemoteData.RemoteData (HttpDetailed.Error String) (List Option.Option) -> Fields -> Fields
updateFieldRemoteOptions key options =
    Dict.update key (Maybe.map (Field.updateRemoteOptions options))


{-| -}
updateTags : Bool -> String -> String -> Fields -> Fields
updateTags addTag key value =
    Dict.update key (Maybe.map (Field.updateTagsValue addTag value))
        >> updateEnabledByFields


{-| -}
updateTagInput : String -> String -> Fields -> Fields
updateTagInput key value =
    Dict.update key (Maybe.map (Field.updateTagsInputBarValue value))
        >> updateEnabledByFields


{-| -}
updateShowDropdown : String -> Bool -> Fields -> Fields
updateShowDropdown key showDropdown =
    Dict.update key (Maybe.map (Field.updateShowDropdown showDropdown))
        >> updateEnabledByFields


{-| -}
updateSearchbar : String -> String -> Fields -> Fields
updateSearchbar key value =
    Dict.update key (Maybe.map (Field.updateSearchableSelectInput value))
        >> updateEnabledByFields


{-| -}
hasCheckboxConsentField : Fields -> Bool
hasCheckboxConsentField fields =
    Dict.values fields
        |> List.any (Field.getType >> (==) (FieldType.BoolType (FieldType.CheckboxType FieldType.CheckboxConsent)))


{-| -}
isEnabled : Fields -> Field.Field -> Bool
isEnabled fields field =
    let
        isDisabledField =
            (Field.getProperties field).disabled

        byFieldIsEnabled =
            case Field.getEnabledBy field of
                Just key ->
                    getTriggersByValue key fields
                        |> Maybe.withDefault True

                Nothing ->
                    True
    in
    not isDisabledField && byFieldIsEnabled


{-| -}
isShown : Fields -> Field.Field -> Bool
isShown fields field =
    let
        isHiddenField =
            (Field.getProperties field).hidden

        byFieldIsShown =
            case Field.getUnhiddenBy field of
                Just key ->
                    getTriggersByValue key fields
                        |> Maybe.withDefault True

                Nothing ->
                    True
    in
    not isHiddenField && byFieldIsShown


{-| -}
getTriggersByValue : String -> Fields -> Maybe Bool
getTriggersByValue key fields =
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
