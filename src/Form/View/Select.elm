module Form.View.Select exposing (select, searchableSelect, httpSelect)

{-| View Select Fields


# Select

@docs select, searchableSelect, httpSelect

-}

import Accessibility.Aria as Aria
import Accessibility.Key as Key
import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.Option as Option
import Form.Field.Required as Required
import Form.Locale.CountryCode as CountryCode
import Form.Locale.Phone as Phone
import Form.Msg as Msg
import Form.View.Dropdown as Dropdown
import Html
import Html.Attributes as HtmlAttributes
import Html.Events as HtmlEvents
import Html.Extra as HtmlExtra
import RemoteData
import Set


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
searchableSelect : String -> Field.Field -> Html.Html Msg.Msg
searchableSelect key field =
    case field of
        Field.StringField_ (Field.SearchableSelectField properties) ->
            Html.div [ HtmlAttributes.class "dropdown is-active is-flex is-fullwidth" ]
                [ dropdownTrigger key { placeholder = properties.placeholder, value = properties.value, showDropdown = properties.showDropdown }
                , HtmlExtra.viewIf (properties.showDropdown && not properties.hidden) <| searchableDropdownMenu key (FieldType.StringType FieldType.SearchableSelect) { searchInput = properties.searchInput, options = properties.options, value = properties.value }
                ]

        Field.StringField_ (Field.PhoneUniversalField { showDropdown, searchInput, selectedCountryCode }) ->
            let
                options =
                    List.map
                        (\code ->
                            { label = Just <| CountryCode.toCountryName code ++ " (" ++ Phone.phonePrefix code ++ ")", value = CountryCode.toString code }
                        )
                        CountryCode.allCountryCodes
            in
            Html.div [ HtmlAttributes.class "dropdown is-active is-flex is-fullwidth" ]
                [ dropdownTrigger key { placeholder = "", value = Maybe.withDefault "" <| Maybe.map Phone.phonePrefix selectedCountryCode, showDropdown = showDropdown }
                , HtmlExtra.viewIf showDropdown <| searchableDropdownMenu key (FieldType.StringType FieldType.PhoneUniversal) { searchInput = searchInput, options = options, value = Maybe.withDefault "" <| Maybe.map CountryCode.toString selectedCountryCode }
                ]

        _ ->
            HtmlExtra.nothing


dropdownTrigger : String -> { placeholder : String, value : String, showDropdown : Bool } -> Html.Html Msg.Msg
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
            , Dropdown.dropdownIcon showDropdown
            ]
        ]


searchableDropdownMenu : String -> FieldType.FieldType -> { searchInput : String, options : List Option.Option, value : String } -> Html.Html Msg.Msg
searchableDropdownMenu key fieldType { searchInput, options, value } =
    let
        filteredOptions =
            Dropdown.filteredOptions searchInput options
    in
    Html.div []
        [ Dropdown.overlay key
        , Html.div
            [ HtmlAttributes.class "dropdown-menu"
            , HtmlAttributes.id "dropdown-menu"
            , Aria.roleDescription "menu"
            , Key.onKeyDown [ Key.escape <| Msg.UpdateShowDropdown key False ]
            ]
            [ Html.div [ HtmlAttributes.class "dropdown-content" ]
                [ Dropdown.searchBar key searchInput (Set.singleton value) filteredOptions
                , Html.hr [ HtmlAttributes.class "dropdown-divider" ] []
                , Html.div [ HtmlAttributes.class "dropdown-items" ] <|
                    List.map (viewSearchableOption key fieldType) filteredOptions
                ]
            ]
        ]


viewSearchableOption : String -> FieldType.FieldType -> Option.Option -> Html.Html Msg.Msg
viewSearchableOption key fieldType option =
    Html.div
        [ HtmlAttributes.class "dropdown-item mr-2"
        , HtmlEvents.onClick <| Msg.UpdateSelectedDropdownValue fieldType key option.value
        ]
        [ Html.p [ HtmlAttributes.class "is-clickable" ] [ Html.text (option.label |> Maybe.withDefault option.value) ]
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
