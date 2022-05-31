module View exposing (..)

import Dialog
import Dialog.Bulma as DialogBulma
import Form.Locale as FormLocale
import Form.Validate as FormValidate
import Form.View as FormView
import Html
import Html.Attributes as HtmlAttributes
import Html.Events as HtmlEvents
import Model
import Msg


view : Model.Model -> Html.Html Msg.Msg
view model =
    Html.div
        [ HtmlAttributes.class "container p-5" ]
        [ Html.h1
            [ HtmlAttributes.class "is-size-3 has-text-weight-bold" ]
            [ Html.text "Add Person" ]
        , Html.div []
            [ Html.map Msg.FormMsg (FormView.view model.startTime model.submitted model.locale model.form)
            , Html.div [ HtmlAttributes.class "is-flex is-justify-content-center pt-4" ]
                [ Html.button
                    [ HtmlAttributes.class "button is-link"
                    , HtmlAttributes.disabled (model.submitted && not (FormValidate.isValid model.locale model.form))
                    , HtmlEvents.onClick Msg.SubmitForm
                    ]
                    [ Html.text "Create" ]
                ]
            ]
        , viewDialog model.dialog { toMsg = Msg.DialogMsg }
        ]


viewDialog : Dialog.Model String msg -> { toMsg : Dialog.Msg -> msg } -> Html.Html msg
viewDialog model { toMsg } =
    DialogBulma.view (DialogBulma.defaultCustomizations toMsg) model
