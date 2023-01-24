module Form.View.SearchableSelect exposing (overlay)

import Form.Msg as Msg
import Html
import Html.Attributes as HtmlAttributes
import Html.Events as HtmlEvents


overlay : String -> Html.Html Msg.Msg
overlay key =
    Html.div
        [ HtmlAttributes.style "position" "fixed"
        , HtmlAttributes.style "width" "100%"
        , HtmlAttributes.style "height" "100%"
        , HtmlAttributes.style "left" "0"
        , HtmlAttributes.style "top" "0"
        , HtmlAttributes.style "z-index" "1"
        , HtmlEvents.onClick <| Msg.UpdateShowDropdown key False
        ]
        []
