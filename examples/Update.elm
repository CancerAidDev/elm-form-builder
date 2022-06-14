module Update exposing (..)

import Dialog
import Form.Fields as Fields
import Form.Update as FormUpdate
import Form.Validate as Validate
import Json.Encode as Encode
import Model
import Msg


update : Msg.Msg -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.DialogMsg subMsg ->
            Dialog.update subMsg model.dialog
                |> updateWith (\updatedDialog -> { model | dialog = updatedDialog }) Msg.DialogMsg

        Msg.FormMsg subMsg ->
            FormUpdate.update subMsg model.form
                |> updateWith (\updatedForm -> { model | form = updatedForm }) Msg.FormMsg

        Msg.SubmitForm ->
            let
                newDialog =
                    Dialog.info
                        { title = "Info"
                        , message = "Success. Encoded form: " ++ (Encode.encode 1 <| Encode.dict identity identity (Fields.encode model.form))
                        }
            in
            model.form
                |> Validate.validate model.locale
                |> Maybe.map (\fields -> ( { model | dialog = Just newDialog, form = fields }, Cmd.none ))
                |> Maybe.withDefault ( { model | submitted = True }, Cmd.none )


updateWith : (subModel -> model) -> (subMsg -> msg) -> ( subModel, Cmd subMsg ) -> ( model, Cmd msg )
updateWith toModel toMsg ( subModel, subCmd ) =
    ( toModel subModel, Cmd.map toMsg subCmd )
