module Form.View.SearchableSelect exposing (overlay, filteredOptions)

import Accessibility.Aria as Aria
import Accessibility.Key as Key
import Form.Msg as Msg
import Html
import Html.Attributes as HtmlAttributes
import Html.Events as HtmlEvents
import Form.Field as Field
import Set
import Form.Field.Option as Option


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

filteredOptions : String -> List Option.Option -> List Option.Option
filteredOptions searchString options=
    let
        caseInsensitiveContains : String -> String -> Bool
        caseInsensitiveContains s1 s2 =
            String.contains (String.toLower s1) (String.toLower s2)

        takeOption :  Option.Option -> Bool
        takeOption option =
            List.any (caseInsensitiveContains searchString) (option.value :: List.filterMap identity [ option.label ])
    in
    List.filter takeOption options