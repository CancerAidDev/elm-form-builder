module Form.View.Input exposing (view)

import Form.Msg as Msg
import Form.Types.Direction as Direction
import Form.Types.Field as Field
import Form.Types.FieldType as FieldType
import Form.Types.Fields as Fields
import Form.Types.Locale as Locale
import Form.Types.Option as Option
import Form.Types.RadioBool as RadioBool
import Form.Types.RadioEnum as RadioEnum
import Form.Types.Width as Width
import Form.Validate as Validate
import Form.View.Select as Select
import Html
import Html.Attributes as HtmlAttributes
import Html.Attributes.Extra as HtmlAttributesExtra
import Html.Events as HtmlEvents
import Html.Extra as HtmlExtra
import Result.Extra as ResultExtra
import Time


view : Time.Posix -> Bool -> Locale.Locale -> Fields.Fields -> String -> Field.Field -> Html.Html Msg.Msg
view time submitted locale fields key field =
    let
        disabled =
            not (Fields.isEnabled fields field)
    in
    if Field.hasTitle field then
        Html.div
            [ HtmlAttributes.class "column mb-5"
            , HtmlAttributes.class <| Width.toStyle (Field.getWidth field)
            , HtmlAttributes.id key
            ]
            [ Html.fieldset
                [ HtmlAttributes.classList
                    [ ( "is-mobile", Field.isNumericField field )
                    , ( "has-text-grey-lighter", disabled )
                    , ( "columns", Field.isColumn field )
                    ]
                , HtmlAttributes.disabled disabled
                ]
                [ label field disabled
                , Html.div [ HtmlAttributes.class "p-0 is-half column" ]
                    [ control time key field
                    , error submitted locale fields field
                    ]
                ]
            ]

    else
        Html.div
            [ HtmlAttributes.class "column"
            , HtmlAttributes.class <| Width.toStyle (Field.getWidth field)
            , HtmlAttributes.id key
            ]
            [ label field disabled
            , control time key field
            , error submitted locale fields field
            ]


label : Field.Field -> Bool -> Html.Html Msg.Msg
label field disabled =
    let
        isColumn =
            Field.isColumn field
    in
    if Field.hasTitle field then
        Html.label
            [ HtmlAttributes.class "label p-0"
            , HtmlAttributes.classList
                [ ( "has-text-grey-lighter", disabled )
                , ( "column", isColumn )
                , ( "is-half", isColumn )
                ]
            ]
            [ Html.text (Field.getTitle field)
            , HtmlExtra.viewIf (not (Field.isRequired field) && not disabled) <|
                Html.em [] [ Html.text " - optional" ]
            ]

    else
        HtmlExtra.viewIf (not (Field.isCheckbox field)) <|
            Html.label [ HtmlAttributes.class "label" ]
                [ Html.text (Field.getLabel field)
                , HtmlExtra.viewIf (not (Field.isRequired field)) <|
                    Html.em [] [ Html.text " - optional" ]
                ]


control : Time.Posix -> String -> Field.Field -> Html.Html Msg.Msg
control time key field =
    case field of
        Field.StringField_ (Field.SimpleField properties) ->
            case properties.tipe of
                FieldType.Phone ->
                    Html.div [ HtmlAttributes.class "field has-addons" ]
                        [ Html.p [ HtmlAttributes.class "control" ]
                            [ Html.a [ HtmlAttributes.class "button is-static" ] [ Html.text "+61" ] ]
                        , Html.p [ HtmlAttributes.class "control is-expanded" ]
                            [ input time key field ]
                        ]

                FieldType.TextArea ->
                    Html.div [ HtmlAttributes.class "field" ]
                        [ Html.div [ HtmlAttributes.class "control" ]
                            [ textarea key properties ]
                        ]

                _ ->
                    Html.div [ HtmlAttributes.class "field" ]
                        [ Html.div [ HtmlAttributes.class "control" ]
                            [ input time key field ]
                        ]

        Field.StringField_ (Field.SelectField properties) ->
            Html.div [ HtmlAttributes.class "field" ]
                [ Html.div [ HtmlAttributes.class "select is-fullwidth" ]
                    [ Select.select key properties ]
                ]

        Field.StringField_ (Field.HttpSelectField properties) ->
            Html.div [ HtmlAttributes.class "field" ]
                [ Html.div [ HtmlAttributes.class "select is-fullwidth" ]
                    [ Select.httpSelect key properties ]
                ]

        Field.StringField_ (Field.RadioField properties) ->
            Html.div [ HtmlAttributes.class "field column" ]
                [ Html.div [ HtmlAttributes.class "columns is-mobile control" ]
                    (radio [ radioViewExtraDiv properties.direction ] key field)
                ]

        Field.BoolField_ (Field.CheckboxField properties) ->
            Html.div [ HtmlAttributes.class "field" ]
                [ Html.div [ HtmlAttributes.class "control" ]
                    [ checkbox key properties ]
                ]

        Field.BoolField_ (Field.RadioBoolField _) ->
            Html.div [ HtmlAttributes.class "field column" ]
                [ Html.div [ HtmlAttributes.class "columns is-mobile control" ]
                    (radio [ radioViewExtraDiv Direction.Column ] key field)
                ]

        Field.BoolField_ (Field.RadioEnumField _) ->
            Html.div [ HtmlAttributes.class "field column" ]
                [ Html.div [ HtmlAttributes.class "columns is-mobile control" ]
                    (radio [ radioViewExtraDiv Direction.Column ] key field)
                ]

        Field.NumericField_ (Field.NumericField _) ->
            Html.div [ HtmlAttributes.class "field column is-narrow" ]
                [ Html.div [ HtmlAttributes.class "columns is-mobile control" ]
                    [ Html.div [ HtmlAttributes.class "column is-one-third-desktop" ] []
                    , input time key field
                    ]
                ]


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

        Field.NumericField_ (Field.NumericField properties) ->
            Html.input
                [ HtmlAttributes.name key
                , HtmlAttributes.class "input column is-narrow"
                , HtmlAttributes.type_ "number"
                , HtmlAttributes.value (Field.fromInt properties.value)
                , HtmlAttributes.required properties.required
                , HtmlEvents.onInput <| Msg.UpdateNumericField key
                , HtmlAttributesExtra.attributeMaybe HtmlAttributes.min
                    (FieldType.toMin time
                        (FieldType.NumericType properties.tipe)
                    )
                , HtmlAttributesExtra.attributeMaybe HtmlAttributes.max
                    (FieldType.toMax time
                        (FieldType.NumericType properties.tipe)
                    )
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


radioView : Direction.Direction -> Msg.Msg -> Maybe Bool -> Option.Option -> String -> Html.Html Msg.Msg
radioView direction onClick showOrChecked option name =
    let
        attributes =
            case direction of
                Direction.Row ->
                    []

                Direction.Column ->
                    [ ( "is-one-third-desktop", True ), ( "is-3-mobile", True ) ]

        radioState =
            case showOrChecked of
                Nothing ->
                    []

                Just x ->
                    [ HtmlAttributes.checked x ]
    in
    Html.label [ HtmlAttributes.classList ([ ( "p-0", True ), ( "column", True ) ] ++ attributes) ]
        [ Html.input
            ([ HtmlAttributes.class "mx-1 mt-2"
             , HtmlAttributes.type_ "radio"
             , HtmlAttributes.id (name ++ "_" ++ option.value)
             , HtmlAttributes.name name
             , HtmlEvents.onClick <| onClick
             ]
                ++ radioState
            )
            []
        , Html.text (Maybe.withDefault option.value option.label)
        ]


radioViewExtraDiv : Direction.Direction -> Html.Html Msg.Msg
radioViewExtraDiv direction =
    case direction of
        Direction.Row ->
            HtmlExtra.nothing

        Direction.Column ->
            Html.div [ HtmlAttributes.class "column is-one-third-desktop is-1" ] []


radio : List (Html.Html Msg.Msg) -> String -> Field.Field -> List (Html.Html Msg.Msg)
radio extra key field =
    case field of
        Field.StringField_ (Field.RadioField properties) ->
            let
                value option =
                    Just ((properties.value == "" && properties.default == Just option) || (properties.value == option))
            in
            extra
                ++ (properties.options
                        |> List.map
                            (\option -> radioView properties.direction (Msg.UpdateRadioStringField key option) (value option.value) option key)
                   )

        Field.BoolField_ (Field.RadioBoolField properties) ->
            let
                text option =
                    { value = RadioBool.toString option, label = Nothing }

                value option =
                    Maybe.map2 (==) properties.value (RadioBool.fromString (text option).value)
            in
            extra
                ++ (properties.options
                        |> List.map
                            (\option -> radioView Direction.Column (Msg.UpdateRadioBoolField key option) (value option) (text option) key)
                   )

        Field.BoolField_ (Field.RadioEnumField properties) ->
            let
                text option =
                    { value = RadioEnum.toString option, label = Nothing }

                value option =
                    Maybe.map2 (==) properties.value (RadioEnum.fromString (text option).value)
            in
            extra
                ++ (properties.options
                        |> List.map
                            (\option -> radioView Direction.Column (Msg.UpdateRadioEnumField key option) (value option) (text option) key)
                   )

        _ ->
            [ HtmlExtra.nothing ]


checkbox : String -> Field.BoolFieldProperties a -> Html.Html Msg.Msg
checkbox key field =
    let
        toggledValue =
            not field.value
    in
    Html.label [ HtmlAttributes.class "checkbox" ]
        [ Html.input
            [ HtmlAttributes.class "mr-3"
            , HtmlAttributes.type_ "checkbox"
            , HtmlAttributes.checked field.value
            , HtmlEvents.onClick <| Msg.UpdateBoolField key toggledValue
            ]
            []
        , Html.text field.label
        ]


error : Bool -> Locale.Locale -> Fields.Fields -> Field.Field -> Html.Html Msg.Msg
error submitted locale fields field =
    case field of
        Field.NumericField_ (Field.NumericField properties) ->
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
            (Html.text << Validate.errorToMessage field)
            (always HtmlExtra.nothing)