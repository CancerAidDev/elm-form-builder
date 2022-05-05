module Form.View.Select exposing (httpSelect, select)

import Form.Msg as Msg
import Form.Types.Field as Field
import Form.Types.Option as Select
import Html
import Html.Attributes as HtmlAttributes
import Html.Events as HtmlEvents
import Html.Extra as HtmlExtra
import RemoteData


select : String -> Field.SelectFieldProperties -> Html.Html Msg.Msg
select key { value, required, options } =
    Html.select
        [ HtmlAttributes.name key
        , HtmlAttributes.required required
        , HtmlEvents.onInput <| Msg.UpdateStringField key
        ]
        (emptyOption :: List.map (viewOption value) options)


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
                }
        )
        properties.options
        |> RemoteData.withDefault HtmlExtra.nothing
