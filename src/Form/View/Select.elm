module Form.View.Select exposing
    ( select, httpSelect
    , searchableSelect
    )

{-| View Select Fields


# Select

@docs select, searchableSelect, httpSelect

-}

import Accessibility.Aria as Aria
import Accessibility.Key as Key
import Form.Field as Field
import Form.Field.Option as Option
import Form.Field.Required as Required
import Form.Msg as Msg
import Form.View.SearchableSelect as SearchableSelect
import Html
import Html.Attributes as HtmlAttributes
import Html.Events as HtmlEvents
import Html.Extra as HtmlExtra
import RemoteData


{-| -}
select : String -> Field.SelectFieldProperties {} -> Html.Html Msg.Msg
select key { value, required, options, disabled, hidden, placeholder, hasSelectablePlaceholder } =
    HtmlExtra.viewIf (not hidden) <|
        Html.div [ HtmlAttributes.class "select is-fullwidth" ]
            [ Html.select
                [ HtmlAttributes.name key
                , HtmlAttributes.required (required == Required.Yes)
                , HtmlAttributes.disabled disabled
                , HtmlEvents.onInput <| Msg.UpdateStringField key
                ]
                (viewPlaceholder hasSelectablePlaceholder placeholder
                    :: List.map (viewOption value) options
                )
            ]


viewPlaceholder : Bool -> String -> Html.Html Msg.Msg
viewPlaceholder selectabled placeholder =
    Html.option
        [ HtmlAttributes.value placeholder
        , HtmlAttributes.disabled (not selectabled)
        , HtmlAttributes.selected (not selectabled)
        , HtmlAttributes.hidden (not selectabled)
        ]
        [ Html.text placeholder ]


viewOption : String -> Option.Option -> Html.Html Msg.Msg
viewOption selectedValue option =
    Html.option
        [ HtmlAttributes.value option.value
        , HtmlAttributes.selected <| option.value == selectedValue
        ]
        [ Html.text (option.label |> Maybe.withDefault option.value) ]


{-| -}
searchableSelect : String -> Field.SearchableSelectFieldProperties -> Html.Html Msg.Msg
searchableSelect key properties =
    Html.div [ HtmlAttributes.class "dropdown is-active is-flex is-fullwidth" ]
        [ dropdownTrigger key properties
        , HtmlExtra.viewIf properties.showDropdown <| searchableDropdownMenu key properties
        ]


dropdownTrigger : String -> Field.SearchableSelectFieldProperties -> Html.Html Msg.Msg
dropdownTrigger key { placeholder, value, showDropdown } =
    let
        selectPlaceholder =
            if value == "" then
                placeholder

            else
                value
    in
    Html.div [ HtmlAttributes.class "dropdown-trigger", HtmlAttributes.style "width" "100%" ]
        [ Html.button
            [ HtmlAttributes.class "button pl-4 pr-0 is-fullwidth is-justify-content-space-between"
            , HtmlEvents.onClick <| Msg.UpdateShowDropdown key (not showDropdown)
            , Key.onKeyDown [ Key.escape <| Msg.UpdateShowDropdown key False ]
            , Aria.hasMenuPopUp
            , Aria.controls [ "dropdown-menu" ]
            ]
            [ Html.span [] [ Html.text selectPlaceholder ]
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


searchableDropdownMenu : String -> Field.SearchableSelectFieldProperties -> Html.Html Msg.Msg
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
                        List.map (\option -> viewSearchableOption key properties option) options
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
            filterSearchable properties.searchInput properties.options
    in
    Html.div []
        [ SearchableSelect.overlay key
        , Html.div
            [ HtmlAttributes.class "dropdown-menu"
            , HtmlAttributes.id "dropdown-menu"
            , Aria.roleDescription "menu"
            , Key.onKeyDown [ Key.escape <| Msg.UpdateShowDropdown key False ]
            ]
            [ Html.div [ HtmlAttributes.class "dropdown-content" ]
                ([ Html.div [ HtmlAttributes.class "dropdown-item" ]
                    [ Html.div [ HtmlAttributes.class "field" ]
                        [ Html.span [ HtmlAttributes.class "control" ]
                            [ Html.input
                                [ HtmlAttributes.class "input is-small"
                                , HtmlAttributes.placeholder "Search"
                                , HtmlEvents.onInput <| Msg.UpdateSearchbar key
                                , HtmlAttributes.value <| properties.searchInput
                                ]
                                []
                            ]
                        ]
                    ]
                 ]
                    ++ optionSection filteredOptions
                )
            ]
        ]


viewSearchableOption : String -> Field.SelectFieldProperties a -> Option.Option -> Html.Html Msg.Msg
viewSearchableOption key properties option =
    HtmlExtra.viewIf (not properties.hidden) <|
        Html.div
            [ HtmlAttributes.class "dropdown-item mr-2"
            , HtmlEvents.onClick <| Msg.UpdateSearchableSelectField key option.value
            ]
            [ Html.text (option.label |> Maybe.withDefault option.value)
            ]


{-| -}
httpSelect : String -> Field.HttpSelectFieldProperties -> Html.Html Msg.Msg
httpSelect key properties =
    RemoteData.map
        (\options ->
            select
                key
                { value = properties.value
                , required = properties.required
                , default = properties.default
                , options = options
                , label = properties.label
                , width = properties.width
                , enabledBy = properties.enabledBy
                , order = properties.order
                , disabled = properties.disabled
                , hidden = properties.hidden
                , unhiddenBy = properties.unhiddenBy
                , placeholder = properties.placeholder
                , hasSelectablePlaceholder = properties.hasSelectablePlaceholder
                }
        )
        properties.options
        |> RemoteData.withDefault HtmlExtra.nothing
