module Form.View.Dropdown exposing (dropdownIcon, filteredOptions, overlay, searchBar)

import Form.Field.FieldType as FieldType
import Form.Field.Option as Option
import Form.Lib.Events as LibEvents
import Form.Msg as Msg
import Html
import Html.Attributes as HtmlAttributes
import Html.Events as HtmlEvents
import Set


overlay : FieldType.FieldType -> String -> Html.Html Msg.Msg
overlay fieldType key =
    Html.div
        [ HtmlAttributes.style "position" "fixed"
        , HtmlAttributes.style "width" "100%"
        , HtmlAttributes.style "height" "100%"
        , HtmlAttributes.style "left" "0"
        , HtmlAttributes.style "top" "0"
        , HtmlAttributes.style "z-index" "1"
        , HtmlEvents.onClick <| Msg.UpdateShowDropdown fieldType key False
        ]
        []


filteredOptions : String -> List Option.Option -> List Option.Option
filteredOptions searchString options =
    let
        caseInsensitiveContains : String -> String -> Bool
        caseInsensitiveContains s1 s2 =
            String.contains (String.toLower s1) (String.toLower s2)

        takeOption : Option.Option -> Bool
        takeOption option =
            List.any (caseInsensitiveContains searchString) (option.value :: List.filterMap identity [ option.label ])
    in
    List.filter takeOption options


searchBar : FieldType.FieldType -> String -> String -> Set.Set String -> List Option.Option -> Html.Html Msg.Msg
searchBar fieldType key searchInput values options =
    Html.div [ HtmlAttributes.class "dropdown-item" ]
        [ Html.div [ HtmlAttributes.class "field" ]
            [ Html.span [ HtmlAttributes.class "control" ]
                [ Html.input
                    ([ HtmlAttributes.class "input is-small"
                     , HtmlAttributes.placeholder "Search"
                     , HtmlEvents.onInput <| Msg.UpdateSearchbar fieldType key
                     , HtmlAttributes.value searchInput
                     ]
                        ++ (case options of
                                [] ->
                                    []

                                headoption :: _ ->
                                    [ LibEvents.onEnter <|
                                        Msg.UpdateMultiStringField key headoption <|
                                            not <|
                                                Set.member headoption.value values
                                    ]
                           )
                    )
                    []
                ]
            ]
        ]


dropdownIcon : Bool -> Html.Html Msg.Msg
dropdownIcon showDropdown =
    Html.span
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
