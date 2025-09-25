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
radio : String -> Field.RadioFieldProperties -> Bool -> Html.Html Msg.Msg
radio key properties disabled =
    radioContainer (List.map (viewRadioOption key properties disabled) properties.options)


viewRadioOption : String -> Field.RadioFieldProperties -> Bool -> Option.Option -> Html.Html Msg.Msg
viewRadioOption key { default, direction, value, disabled, hidden } enabledByDisabled option =
    let
        checked =
            (value == "" && default == Just option.value) || (value == option.value)
    in
    HtmlExtra.viewIf (not hidden) <|
        optionLabel direction
            [ Html.input
                [ HtmlAttributes.class "mx-2"
                , HtmlAttributes.type_ "radio"
                , HtmlAttributes.disabled (disabled || enabledByDisabled)
                , HtmlAttributes.id (key ++ "_" ++ option.value)
                , HtmlAttributes.name key
                , HtmlEvents.onClick <| Msg.UpdateRadioStringField key option
                , HtmlAttributesExtra.attributeIf checked (HtmlAttributes.checked True)
                ]
                []
            , Html.text (Maybe.withDefault option.value option.label)
            ]


{-| -}
radioBool : String -> Field.RadioBoolFieldProperties -> Bool -> Html.Html Msg.Msg
radioBool key properties disabled =
    radioContainer (List.map (viewRadioBoolOption key properties disabled) [ True, False ])


viewRadioBoolOption : String -> Field.RadioBoolFieldProperties -> Bool -> Bool -> Html.Html Msg.Msg
viewRadioBoolOption key { value, disabled, hidden } enabledByDisabled option =
    let
        checked =
            value == Just option
    in
    HtmlExtra.viewIf (not hidden) <|
        optionLabel Direction.Column
            [ Html.input
                [ HtmlAttributes.class "mx-2"
                , HtmlAttributes.type_ "radio"
                , HtmlAttributes.disabled (disabled || enabledByDisabled)
                , HtmlAttributes.id (key ++ "_" ++ RadioBool.toString option)
                , HtmlAttributes.name key
                , HtmlEvents.onClick <| Msg.UpdateRadioBoolField key option
                , HtmlAttributesExtra.attributeIf checked (HtmlAttributes.checked True)
                ]
                []
            , Html.text (RadioBool.toString option)
            ]


{-| -}
radioEnum : String -> Field.RadioEnumFieldProperties -> Bool -> Html.Html Msg.Msg
radioEnum key properties disabled =
    radioContainer (List.map (viewRadioEnumOption key properties disabled) properties.options)


viewRadioEnumOption : String -> Field.RadioEnumFieldProperties -> Bool -> RadioEnum.Value -> Html.Html Msg.Msg
viewRadioEnumOption key { default, value, disabled, hidden } enabledByDisabled option =
    let
        checked =
            (value == Nothing && default == Just option) || (value == Just option)
    in
    HtmlExtra.viewIf (not hidden) <|
        optionLabel Direction.Column
            [ Html.input
                [ HtmlAttributes.class "mx-2"
                , HtmlAttributes.type_ "radio"
                , HtmlAttributes.disabled (disabled || enabledByDisabled)
                , HtmlAttributes.id (key ++ "_" ++ RadioEnum.toString option)
                , HtmlAttributes.name key
                , HtmlEvents.onClick <| Msg.UpdateRadioEnumField key option
                , HtmlAttributesExtra.attributeIf checked (HtmlAttributes.checked True)
                ]
                []
            , Html.text (RadioEnum.toString option)
            ]


radioContainer : List (Html.Html Msg.Msg) -> Html.Html Msg.Msg
radioContainer =
    Html.div
        [ HtmlAttributes.class "control columns is-gapless is-multiline m-0"
        ]


optionLabel : Direction.Direction -> List (Html.Html Msg.Msg) -> Html.Html Msg.Msg
optionLabel direction =
    Html.label
        [ HtmlAttributes.class "radio column my-2"
        , HtmlAttributes.class <|
            case direction of
                Direction.Row ->
                    "is-12"

                Direction.Column ->
                    "is-4"
        ]
