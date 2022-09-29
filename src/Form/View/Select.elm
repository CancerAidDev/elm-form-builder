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
select : String -> Field.SelectFieldProperties -> Html.Html Msg.Msg
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
