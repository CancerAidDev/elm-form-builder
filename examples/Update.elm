module Update exposing (..)

import Dialog
import Form.Lib.Update as LibUpdate
import Form.Locale as Locale
import Form.Update as FormUpdate
import Form.Validate as Validate
import Model
import Msg


update : Msg.Msg -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.DialogMsg subMsg ->
            Dialog.update subMsg model.dialog
                |> LibUpdate.updateWith (\updatedDialog -> { model | dialog = updatedDialog }) Msg.DialogMsg

        Msg.FormMsg subMsg ->
            FormUpdate.update subMsg model.form
                |> LibUpdate.updateWith (\updatedForm -> { model | form = updatedForm }) Msg.FormMsg

        Msg.SubmitForm button ->
            let
                newDialog =
                    Dialog.info
                        { title = "Info"
                        , message = Msg.buttonToString button
                        }
            in
            model.form
                |> Validate.validate Locale.enAU
                |> Maybe.map (\fields -> ( { model | dialog = Just newDialog, form = fields }, Cmd.none ))
                |> Maybe.withDefault ( { model | submitted = True }, Cmd.none )
