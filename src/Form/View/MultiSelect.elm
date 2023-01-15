module Form.View.MultiSelect exposing (multiHttpSelect, multiSelect, searchableMultiSelect)

import Accessibility.Aria as Aria
import Accessibility.Key as Key
import Form.Field as Field
import Form.Field.Option as Option
import Form.Lib.Events as LibEvents
import Form.Msg as Msg
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
            , Html.span
                [ HtmlAttributes.class "icon mx-3"
                ]
                [ Html.i
                    [ HtmlAttributes.class
                        (if showDropdown then
                            "fa-solid fa-angle-up fa-lg"

                         else
                            "fa-solid fa-angle-down fa-lg"
                        )
                    ]
                    []
                ]
            ]
        ]


dropdownMenu : String -> Field.MultiSelectFieldProperties {} -> Html.Html Msg.Msg
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


searchableDropdownMenu : String -> Field.SearchableMultiSelectFieldProperties -> Html.Html Msg.Msg
searchableDropdownMenu key properties =
    let
        optionSection : List Option.Option -> List (Html.Html Msg.Msg)
        optionSection options =
            if List.isEmpty options then
                []

            else
                let
                    optionItem : List (Html.Html Msg.Msg)
                    optionItem =
                        List.map (\option -> viewCheckbox key properties option) options
                in
                [ Html.hr [ HtmlAttributes.class "dropdown-divider" ] []
                , Html.div [ HtmlAttributes.class "dropdown-items" ] optionItem
                ]

        filteredOptions : List Option.Option
        filteredOptions =
            let
                caseInsensitiveContains : String -> String -> Bool
                caseInsensitiveContains s1 s2 =
                    String.contains (String.toLower s1) (String.toLower s2)

                takeOption : String -> Option.Option -> Bool
                takeOption searchString option =
                    List.any (caseInsensitiveContains searchString) (option.value :: List.filterMap identity [ option.label ])

                filterSearchable : String -> List Option.Option -> List Option.Option
                filterSearchable searchString options =
                    List.filter (takeOption searchString) options
            in
            filterSearchable properties.searchInput properties.searchableOptions
    in
    Html.div []
        [ overlay key
        , Html.div
            [ HtmlAttributes.class "dropdown-menu"
            , HtmlAttributes.id "dropdown-menu"
            , Aria.roleDescription "menu"
            , Key.onKeyDown [ Key.escape <| Msg.UpdateShowDropdown key False ]
            ]
            [ Html.div [ HtmlAttributes.class "dropdown-content" ]
                ([ Html.div
                    [ HtmlAttributes.class "dropdown-item is-flex is-align-items-center is-justify-content-space-between" ]
                    [ Html.div [] [ Html.text <| String.fromInt (Set.size properties.value) ++ " Selected" ]
                    , Html.button
                        [ HtmlAttributes.class "button is-small"
                        , HtmlEvents.onClick <| Msg.ResetField key
                        ]
                        [ Html.text "Reset" ]
                    ]
                 , Html.hr [ HtmlAttributes.class "dropdown-divider" ] []
                 , Html.div [ HtmlAttributes.class "dropdown-item" ]
                    [ Html.div [ HtmlAttributes.class "field" ]
                        [ Html.div [ HtmlAttributes.class "control has-icons-left" ]
                            [ Html.input
                                ([ HtmlAttributes.class "input is-small"
                                 , HtmlAttributes.placeholder "Search"
                                 , HtmlEvents.onInput <| Msg.UpdateSearchbar key
                                 , HtmlAttributes.value <| properties.searchInput
                                 ]
                                    ++ (case filteredOptions of
                                            [] ->
                                                []

                                            headoption :: _ ->
                                                [ LibEvents.onEnter <|
                                                    Msg.UpdateMultiStringField key headoption <|
                                                        not <|
                                                            Set.member headoption.value properties.value
                                                ]
                                       )
                                )
                                []
                            , Html.span [ HtmlAttributes.class "icon is-left pl-1" ]
                                [ Html.i [ HtmlAttributes.class "fa-solid fa-search" ] [] ]
                            ]
                        ]
                    ]
                 ]
                    ++ optionSection properties.options
                    ++ optionSection filteredOptions
                )
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


viewCheckbox : String -> Field.MultiSelectFieldProperties a -> Option.Option -> Html.Html Msg.Msg
viewCheckbox key properties option =
    let
        checked =
            Set.member option.value properties.value
    in
    HtmlExtra.viewIf (not properties.hidden) <|
        Html.div [ HtmlAttributes.class "dropdown-item" ]
            [ Html.label [ HtmlAttributes.class "checkbox" ]
                [ Html.input
                    [ HtmlAttributes.class "mr-2"
                    , HtmlAttributes.type_ "checkbox"
                    , HtmlAttributes.disabled properties.disabled
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
                , disabled = properties.disabled
                , hidden = properties.hidden
                , unhiddenBy = properties.unhiddenBy
                }
        )
        properties.options
        |> RemoteData.withDefault HtmlExtra.nothing
