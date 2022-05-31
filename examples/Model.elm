module Model exposing (..)

import Dialog
import Form.Fields as FormFields
import Form.Locale as Locale
import Msg
import Time


type alias Model =
    { startTime : Time.Posix
    , dialog : Dialog.Model String Msg.Msg
    , locale : Locale.Locale
    , form : FormFields.Fields
    , submitted : Bool
    }
