module Form.View.MultiSelect exposing (multiHttpSelect, multiSelect, searchableMultiSelect)

import Accessibility.Aria as Aria
import Accessibility.Key as Key
import Form.Field as Field
import Form.Field.Option as Option
import Form.Msg as Msg
import Form.View.Dropdown as Dropdown
import Html
import Html.Attributes as HtmlAttributes
import Html.Events as HtmlEvents
import Html.Extra as HtmlExtra
import RemoteData
import Set


{-| -}
multiSelect : String -> Field.MultiSelectFieldProperties {} -> Html.Html Msg.Msg
multiSelect key properties =
    Html.div [ HtmlAttributes.class "dropdown is-active" ]
        [ dropdownTrigger key properties
        , HtmlExtra.viewIf properties.showDropdown <| dropdownMenu key properties
        ]


{-| -}
searchableMultiSelect : String -> Field.SearchableMultiSelectFieldProperties -> Html.Html Msg.Msg
searchableMultiSelect key properties =
    Html.div [ HtmlAttributes.class "dropdown is-active" ]
        [ dropdownTrigger key properties
        , HtmlExtra.viewIf properties.showDropdown <| searchableDropdownMenu key properties
        ]


dropdownTrigger : String -> Field.MultiSelectFieldProperties a -> Html.Html Msg.Msg
dropdownTrigger key { placeholder, value, showDropdown } =
    Html.div [ HtmlAttributes.class "dropdown-trigger" ]
        [ Html.button
            [ HtmlAttributes.class "button pl-4 pr-0"
            , HtmlEvents.onClick <| Msg.UpdateShowDropdown key (not showDropdown)
            , Key.onKeyDown [ Key.escape <| Msg.UpdateShowDropdown key False ]
            , Aria.hasMenuPopUp
            , Aria.controls [ "dropdown-menu" ]
            ]
            [ Html.span [] [ Html.text placeholder ]
            , Html.span
                [ HtmlAttributes.class "tag is-link ml-2"
                , HtmlAttributes.style "font-variant-numeric" "tabular-nums"
                ]
                [ Html.text <| String.fromInt (Set.size value) ]
            , Dropdown.dropdownIcon showDropdown
            ]
        ]


multiSelectReset : String -> Int -> List (Html.Html Msg.Msg)
multiSelectReset key selected =
    [ Html.div [] [ Html.text <| String.fromInt selected ++ " Selected" ]
    , Html.button
        [ HtmlAttributes.class "button is-small"
        , HtmlEvents.onClick <| Msg.ResetField key
        ]
        [ Html.text "Reset" ]
    ]


dropdownMenu : String -> Field.MultiSelectFieldProperties {} -> Html.Html Msg.Msg
dropdownMenu key properties =
    Html.div []
        [ Dropdown.overlay key
        , Html.div
            [ HtmlAttributes.class "dropdown-menu"
            , HtmlAttributes.id key
            , Aria.roleDescription "menu"
            , Key.onKeyDown [ Key.escape <| Msg.UpdateShowDropdown key False ]
            ]
            [ Html.div [ HtmlAttributes.class "dropdown-content" ]
                [ Html.div
                    [ HtmlAttributes.class "dropdown-item is-flex is-align-items-center is-justify-content-space-between" ]
                  <|
                    multiSelectReset key <|
                        Set.size properties.value
                , Html.hr [ HtmlAttributes.class "dropdown-divider" ] []
                , Html.div [ HtmlAttributes.class "dropdown-items" ]
                    (List.map (\option -> viewCheckbox key properties option) properties.options)
                ]
            ]
        ]


searchableDropdownMenu : String -> Field.SearchableMultiSelectFieldProperties -> Html.Html Msg.Msg
searchableDropdownMenu key properties =
    let
        optionSection : List Option.Option -> List (Html.Html Msg.Msg)
        optionSection options =
            [ Html.hr [ HtmlAttributes.class "dropdown-divider" ] []
            , Html.div [ HtmlAttributes.class "dropdown-items" ] <|
                List.map (viewCheckbox key properties) options
            ]

        filteredOptions : List Option.Option
        filteredOptions =
            Dropdown.filteredOptions properties.searchInput properties.searchableOptions
    in
    Html.div []
        [ Dropdown.overlay key
        , Html.div
            [ HtmlAttributes.class "dropdown-menu"
            , HtmlAttributes.id key
            , Aria.roleDescription "menu"
            , Key.onKeyDown [ Key.escape <| Msg.UpdateShowDropdown key False ]
            ]
            [ Html.div [ HtmlAttributes.class "dropdown-content" ]
                ([ Html.div
                    [ HtmlAttributes.class "dropdown-item is-flex is-align-items-center is-justify-content-space-between" ]
                   <|
                    multiSelectReset key <|
                        Set.size properties.value
                 , Html.hr [ HtmlAttributes.class "dropdown-divider" ] []
                 , Dropdown.searchBar key properties.searchInput properties.value filteredOptions
                 ]
                    ++ optionSection properties.options
                    ++ optionSection filteredOptions
                )
            ]
        ]


viewCheckbox : String -> Field.MultiSelectFieldProperties a -> Option.Option -> Html.Html Msg.Msg
viewCheckbox key properties option =
    HtmlExtra.viewIf (not properties.hidden) <|
        Html.div [ HtmlAttributes.class "dropdown-item" ]
            [ Html.label [ HtmlAttributes.class "checkbox" ]
                [ Html.input
                    [ HtmlAttributes.class "mr-2"
                    , HtmlAttributes.type_ "checkbox"
                    , HtmlAttributes.disabled properties.disabled
                    , HtmlAttributes.checked <| Set.member option.value properties.value
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
                , disabled = properties.disabled
                , hidden = properties.hidden
                , unhiddenBy = properties.unhiddenBy
                }
        )
        properties.options
        |> RemoteData.withDefault HtmlExtra.nothing
