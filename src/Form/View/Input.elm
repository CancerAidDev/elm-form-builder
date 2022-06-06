module Form.View.Input exposing (view)

{-| View Input.


# Input

@docs view

-}

import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.Width as Width
import Form.Fields as Fields
import Form.Lib.String as LibString
import Form.Locale as Locale
import Form.Locale.Phone as Phone
import Form.Msg as Msg
import Form.Validate as Validate
import Form.View.MultiSelect as MultiSelect
import Form.View.Radio as Radio
import Form.View.Select as Select
import Html
import Html.Attributes as HtmlAttributes
import Html.Attributes.Extra as HtmlAttributesExtra
import Html.Events as HtmlEvents
import Html.Extra as HtmlExtra
import Result.Extra as ResultExtra
import Time


{-| -}
view : Time.Posix -> Bool -> Locale.Locale -> Fields.Fields -> String -> Field.Field -> Html.Html Msg.Msg
view time submitted locale fields key field =
    let
        overrideWithDisbaled =
            (Field.getProperties field).disabled

        disabled =
            not (Fields.isEnabled fields field) || overrideWithDisbaled
    in
    Html.fieldset
        [ HtmlAttributes.class "column"
        , HtmlAttributes.class <| Width.toStyle (Field.getWidth field)
        , HtmlAttributes.disabled disabled
        , HtmlAttributes.id key
        ]
        [ Html.div [ HtmlAttributes.class "field" ]
            [ label field disabled
            , control time locale key field
            , error submitted locale fields field
            ]
        ]


label : Field.Field -> Bool -> Html.Html Msg.Msg
label field disabled =
    HtmlExtra.viewIf (not (Field.isCheckbox field)) <|
        Html.label [ HtmlAttributes.class "label" ]
            [ Html.text (Field.getLabel field)
            , HtmlExtra.viewIf (not (Field.isRequired field) && not disabled) <|
                Html.em [] [ Html.text " - optional" ]
            ]


control : Time.Posix -> Locale.Locale -> String -> Field.Field -> Html.Html Msg.Msg
control time locale key field =
    case field of
        Field.StringField_ (Field.SimpleField properties) ->
            case properties.tipe of
                FieldType.Phone ->
                    phone time locale key field

                FieldType.TextArea ->
                    textarea key properties

                _ ->
                    input time key field

        Field.StringField_ (Field.SelectField properties) ->
            Select.select key properties

        Field.StringField_ (Field.HttpSelectField properties) ->
            Select.httpSelect key properties

        Field.StringField_ (Field.RadioField properties) ->
            Radio.radio key properties

        Field.MultiStringField_ (Field.MultiSelectField properties) ->
            MultiSelect.multiSelect key properties

        Field.MultiStringField_ (Field.MultiHttpSelectField properties) ->
            MultiSelect.multiHttpSelect key properties

        Field.BoolField_ (Field.CheckboxField properties) ->
            checkbox key properties

        Field.BoolField_ (Field.RadioBoolField properties) ->
            Radio.radioBool key properties

        Field.BoolField_ (Field.RadioEnumField properties) ->
            Radio.radioEnum key properties

        Field.NumericField_ (Field.AgeField _) ->
            input time key field


input : Time.Posix -> String -> Field.Field -> Html.Html Msg.Msg
input time key field =
    case field of
        Field.StringField_ (Field.SimpleField properties) ->
            Html.input
                [ HtmlAttributes.name key
                , HtmlAttributes.class (FieldType.toClass properties.tipe)
                , HtmlAttributes.type_ (FieldType.toType properties.tipe)
                , HtmlAttributes.value properties.value
                , HtmlAttributes.required properties.required
                , HtmlAttributes.placeholder (FieldType.toPlaceholder properties.tipe)
                , HtmlEvents.onInput <| Msg.UpdateStringField key
                , HtmlAttributesExtra.attributeMaybe HtmlAttributes.min
                    (FieldType.toMin
                        time
                        (FieldType.StringType (FieldType.SimpleType properties.tipe))
                    )
                , HtmlAttributesExtra.attributeMaybe HtmlAttributes.max
                    (FieldType.toMax
                        time
                        (FieldType.StringType (FieldType.SimpleType properties.tipe))
                    )
                , HtmlAttributesExtra.attributeMaybe HtmlAttributes.maxlength (FieldType.toMaxLength properties.tipe)
                ]
                []

        Field.NumericField_ (Field.AgeField properties) ->
            Html.input
                [ HtmlAttributes.name key
                , HtmlAttributes.class "input"
                , HtmlAttributes.type_ "number"
                , HtmlAttributes.pattern "\\d*"
                , HtmlAttributes.style "width" "6em"
                , HtmlAttributes.value (LibString.fromMaybeInt properties.value)
                , HtmlAttributes.required properties.required
                , HtmlEvents.onInput <| Msg.UpdateNumericField key
                , HtmlAttributesExtra.attributeMaybe HtmlAttributes.min
                    (FieldType.toMin time (FieldType.NumericType FieldType.Age))
                , HtmlAttributesExtra.attributeMaybe HtmlAttributes.max
                    (FieldType.toMax time (FieldType.NumericType FieldType.Age))
                ]
                []

        _ ->
            HtmlExtra.nothing


textarea : String -> Field.SimpleFieldProperties -> Html.Html Msg.Msg
textarea key field =
    Html.textarea
        [ HtmlAttributes.name key
        , HtmlAttributes.class "textarea"
        , HtmlAttributes.value field.value
        , HtmlAttributes.required field.required
        , HtmlAttributes.placeholder (FieldType.toPlaceholder field.tipe)
        , HtmlEvents.onInput <| Msg.UpdateStringField key
        ]
        []


phone : Time.Posix -> Locale.Locale -> String -> Field.Field -> Html.Html Msg.Msg
phone time (Locale.Locale _ countryCode) key field =
    Html.div [ HtmlAttributes.class "field mb-0 has-addons" ]
        [ Html.p [ HtmlAttributes.class "control" ]
            [ Html.a [ HtmlAttributes.class "button is-static" ] [ Html.text (Phone.phonePrefix countryCode) ] ]
        , Html.p [ HtmlAttributes.class "control is-expanded" ]
            [ input time key field ]
        ]


checkbox : String -> Field.BoolFieldProperties a -> Html.Html Msg.Msg
checkbox key field =
    let
        toggledValue =
            not field.value
    in
    Html.div [ HtmlAttributes.class "control" ]
        [ Html.label [ HtmlAttributes.class "checkbox" ]
            [ Html.input
                [ HtmlAttributes.class "mr-3"
                , HtmlAttributes.type_ "checkbox"
                , HtmlAttributes.checked field.value
                , HtmlEvents.onClick <| Msg.UpdateBoolField key toggledValue
                ]
                []
            , Html.text field.label
            ]
        ]


error : Bool -> Locale.Locale -> Fields.Fields -> Field.Field -> Html.Html Msg.Msg
error submitted locale fields field =
    case field of
        Field.NumericField_ (Field.AgeField properties) ->
            Html.p [ HtmlAttributes.class "help is-danger" ]
                [ if submitted then
                    validateForm locale fields field

                  else
                    case properties.value of
                        Nothing ->
                            HtmlExtra.nothing

                        Just _ ->
                            validateForm locale fields field
                ]

        _ ->
            Html.p [ HtmlAttributes.class "help is-danger" ]
                [ if submitted then
                    validateForm locale fields field

                  else
                    HtmlExtra.nothing
                ]


validateForm : Locale.Locale -> Fields.Fields -> Field.Field -> Html.Html Msg.Msg
validateForm locale fields field =
    Validate.validateField locale fields field
        |> ResultExtra.unpack
            (Html.text << Validate.errorToMessage)
            (always HtmlExtra.nothing)
