module Form.Lib.Events exposing (onEnter)

import Html
import Html.Events as HtmlEvents
import Json.Decode as JsonDecode


onEnter : msg -> Html.Attribute msg
onEnter =
    onKeyDown 13


onKeyDown : Int -> msg -> Html.Attribute msg
onKeyDown correctCode msg =
    let
        isEscape : Int -> JsonDecode.Decoder msg
        isEscape code =
            if code == correctCode then
                JsonDecode.succeed msg

            else
                JsonDecode.fail "fail"
    in
    HtmlEvents.on "keydown" <| JsonDecode.andThen isEscape HtmlEvents.keyCode
