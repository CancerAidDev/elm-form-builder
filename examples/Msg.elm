module Msg exposing (..)

import Dialog
import Form.Msg as FormMsg


type Msg
    = DialogMsg Dialog.Msg
    | FormMsg FormMsg.Msg
    | SubmitForm
