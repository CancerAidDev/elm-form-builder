module Form.View.Radio exposing (radio, radioBool, radioEnum)

{-| View Radio Fields


# Radio

@docs radio, radioBool, radioEnum

-}

import Form.Field as Field
import Form.Field.Direction as Direction
import Form.Field.Option as Option
import Form.Field.RadioBool as RadioBool
import Form.Field.RadioEnum as RadioEnum
import Form.Msg as Msg
import Html
import Html.Attributes as HtmlAttributes
import Html.Attributes.Extra as HtmlAttributesExtra
import Html.Events as HtmlEvents
import Html.Extra as HtmlExtra


{-| -}
radio : String -> Field.RadioFieldProperties -> Html.Html Msg.Msg
radio key properties =
    radioContainer properties.direction (List.map (viewRadioOption key properties) properties.options)


viewRadioOption : String -> Field.RadioFieldProperties -> Option.Option -> Html.Html Msg.Msg
viewRadioOption key { default, value, disabled, hidden } option =
    let
        checked =
            (value == "" && default == Just option.value) || (value == option.value)
    in
    HtmlExtra.viewIf (not hidden) <|
        optionLabel
            [ Html.input
                [ HtmlAttributes.class "mx-2"
                , HtmlAttributes.type_ "radio"
                , HtmlAttributes.disabled disabled
                , HtmlAttributes.id (key ++ "_" ++ option.value)
                , HtmlAttributes.name key
                , HtmlEvents.onClick <| Msg.UpdateRadioStringField key option
                , HtmlAttributesExtra.attributeIf checked (HtmlAttributes.checked True)
                ]
                []
            , Html.text (Maybe.withDefault option.value option.label)
            ]


{-| -}
radioBool : String -> Field.RadioBoolFieldProperties -> Html.Html Msg.Msg
radioBool key properties =
    radioContainer Direction.Column (List.map (viewRadioBoolOption key properties) [ True, False ])


viewRadioBoolOption : String -> Field.RadioBoolFieldProperties -> Bool -> Html.Html Msg.Msg
viewRadioBoolOption key { value, disabled, hidden } option =
    let
        checked =
            value == Just option
    in
    HtmlExtra.viewIf (not hidden) <|
        optionLabel
            [ Html.input
                [ HtmlAttributes.class "mx-2"
                , HtmlAttributes.type_ "radio"
                , HtmlAttributes.disabled disabled
                , HtmlAttributes.id (key ++ "_" ++ RadioBool.toString option)
                , HtmlAttributes.name key
                , HtmlEvents.onClick <| Msg.UpdateRadioBoolField key option
                , HtmlAttributesExtra.attributeIf checked (HtmlAttributes.checked True)
                ]
                []
            , Html.text (RadioBool.toString option)
            ]


{-| -}
radioEnum : String -> Field.RadioEnumFieldProperties -> Html.Html Msg.Msg
radioEnum key properties =
    radioContainer Direction.Column (List.map (viewRadioEnumOption key properties) properties.options)


viewRadioEnumOption : String -> Field.RadioEnumFieldProperties -> RadioEnum.Value -> Html.Html Msg.Msg
viewRadioEnumOption key { default, value, disabled, hidden } option =
    let
        checked =
            (value == Nothing && default == Just option) || (value == Just option)
    in
    HtmlExtra.viewIf (not hidden) <|
        optionLabel
            [ Html.input
                [ HtmlAttributes.class "mx-2"
                , HtmlAttributes.type_ "radio"
                , HtmlAttributes.disabled disabled
                , HtmlAttributes.id (key ++ "_" ++ RadioEnum.toString option)
                , HtmlAttributes.name key
                , HtmlEvents.onClick <| Msg.UpdateRadioEnumField key option
                , HtmlAttributesExtra.attributeIf checked (HtmlAttributes.checked True)
                ]
                []
            , Html.text (RadioEnum.toString option)
            ]


radioContainer : Direction.Direction -> List (Html.Html Msg.Msg) -> Html.Html Msg.Msg
radioContainer direction children =
    case direction of
        Direction.Column ->
            Html.div [ HtmlAttributes.class "fixed-grid has-3-cols" ]
                [ Html.div [ HtmlAttributes.class "control grid" ] children ]

        Direction.Row ->
            Html.div [ HtmlAttributes.class "control is-flex is-flex-direction-column is-align-content-start" ]
                children


optionLabel : List (Html.Html Msg.Msg) -> Html.Html Msg.Msg
optionLabel =
    Html.label [ HtmlAttributes.class "radio cell my-2" ]
