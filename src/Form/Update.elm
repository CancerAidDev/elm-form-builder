module Form.Update exposing (update)

import Form.Model as Model
import Form.Msg as Msg
import Form.Types.Fields as Fields
import Form.Validate as Validate


update : Msg.Msg -> Model.Model a -> ( Model.Model a, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.UpdateStringField key value ->
            ( { model | fields = Fields.updateStringField key value model.fields }
            , Cmd.none
            )

        Msg.UpdateBoolField key value ->
            ( { model | fields = Fields.updateBoolField key value model.fields }
            , Cmd.none
            )

        Msg.UpdateRadioStringField key value ->
            ( { model | fields = Fields.updateOptionField key value model.fields }
            , Cmd.none
            )

        Msg.UpdateRadioBoolField key value ->
            ( { model | fields = Fields.updateRadioBoolField key value model.fields }
            , Cmd.none
            )

        Msg.UpdateRadioEnumField key value ->
            ( { model | fields = Fields.updateRadioEnumField key value model.fields }
            , Cmd.none
            )

        Msg.UpdateNumericField key value ->
            if Validate.isValidAgeInput (String.toInt value) then
                ( { model | fields = Fields.updateNumericField key value model.fields }
                , Cmd.none
                )

            else
                ( model
                , Cmd.none
                )
