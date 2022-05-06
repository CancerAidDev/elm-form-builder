module Form.Update exposing (update)

{-| Form.Update


# Update

@docs update

-}

import Form.Msg as Msg
import Form.Types.Fields as Fields
import Form.Validate as Validate


{-| -}
update : Msg.Msg -> Fields.Fields -> ( Fields.Fields, Cmd Msg.Msg )
update msg fields =
    case msg of
        Msg.UpdateStringField key value ->
            ( Fields.updateStringField key value fields, Cmd.none )

        Msg.UpdateBoolField key value ->
            ( Fields.updateBoolField key value fields, Cmd.none )

        Msg.UpdateRadioStringField key value ->
            ( Fields.updateOptionField key value fields, Cmd.none )

        Msg.UpdateRadioBoolField key value ->
            ( Fields.updateRadioBoolField key value fields, Cmd.none )

        Msg.UpdateRadioEnumField key value ->
            ( Fields.updateRadioEnumField key value fields, Cmd.none )

        Msg.UpdateNumericField key value ->
            if Validate.isValidAgeInput (String.toInt value) then
                ( Fields.updateNumericField key value fields, Cmd.none )

            else
                ( fields, Cmd.none )
