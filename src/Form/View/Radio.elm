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
    Html.div
        [ HtmlAttributes.class "control" ]
        (List.map (viewOption key properties) properties.options)


{-| -}
radioBool : String -> Field.RadioBoolFieldProperties -> Html.Html Msg.Msg
radioBool key properties =
    radio key
        { required = properties.required
        , label = properties.label
        , width = properties.width
        , enabledBy = properties.enabledBy
        , order = properties.order
        , value = ""
        , default = Nothing
        , options = List.map (\value -> { value = RadioBool.toString value, label = Nothing }) properties.options
        , direction = Direction.Column
        }


{-| -}
radioEnum : String -> Field.RadioEnumFieldProperties -> Html.Html Msg.Msg
radioEnum key properties =
    radio key
        { required = properties.required
        , label = properties.label
        , width = properties.width
        , enabledBy = properties.enabledBy
        , order = properties.order
        , value = ""
        , default = Nothing
        , options = List.map (\value -> { value = RadioEnum.toString value, label = Nothing }) properties.options
        , direction = Direction.Column
        }


viewOption : String -> Field.RadioFieldProperties -> Option.Option -> Html.Html Msg.Msg
viewOption key { default, value } option =
    let
        checked =
            (value == "" && default == Just option.value) || (value == option.value)
    in
    Html.label [ HtmlAttributes.class "radio" ]
        [ Html.input
            [ HtmlAttributes.class "mx-1 mt-2"
            , HtmlAttributes.type_ "radio"
            , HtmlAttributes.id (key ++ "_" ++ option.value)
            , HtmlAttributes.name key
            , HtmlEvents.onClick <| Msg.UpdateRadioStringField key option
            , HtmlAttributesExtra.attributeIf checked (HtmlAttributes.checked True)
            ]
            []
        , Html.text (Maybe.withDefault option.value option.label)
        ]
