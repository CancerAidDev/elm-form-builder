module Main exposing (main)

import Browser
import Fields
import Form.Locale as Locale
import Iso8601
import Model
import Msg
import Time
import Time.Extra as TimeExtra
import Update
import View


type alias Flags =
    { date : String }


main : Program Flags Model.Model Msg.Msg
main =
    Browser.element
        { init = init
        , update = Update.update
        , view = View.view
        , subscriptions = \_ -> Sub.none
        }


init : Flags -> ( Model.Model, Cmd Msg.Msg )
init { date } =
    ( { startTime =
            let
                default =
                    TimeExtra.partsToPosix Time.utc <|
                        TimeExtra.Parts 2022 Time.Jan 1 0 0 0 0
            in
            Iso8601.toTime date |> Result.withDefault default
      , dialog = Nothing
      , locale = Locale.enAU
      , form = Fields.fields
      , submitted = False
      }
    , Cmd.none
    )
