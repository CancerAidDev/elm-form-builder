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


{-| -}
radio : String -> Field.RadioFieldProperties -> Html.Html Msg.Msg
radio key properties =
    radioContainer (List.map (viewRadioOption key properties) properties.options)


viewRadioOption : String -> Field.RadioFieldProperties -> Option.Option -> Html.Html Msg.Msg
viewRadioOption key { default, direction, value } option =
    let
        checked =
            (value == "" && default == Just option.value) || (value == option.value)
    in
    optionLabel direction
        [ Html.input
            [ HtmlAttributes.class "mx-2"
            , HtmlAttributes.type_ "radio"
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
    radioContainer (List.map (viewRadioBoolOption key properties) [ True, False ])


viewRadioBoolOption : String -> Field.RadioBoolFieldProperties -> Bool -> Html.Html Msg.Msg
viewRadioBoolOption key { value } option =
    let
        checked =
            value == Just option
    in
    optionLabel Direction.Column
        [ Html.input
            [ HtmlAttributes.class "mx-2"
            , HtmlAttributes.type_ "radio"
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
    radioContainer (List.map (viewRadioEnumOption key properties) properties.options)


viewRadioEnumOption : String -> Field.RadioEnumFieldProperties -> RadioEnum.Value -> Html.Html Msg.Msg
viewRadioEnumOption key { default, value } option =
    let
        checked =
            (value == Nothing && default == Just option) || (value == Just option)
    in
    optionLabel Direction.Column
        [ Html.input
            [ HtmlAttributes.class "mx-2"
            , HtmlAttributes.type_ "radio"
            , HtmlAttributes.id (key ++ "_" ++ RadioEnum.toString option)
            , HtmlAttributes.name key
            , HtmlEvents.onClick <| Msg.UpdateRadioEnumField key option
            , HtmlAttributesExtra.attributeIf checked (HtmlAttributes.checked True)
            ]
            []
        , Html.text (RadioEnum.toString option)
        ]


radioContainer : List (Html.Html Msg.Msg) -> Html.Html Msg.Msg
radioContainer children =
    Html.div [ HtmlAttributes.class "field" ]
        [ Html.div [ HtmlAttributes.class "control columns is-gapless is-multiline" ]
            children
        ]


optionLabel : Direction.Direction -> List (Html.Html Msg.Msg) -> Html.Html Msg.Msg
optionLabel direction =
    Html.label
        [ HtmlAttributes.class "radio my-2"
        , HtmlAttributes.classList
            [ ( "column", True )
            , ( "is-12", direction == Direction.Row )
            , ( "is-4", direction == Direction.Column )
            ]
        ]
