module Msg exposing (..)

import Dialog
import Form.Msg as FormMsg


type Msg
    = DialogMsg Dialog.Msg
    | FormMsg FormMsg.Msg
    | SubmitForm ButtonType


type ButtonType
    = Cancel
    | Submit


buttonToString : ButtonType -> String
buttonToString button =
    case button of
        Cancel ->
            "Cancel"

        Submit ->
            "Submit"
