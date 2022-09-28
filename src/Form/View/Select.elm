module Form.View.Select exposing (select, httpSelect)

{-| View Select Fields


# Select

@docs select, httpSelect

-}

import Form.Field as Field
import Form.Field.Option as Select
import Form.Field.Required as Required
import Form.Msg as Msg
import Html
import Html.Attributes as HtmlAttributes
import Html.Events as HtmlEvents
import Html.Extra as HtmlExtra
import RemoteData


{-| -}
select : String -> String -> Field.SelectFieldProperties -> Html.Html Msg.Msg
select empty key { value, required, options, disabled, hidden, hasEmptyOption, placeholder } =
    HtmlExtra.viewIf (not hidden) <|
        Html.div [ HtmlAttributes.class "select is-fullwidth" ]
            [ Html.select
                [ HtmlAttributes.name key
                , HtmlAttributes.required (required == Required.Yes)
                , HtmlAttributes.disabled disabled
                , HtmlEvents.onInput <| Msg.UpdateStringField key
                ]
                (if hasEmptyOption == Just True then
                    emptyOption empty :: List.map (viewOption value) options

                 else
                    viewPlaceholder (Maybe.withDefault "" placeholder) :: List.map (viewOption value) options
                )
            ]


viewPlaceholder : String -> Html.Html Msg.Msg
viewPlaceholder placeholder =
    Html.option
        [ HtmlAttributes.value ""
        , HtmlAttributes.disabled True
        , HtmlAttributes.selected True
        , HtmlAttributes.hidden True
        ]
        [ Html.text placeholder ]


emptyOption : String -> Html.Html Msg.Msg
emptyOption empty =
    Html.option
        [ HtmlAttributes.value empty ]
        [ Html.text empty ]


viewOption : String -> Select.Option -> Html.Html Msg.Msg
viewOption selectedValue option =
    Html.option
        [ HtmlAttributes.value option.value
        , HtmlAttributes.selected <| option.value == selectedValue
        ]
        [ Html.text (option.label |> Maybe.withDefault option.value) ]


{-| -}
httpSelect : String -> Field.HttpSelectFieldProperties -> Html.Html Msg.Msg
httpSelect key properties =
    RemoteData.map
        (\options ->
            select ""
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
                , hasEmptyOption = properties.hasEmptyOption
                , placeholder = properties.placeholder
                }
        )
        properties.options
        |> RemoteData.withDefault HtmlExtra.nothing
