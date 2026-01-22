module Form.View.Input exposing (view)

{-| View Input.


# Input

@docs view

-}

import Accessibility.Aria as Aria
import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.Required as Required
import Form.Field.Width as Width
import Form.Fields as Fields
import Form.Format.Markdown as Markdown
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
view : Time.Posix -> Bool -> Locale.Locale -> Fields.Fields -> String -> Field.Field -> Html.Html Msg.Msg
view time submitted locale fields key field =
    let
        disabled =
            not (Fields.isEnabled fields field)

        shown =
            Fields.isShown fields field
    in
    HtmlExtra.viewIf shown <|
        Html.div
            [ HtmlAttributes.class "form-input control"
            , HtmlAttributes.classList [ ( "is-disabled", disabled ) ]
            , HtmlAttributes.class (Width.toStyle (Field.getProperties field).width)
            ]
            [ label key field disabled
            , labelExtraContent field
            , control time locale disabled key field
            , error submitted locale fields field
            ]


label : String -> Field.Field -> Bool -> Html.Html Msg.Msg
label key field disabled =
    HtmlExtra.viewIf (not (Field.isCheckbox field)) <|
        (if Field.isSpanLabel field then
            Html.span
                [ HtmlAttributes.class "label"
                , HtmlAttributes.id key
                ]

         else
            Html.label
                [ HtmlAttributes.class "label"
                , HtmlAttributes.for key
                ]
        )
            [ Html.text (Field.getLabel field)
            , HtmlExtra.viewIf (not (Field.isRequired field == Required.Yes) && not disabled) <|
                Html.em [] [ Html.text " - optional" ]
            ]


labelExtraContent : Field.Field -> Html.Html Msg.Msg
labelExtraContent field =
    HtmlExtra.viewMaybe
        (\text ->
            Html.div
                [ HtmlAttributes.class "pb-2"
                ]
                (Markdown.toHtml text)
        )
        (Field.getLabelExtraContent field)


control : Time.Posix -> Locale.Locale -> Bool -> String -> Field.Field -> Html.Html Msg.Msg
control time (Locale.Locale _ code) disabled key field =
    case field of
        Field.StringField_ (Field.SimpleField properties) ->
            case properties.tipe of
                FieldType.Phone ->
                    phone time code disabled key field

                FieldType.TextArea ->
                    textarea key properties disabled

                _ ->
                    input time (Just code) disabled key field

        Field.StringField_ (Field.DateField _) ->
            input time (Just code) disabled key field

        Field.StringField_ (Field.SelectField properties) ->
            Select.select key properties disabled

        Field.StringField_ (Field.SearchableSelectField properties) ->
            Select.searchableSelect key properties disabled

        Field.StringField_ (Field.HttpSelectField properties) ->
            Select.httpSelect key properties disabled

        Field.StringField_ (Field.HttpSearchableSelectField properties) ->
            Select.httpSearchableSelect key properties disabled

        Field.StringField_ (Field.RadioField properties) ->
            Radio.radio key properties disabled

        Field.MultiStringField_ (Field.MultiSelectField properties) ->
            MultiSelect.multiSelect key properties disabled

        Field.MultiStringField_ (Field.SearchableMultiSelectField properties) ->
            MultiSelect.searchableMultiSelect key properties disabled

        Field.MultiStringField_ (Field.MultiHttpSelectField properties) ->
            MultiSelect.multiHttpSelect key properties disabled

        Field.MultiStringField_ (Field.TagField _) ->
            input time Nothing disabled key field

        Field.BoolField_ (Field.CheckboxField properties) ->
            checkbox key properties disabled

        Field.BoolField_ (Field.RadioBoolField properties) ->
            Radio.radioBool key properties disabled

        Field.BoolField_ (Field.RadioEnumField properties) ->
            Radio.radioEnum key properties disabled

        Field.IntegerField_ (Field.IntegerField _) ->
            input time Nothing disabled key field


input : Time.Posix -> Maybe CountryCode.CountryCode -> Bool -> String -> Field.Field -> Html.Html Msg.Msg
input time code disabled key field =
    let
        renderInput fieldType properties =
            Html.input
                [ HtmlAttributes.id key
                , HtmlAttributes.name key
                , HtmlAttributes.disabled disabled
                , HtmlAttributes.class (FieldType.toClass fieldType)
                , HtmlAttributes.type_ (FieldType.toType fieldType)
                , HtmlAttributes.value properties.value
                , HtmlAttributes.required (properties.required == Required.Yes)
                , HtmlAttributes.placeholder (Placeholder.toPlaceholder fieldType code)
                , HtmlEvents.onInput <| Msg.UpdateStringField key
                , HtmlAttributesExtra.attributeMaybe (HtmlAttributes.attribute "autocomplete") (FieldType.toAutoComplete fieldType)
                , HtmlAttributesExtra.attributeMaybe HtmlAttributes.min (FieldType.toMin time fieldType)
                , HtmlAttributesExtra.attributeMaybe HtmlAttributes.max (FieldType.toMax time fieldType)
                , HtmlAttributesExtra.attributeMaybe HtmlAttributes.maxlength (FieldType.toMaxLength fieldType)
                ]
                []
    in
    case field of
        Field.StringField_ (Field.SimpleField properties) ->
            let
                fieldType =
                    FieldType.StringType (FieldType.SimpleType properties.tipe)
            in
            renderInput fieldType properties

        Field.StringField_ (Field.DateField properties) ->
            let
                fieldType =
                    FieldType.StringType (FieldType.DateType properties.tipe)
            in
            renderInput fieldType properties

        Field.IntegerField_ (Field.IntegerField properties) ->
            Html.input
                [ HtmlAttributes.id key
                , HtmlAttributes.name key
                , HtmlAttributes.disabled disabled
                , HtmlAttributes.class "input"
                , HtmlAttributes.type_ "number"
                , HtmlAttributes.pattern "\\d*"
                , HtmlAttributes.style "width" "6em"
                , HtmlAttributes.value (LibString.fromMaybeInt properties.value)
                , HtmlAttributes.required (properties.required == Required.Yes)
                , HtmlEvents.onInput <| Msg.UpdateIntegerField key
                , HtmlAttributesExtra.attributeMaybe HtmlAttributes.min
                    (FieldType.toMin time (FieldType.IntegerType properties.tipe))
                , HtmlAttributesExtra.attributeMaybe HtmlAttributes.max
                    (FieldType.toMax time (FieldType.IntegerType properties.tipe))
                ]
                []

        Field.MultiStringField_ (Field.TagField properties) ->
            tag key properties disabled

        _ ->
            HtmlExtra.nothing


textarea : String -> Field.SimpleFieldProperties -> Bool -> Html.Html Msg.Msg
textarea key field disabled =
    Html.textarea
        [ HtmlAttributes.id key
        , HtmlAttributes.name key
        , HtmlAttributes.disabled disabled
        , HtmlAttributes.class "textarea"
        , HtmlAttributes.value field.value
        , HtmlAttributes.required (field.required == Required.Yes)
        , HtmlAttributes.placeholder (Placeholder.toPlaceholder (FieldType.StringType (FieldType.SimpleType field.tipe)) Nothing)
        , HtmlEvents.onInput <| Msg.UpdateStringField key
        ]
        []


tag : String -> Field.TagFieldProperties -> Bool -> Html.Html Msg.Msg
tag key field disabled =
    let
        addMsg : Msg.Msg
        addMsg =
            Msg.UpdateTags key field.inputBar True
    in
    Html.div []
        [ Html.div [ HtmlAttributes.class "field has-addons" ]
            [ Html.p [ HtmlAttributes.class "control is-expanded" ]
                [ Html.input
                    [ HtmlAttributes.id key
                    , HtmlAttributes.name key
                    , HtmlAttributes.disabled disabled
                    , HtmlAttributes.class "input"
                    , HtmlAttributes.placeholder (Maybe.withDefault "" field.placeholder)
                    , HtmlEvents.onInput (Msg.UpdateTagInput key)
                    , LibEvents.onEnter (Msg.UpdateTags key field.inputBar True)
                    , HtmlAttributes.value field.inputBar
                    ]
                    []
                ]
            , Html.p [ HtmlAttributes.class "control" ]
                [ Html.button
                    [ HtmlAttributes.class "button is-link"
                    , HtmlAttributes.disabled disabled
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
                        , Aria.label <| "Delete " ++ t ++ " Tag"
                        , HtmlEvents.onClick (Msg.UpdateTags key t False)
                        ]
                        []
                    ]
            )
            (Set.toList tags)
        )


phone : Time.Posix -> CountryCode.CountryCode -> Bool -> String -> Field.Field -> Html.Html Msg.Msg
phone time code disabled key field =
    Html.div [ HtmlAttributes.class "field mb-0 has-addons" ]
        [ Html.p [ HtmlAttributes.class "control" ]
            [ Html.span [ HtmlAttributes.class "button is-static" ] [ Html.text (Phone.phonePrefix code) ] ]
        , Html.p [ HtmlAttributes.class "control is-expanded" ]
            [ input time (Just code) disabled key field ]
        ]


checkbox : String -> Field.BoolFieldProperties a -> Bool -> Html.Html Msg.Msg
checkbox key field disabled =
    let
        toggledValue =
            not field.value
    in
    Html.div [ HtmlAttributes.class "control" ]
        [ Html.label [ HtmlAttributes.class "checkbox is-flex is-align-items-start" ]
            [ Html.input
                [ HtmlAttributes.class "mt-1 mr-3"
                , HtmlAttributes.disabled disabled
                , HtmlAttributes.type_ "checkbox"
                , HtmlAttributes.checked field.value
                , HtmlEvents.onClick <| Msg.UpdateBoolField key toggledValue
                ]
                []
            , Html.div [] (Markdown.toHtml field.label)
            ]
        ]


error : Bool -> Locale.Locale -> Fields.Fields -> Field.Field -> Html.Html Msg.Msg
error submitted locale fields field =
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
            (Html.text << Validate.errorToMessage locale)
            (always HtmlExtra.nothing)
