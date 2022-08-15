module Main exposing (main)

import Browser
import Fields
import Form.Locale as Locale
import Model
import Msg
import Time
import Time.Extra as TimeExtra
import Update
import View


main : Program {} Model.Model Msg.Msg
main =
    Browser.element
        { init = \_ -> init
        , update = Update.update
        , view = View.view
        , subscriptions = \_ -> Sub.none
        }


init : ( Model.Model, Cmd Msg.Msg )
init =
    ( { startTime =
            TimeExtra.partsToPosix Time.utc <|
                TimeExtra.Parts 2022 Time.Jan 1 0 0 0 0
      , dialog = Nothing
      , locale = Locale.enAU
      , form = Fields.fields
      , submitted = False
      }
    , Cmd.none
    )
