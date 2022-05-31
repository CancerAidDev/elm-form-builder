module Form.View.MultiSelect exposing (multiHttpSelect, multiSelect)

import Accessibility.Aria as Aria
import Accessibility.Key as Key
import FontAwesome.Icon as Icon
import FontAwesome.Solid as Icon
import FontAwesome.Styles as Icon
import Form.Field as Field
import Form.Field.Option as Option
import Form.Msg as Msg
import Html
import Html.Attributes as HtmlAttributes
import Html.Events as HtmlEvents
import Html.Extra as HtmlExtra
import RemoteData
import Set


{-| -}
multiSelect : String -> Field.MultiSelectFieldProperties -> Html.Html Msg.Msg
multiSelect key properties =
    Html.div [ HtmlAttributes.class "dropdown is-active" ]
        [ Icon.css
        , dropdownTrigger key properties
        , HtmlExtra.viewIf properties.showDropdown <| dropdownMenu key properties
        ]


dropdownTrigger : String -> Field.MultiSelectFieldProperties -> Html.Html Msg.Msg
dropdownTrigger key { placeholder, value, showDropdown } =
    Html.div [ HtmlAttributes.class "dropdown-trigger" ]
        [ Html.button
            [ HtmlAttributes.class "button"
            , HtmlEvents.onClick <| Msg.UpdateShowDropdown key (not showDropdown)
            , Key.onKeyDown [ Key.escape <| Msg.UpdateShowDropdown key False ]
            , Aria.hasMenuPopUp
            , Aria.controls [ "dropdown-menu" ]
            ]
            [ Html.span [] [ Html.text placeholder ]
            , Html.span
                [ HtmlAttributes.class "tag is-link ml-4"
                , HtmlAttributes.style "font-variant-numeric" "tabular-nums"
                ]
                [ Html.text <| String.fromInt (Set.size value) ]
            , Html.span [ HtmlAttributes.class "icon" ] [ Icon.viewIcon Icon.angleDown ]
            ]
        ]


dropdownMenu : String -> Field.MultiSelectFieldProperties -> Html.Html Msg.Msg
dropdownMenu key properties =
    Html.div []
        [ overlay key
        , Html.div
            [ HtmlAttributes.class "dropdown-menu"
            , HtmlAttributes.id "dropdown-menu"
            , Aria.roleDescription "menu"
            , Key.onKeyDown [ Key.escape <| Msg.UpdateShowDropdown key False ]
            ]
            [ Html.div [ HtmlAttributes.class "dropdown-content" ]
                [ Html.div
                    [ HtmlAttributes.class "dropdown-item is-flex is-align-items-center is-justify-content-space-between" ]
                    [ Html.div [] [ Html.text <| String.fromInt (Set.size properties.value) ++ " Selected" ]
                    , Html.button
                        [ HtmlAttributes.class "button is-small"
                        , HtmlEvents.onClick <| Msg.ResetField key
                        ]
                        [ Html.text "Reset" ]
                    ]
                , Html.hr [ HtmlAttributes.class "dropdown-divider" ] []
                , Html.div [ HtmlAttributes.class "dropdown-items" ]
                    (List.map (\option -> viewCheckbox key properties option) properties.options)
                ]
            ]
        ]


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


viewCheckbox : String -> Field.MultiSelectFieldProperties -> Option.Option -> Html.Html Msg.Msg
viewCheckbox key properties option =
    let
        checked =
            Set.member option.value properties.value
    in
    Html.div [ HtmlAttributes.class "dropdown-item" ]
        [ Html.label [ HtmlAttributes.class "checkbox" ]
            [ Html.input
                [ HtmlAttributes.class "mr-2"
                , HtmlAttributes.type_ "checkbox"
                , HtmlAttributes.checked checked
                , HtmlEvents.onCheck <| Msg.UpdateMultiStringField key option
                ]
                []
            , Html.text (option.label |> Maybe.withDefault option.value)
            ]
        ]


{-| -}
multiHttpSelect : String -> Field.MultiHttpSelectFieldProperties -> Html.Html Msg.Msg
multiHttpSelect key properties =
    RemoteData.map
        (\options ->
            multiSelect key
                { value = properties.value
                , required = properties.required
                , options = options
                , placeholder = properties.placeholder
                , showDropdown = properties.showDropdown
                , label = properties.label
                , width = properties.width
                , enabledBy = properties.enabledBy
                , order = properties.order
                }
        )
        properties.options
        |> RemoteData.withDefault HtmlExtra.nothing
