module Model exposing (..)

import Dialog
import Form.Fields as FormFields
import Msg
import Time


type alias Model =
    { startTime : Time.Posix
    , dialog : Dialog.Model String Msg.Msg
    , form : FormFields.Fields
    , submitted : Bool
    }
