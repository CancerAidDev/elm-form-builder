module Form.Update exposing (update)

import Form.Model as Model
import Form.Msg as Msg
import Form.Types.Fields as Fields
import Form.Validate as Validate


update : Msg.Msg -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.UpdateStringField key value ->
            ( Fields.updateStringField key value model
            , Cmd.none
            )

        Msg.UpdateBoolField key value ->
            ( Fields.updateBoolField key value model
            , Cmd.none
            )

        Msg.UpdateRadioStringField key value ->
            ( Fields.updateOptionField key value model
            , Cmd.none
            )

        Msg.UpdateRadioBoolField key value ->
            ( Fields.updateRadioBoolField key value model
            , Cmd.none
            )

        Msg.UpdateRadioEnumField key value ->
            ( Fields.updateRadioEnumField key value model
            , Cmd.none
            )

        Msg.UpdateNumericField key value ->
            if Validate.isValidAgeInput (String.toInt value) then
                ( Fields.updateNumericField key value model
                , Cmd.none
                )

            else
                ( model
                , Cmd.none
                )
