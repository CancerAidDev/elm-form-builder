module View exposing (..)

import Dialog
import Dialog.Bulma as DialogBulma
import Form.Locale as FormLocale
import Form.View as FormView
import Html
import Html.Attributes as HtmlAttributes
import Html.Events as HtmlEvents
import Model
import Msg


view : Model.Model -> Html.Html Msg.Msg
view model =
    Html.div
        [ HtmlAttributes.class "container my-6" ]
        [ Html.h1
            [ HtmlAttributes.class "is-size-3 has-text-weight-bold pb-4" ]
            [ Html.text "Add Person" ]
        , Html.div
            [ HtmlAttributes.class "box p-5 has-background-white" ]
            [ Html.map Msg.FormMsg (FormView.view model.startTime model.submitted FormLocale.enAU model.form)
            , Html.div [ HtmlAttributes.class "is-flex is-justify-content-center pt-4" ]
                [ Html.button
                    [ HtmlAttributes.class "button is-link "
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
