module Form.View.Select exposing (select, httpSelect)

{-| View Select Fields


# Select

@docs select, httpSelect

-}

import Form.Field as Field
import Form.Field.Option as Select
import Form.Msg as Msg
import Html
import Html.Attributes as HtmlAttributes
import Html.Events as HtmlEvents
import Html.Extra as HtmlExtra
import RemoteData


{-| -}
select : String -> Field.SelectFieldProperties -> Html.Html Msg.Msg
select key { value, required, options, disabled } =
    Html.div [ HtmlAttributes.class "select is-fullwidth" ]
        [ Html.select
            [ HtmlAttributes.name key
            , HtmlAttributes.required required
            , HtmlAttributes.disabled disabled
            , HtmlEvents.onInput <| Msg.UpdateStringField key
            ]
            (emptyOption :: List.map (viewOption value) options)
        ]


emptyOption : Html.Html Msg.Msg
emptyOption =
    Html.option
        [ HtmlAttributes.value "" ]
        [ Html.text "" ]


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
            select key
                { value = properties.value
                , required = properties.required
                , default = properties.default
                , options = options
                , label = properties.label
                , width = properties.width
                , enabledBy = properties.enabledBy
                , order = properties.order
                , disabled = properties.disabled
                , nullable = False
                }
        )
        properties.options
        |> RemoteData.withDefault HtmlExtra.nothing
