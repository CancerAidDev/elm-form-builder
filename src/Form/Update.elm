module Form.Update exposing (update)

{-| Form.Update


# Update

@docs update

-}

import Form.Field.FieldType as FieldType
import Form.Fields as Fields
import Form.Msg as Msg


{-| -}
update : Msg.Msg -> Fields.Fields -> ( Fields.Fields, Cmd Msg.Msg )
update msg fields =
    case msg of
        Msg.UpdateStringField key value ->
            ( Fields.updateStringField key value fields, Cmd.none )

        Msg.UpdateMultiStringField key value checked ->
            ( Fields.updateMultiStringOptionField key value checked fields, Cmd.none )

        Msg.UpdateBoolField key value ->
            ( Fields.updateBoolField key value fields, Cmd.none )

        Msg.UpdateRadioStringField key value ->
            ( Fields.updateOptionField key value fields, Cmd.none )

        Msg.UpdateRadioBoolField key value ->
            ( Fields.updateRadioBoolField key value fields, Cmd.none )

        Msg.UpdateRadioEnumField key value ->
            ( Fields.updateRadioEnumField key value fields, Cmd.none )

        Msg.UpdateIntegerField key value ->
            ( Fields.updateIntegerField key value fields, Cmd.none )

        Msg.ResetField key ->
            ( Fields.resetValueToDefault key fields, Cmd.none )

        Msg.UpdateShowDropdown fieldType key showDropdown ->
            case fieldType of
                FieldType.StringType FieldType.Phone ->
                    ( Fields.updatePhoneShowDropdown key showDropdown fields, Cmd.none )

                _ ->
                    ( Fields.updateShowDropdown key showDropdown fields, Cmd.none )

        Msg.UpdateSelectedDropdownValue fieldType key value ->
            case fieldType of
                FieldType.StringType FieldType.Phone ->
                    ( Fields.updatePhoneDropdown key value fields, Cmd.none )

                _ ->
                    ( Fields.updateStringField key value fields, Cmd.none )

        Msg.UpdateSearchbar fieldType key value ->
            case fieldType of
                FieldType.StringType FieldType.Phone ->
                    ( Fields.updatePhoneSearchbar key value fields, Cmd.none )

                _ ->
                    ( Fields.updateSearchbar key value fields, Cmd.none )

        Msg.UpdateTags key value addTag ->
            ( Fields.updateTags addTag key value fields, Cmd.none )

        Msg.UpdateTagInput key value ->
            ( Fields.updateTagInput key value fields, Cmd.none )
