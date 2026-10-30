module Msg exposing (..)

import Dialog
import Form.Msg as FormMsg
import Time


type Msg
    = DialogMsg Dialog.Msg
    | FormMsg FormMsg.Msg
    | SubmitForm
    | GotZone Time.Zone
