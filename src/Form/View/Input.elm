module Form.View.Input exposing (view)

{-| View Input.


# Input

@docs view

-}

import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.Required as Required
import Form.Field.Width as Width
import Form.Fields as Fields
import Form.Lib.Events as LibEvents
import Form.Lib.String as LibString
import Form.Locale as Locale
import Form.Locale.CountryCode as CountryCode
import Form.Locale.Phone as Phone
import Form.Msg as Msg
import Form.Placeholder.Placeholder as Placeholder
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
import Set
import Time


{-| -}
view : Time.Posix -> Bool -> Fields.Fields -> String -> Field.Field -> Html.Html Msg.Msg
view time submitted fields key field =
    let
        disabled =
            not (Fields.isEnabled fields field)

        shown =
            Fields.isShown fields field
    in
    HtmlExtra.viewIf shown <|
        Html.fieldset
            [ HtmlAttributes.class "column"
            , HtmlAttributes.class <| Width.toStyle (Field.getProperties field).width
            , HtmlAttributes.disabled disabled
            , HtmlAttributes.id key
            ]
            [ Html.div [ HtmlAttributes.class "field" ]
                [ label field disabled shown
                , control time key field
                , error submitted fields field
                ]
            ]


label : Field.Field -> Bool -> Bool -> Html.Html Msg.Msg
label field disabled shown =
    HtmlExtra.viewIf (not (Field.isCheckbox field) && shown) <|
        Html.label [ HtmlAttributes.class "label" ]
            [ Html.text (Field.getLabel field)
            , HtmlExtra.viewIf (not (Field.isRequired field == Required.Yes) && not disabled) <|
                Html.em [] [ Html.text " - optional" ]
            ]


control : Time.Posix -> String -> Field.Field -> Html.Html Msg.Msg
control time key field =
    case field of
        Field.StringField_ (Field.SimpleField properties) ->
            case properties.tipe of
                FieldType.TextArea ->
                    textarea key properties

                _ ->
                    input time key field

        Field.StringField_ (Field.PhoneField properties) ->
            phone time properties.locale key field

        Field.StringField_ (Field.DateField _) ->
            input time key field

        Field.StringField_ (Field.SelectField properties) ->
            Select.select key properties

        Field.StringField_ (Field.SearchableSelectField _) ->
            Select.searchableSelect key field

        Field.StringField_ (Field.HttpSelectField properties) ->
            Select.httpSelect key properties

        Field.StringField_ (Field.RadioField properties) ->
            Radio.radio key properties

        Field.MultiStringField_ (Field.MultiSelectField properties) ->
            MultiSelect.multiSelect key properties

        Field.MultiStringField_ (Field.SearchableMultiSelectField properties) ->
            MultiSelect.searchableMultiSelect key properties

        Field.MultiStringField_ (Field.MultiHttpSelectField properties) ->
            MultiSelect.multiHttpSelect key properties

        Field.MultiStringField_ (Field.TagField _) ->
            input time key field

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
    let
        renderInput fieldType properties attributes =
            Html.input
                ([ HtmlAttributes.name key
                 , HtmlAttributes.class (FieldType.toClass fieldType)
                 , HtmlAttributes.type_ (FieldType.toType fieldType)
                 , HtmlAttributes.value properties.value
                 , HtmlAttributes.required (properties.required == Required.Yes)
                 , HtmlAttributes.placeholder (Placeholder.toPlaceholder field)
                 , HtmlEvents.onInput <| Msg.UpdateStringField key
                 , HtmlAttributesExtra.attributeMaybe HtmlAttributes.min (FieldType.toMin time fieldType)
                 , HtmlAttributesExtra.attributeMaybe HtmlAttributes.max (FieldType.toMax time fieldType)
                 , HtmlAttributesExtra.attributeMaybe HtmlAttributes.maxlength (FieldType.toMaxLength fieldType)
                 ]
                    ++ attributes
                )
                []
    in
    case field of
        Field.StringField_ (Field.SimpleField properties) ->
            let
                fieldType =
                    FieldType.StringType (FieldType.SimpleType properties.tipe)
            in
            renderInput fieldType properties []

        Field.StringField_ (Field.PhoneField properties) ->
            let
                fieldType =
                    FieldType.StringType FieldType.Phone
            in
            case properties.locale of
                Nothing ->
                    renderInput fieldType
                        properties
                        [ HtmlAttributes.id <|
                            "phoneWithoutLocale"
                                ++ (case Field.getCode field of
                                        Nothing ->
                                            ""

                                        Just c ->
                                            "-" ++ CountryCode.toString c
                                   )
                        ]

                _ ->
                    renderInput fieldType properties []

        Field.StringField_ (Field.DateField properties) ->
            let
                fieldType =
                    FieldType.StringType (FieldType.DateType properties.tipe)
            in
            renderInput fieldType properties []

        Field.NumericField_ (Field.AgeField properties) ->
            Html.input
                [ HtmlAttributes.name key
                , HtmlAttributes.class "input"
                , HtmlAttributes.type_ "number"
                , HtmlAttributes.pattern "\\d*"
                , HtmlAttributes.style "width" "6em"
                , HtmlAttributes.value (LibString.fromMaybeInt properties.value)
                , HtmlAttributes.required (properties.required == Required.Yes)
                , HtmlEvents.onInput <| Msg.UpdateNumericField key
                , HtmlAttributesExtra.attributeMaybe HtmlAttributes.min
                    (FieldType.toMin time (FieldType.NumericType FieldType.Age))
                , HtmlAttributesExtra.attributeMaybe HtmlAttributes.max
                    (FieldType.toMax time (FieldType.NumericType FieldType.Age))
                ]
                []

        Field.MultiStringField_ (Field.TagField properties) ->
            tag key properties

        _ ->
            HtmlExtra.nothing


textarea : String -> Field.SimpleFieldProperties -> Html.Html Msg.Msg
textarea key field =
    Html.textarea
        [ HtmlAttributes.name key
        , HtmlAttributes.class "textarea"
        , HtmlAttributes.value field.value
        , HtmlAttributes.required (field.required == Required.Yes)
        , HtmlAttributes.placeholder (Placeholder.toPlaceholder (Field.StringField_ (Field.SimpleField field)))
        , HtmlEvents.onInput <| Msg.UpdateStringField key
        ]
        []


tag : String -> Field.TagFieldProperties -> Html.Html Msg.Msg
tag key field =
    let
        addMsg : Msg.Msg
        addMsg =
            Msg.UpdateTags key field.inputBar True
    in
    Html.div []
        [ Html.div [ HtmlAttributes.class "field has-addons" ]
            [ Html.p [ HtmlAttributes.class "control is-expanded" ]
                [ Html.input
                    [ HtmlAttributes.name key
                    , HtmlAttributes.class "input"
                    , HtmlAttributes.placeholder (Maybe.withDefault "" field.placeholder)
                    , HtmlEvents.onInput (Msg.UpdateTagInput key)
                    , LibEvents.onEnter (Msg.UpdateTags key field.inputBar True)
                    , HtmlAttributes.value field.inputBar
                    ]
                    []
                ]
            , Html.p [ HtmlAttributes.class "control" ]
                [ Html.a
                    [ HtmlAttributes.class "button is-link"
                    , HtmlEvents.onClick addMsg
                    ]
                    [ Html.text "Add" ]
                ]
            ]
        , viewTags key field.value
        ]


viewTags : String -> Set.Set String -> Html.Html Msg.Msg
viewTags key tags =
    Html.div []
        (List.map
            (\t ->
                Html.span [ HtmlAttributes.class "tag is-link mr-1" ]
                    [ Html.text t
                    , Html.button
                        [ HtmlAttributes.class "delete is-small"
                        , HtmlEvents.onClick (Msg.UpdateTags key t False)
                        ]
                        []
                    ]
            )
            (Set.toList tags)
        )


phone : Time.Posix -> Maybe Locale.Locale -> String -> Field.Field -> Html.Html Msg.Msg
phone time locale key field =
    Html.div [ HtmlAttributes.class "field mb-0 has-addons" ]
        [ Html.p [ HtmlAttributes.class "control" ]
            [ case locale of
                Nothing ->
                    case field of
                        Field.StringField_ (Field.PhoneField _) ->
                            Select.searchableSelect key field

                        _ ->
                            Html.text ""

                Just (Locale.Locale _ code) ->
                    Html.a [ HtmlAttributes.class "button is-static" ] [ Html.text (Phone.phonePrefix code) ]
            ]
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


error : Bool -> Fields.Fields -> Field.Field -> Html.Html Msg.Msg
error submitted fields field =
    case field of
        Field.NumericField_ (Field.AgeField properties) ->
            Html.p [ HtmlAttributes.class "help is-danger" ]
                [ if submitted then
                    validateForm fields field

                  else
                    case properties.value of
                        Nothing ->
                            HtmlExtra.nothing

                        Just _ ->
                            validateForm fields field
                ]

        _ ->
            Html.p [ HtmlAttributes.class "help is-danger" ]
                [ if submitted then
                    validateForm fields field

                  else
                    HtmlExtra.nothing
                ]


validateForm : Fields.Fields -> Field.Field -> Html.Html Msg.Msg
validateForm fields field =
    Validate.validateField fields field
        |> ResultExtra.unpack
            (Html.text << Validate.errorToMessage)
            (always HtmlExtra.nothing)
