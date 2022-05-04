module Form.Model exposing (Model, init)

import Form.Types.Fields as Fields
import Form.Types.Locale as Locale
import Time


type alias Model a =
    { a
        | locale : Locale.Locale
        , fields : Fields.Fields
        , submitted : Bool
        , time : Time.Posix
    }


init : Locale.Locale -> Fields.Fields -> Time.Posix -> Model {}
init locale fields time =
    { locale = locale
    , fields = fields
    , submitted = False
    , time = time
    }
