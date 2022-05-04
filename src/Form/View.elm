module Form.View exposing (view)

import Dict
import Form.Model as Model
import Form.Msg as Msg
import Form.Types.Field as Field
import Form.View.Input as Input
import Html
import Html.Attributes as HtmlAttributes


view : Model.Model a -> Html.Html Msg.Msg
view model =
    model.fields
        |> Dict.toList
        |> List.sortBy (\( _, field ) -> Field.getOrder field)
        |> List.map (\( k, v ) -> Input.view model k v)
        |> Html.div [ HtmlAttributes.class "mx-0 mt-5 columns is-multiline input-field" ]
