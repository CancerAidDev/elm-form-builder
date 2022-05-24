module Form.View.MultiSelect exposing (multiHttpSelect, multiSelect)

import Accessibility.Aria as Aria
import Accessibility.Key as Key
import FontAwesome.Attributes as Icon
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
multiSelect key ({ options, placeholder, value, showDropdown } as properties) =
    Html.div [ HtmlAttributes.class "dropdown is-active" ]
        [ Icon.css
        , Html.div [ HtmlAttributes.class "dropdown-trigger" ]
            [ Html.button
                [ HtmlAttributes.class "button"
                , HtmlEvents.onClick <| Msg.ShowDropdown key True
                , Key.onKeyDown [ Key.escape <| Msg.ShowDropdown key False ]
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
        , HtmlExtra.viewIf showDropdown <|
            Html.div
                [ HtmlAttributes.class "dropdown-menu"
                , HtmlAttributes.id "dropdown-menu"
                , Aria.roleDescription "menu"
                ]
                [ Html.div [ HtmlAttributes.class "dropdown-content" ]
                    ([ Html.div
                        [ HtmlAttributes.class "dropdown-item is-flex is-align-items-center is-justify-content-space-between" ]
                        [ Html.div [] [ Html.text <| String.fromInt (Set.size value) ++ " Selected" ]
                        , Html.button
                            [ HtmlAttributes.class "button is-small"
                            , HtmlEvents.onClick <| Msg.ResetField key
                            ]
                            [ Html.text "Reset" ]
                        ]
                     , Html.hr [ HtmlAttributes.class "dropdown-divider" ] []
                     ]
                        ++ List.map (\option -> viewCheckbox key properties option) options
                    )
                ]
        ]


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
                , default = properties.default
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
