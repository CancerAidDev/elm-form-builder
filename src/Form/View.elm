module Form.View exposing (view)

import Dict
import Form.Model as Model
import Form.Msg as Msg
import Form.Types.Field as Field
import Form.Types.Locale as Locale
import Form.View.Input as Input
import Html
import Html.Attributes as HtmlAttributes
import Time


view : Time.Posix -> Bool -> Locale.Locale -> Model.Model -> Html.Html Msg.Msg
view time submitted locale fields =
    fields
        |> Dict.toList
        |> List.sortBy (\( _, field ) -> Field.getOrder field)
        |> List.map (\( k, v ) -> Input.view time submitted locale fields k v)
        |> Html.div [ HtmlAttributes.class "mx-0 mt-5 columns is-multiline input-field" ]
