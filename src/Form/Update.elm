module Form.Update exposing (update)

{-| Form.Update


# Update

@docs update

-}

import Browser.Dom as BrowserDom
import Form.Fields as Fields
import Form.Msg as Msg
import Task


{-| -}
update : Msg.Msg -> Fields.Fields -> ( Fields.Fields, Cmd Msg.Msg )
update msg fields =
    case msg of
        Msg.NoOp ->
            ( fields, Cmd.none )

        Msg.UpdateStringField key value ->
            ( Fields.updateStringField key value fields
            , Cmd.none
            )

        Msg.UpdateSearchableSelectField key value ->
            ( Fields.updateStringField key value fields
            , Task.attempt (\_ -> Msg.NoOp) (BrowserDom.focus key)
            )

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

        Msg.UpdateShowDropdown key showDropdown ->
            ( Fields.updateShowDropdown key showDropdown fields
            , Cmd.none
            )

        Msg.UpdateSearchbar key value ->
            ( Fields.updateSearchbar key value fields, Cmd.none )

        Msg.UpdateTags key value addTag ->
            ( Fields.updateTags addTag key value fields, Cmd.none )

        Msg.UpdateTagInput key value ->
            ( Fields.updateTagInput key value fields, Cmd.none )
