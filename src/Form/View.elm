module Form.View exposing (view)

{-| Form.View


# View

@docs view

-}

import Dict
import Form.Field as Field
import Form.Fields as Fields
import Form.Msg as Msg
import Form.View.Input as Input
import Html
import Html.Attributes as HtmlAttributes
import Time


{-| -}
view : Time.Posix -> Bool -> Fields.Fields -> Html.Html Msg.Msg
view time submitted fields =
    fields
        |> Dict.toList
        |> List.sortBy (\( _, field ) -> Field.getOrder field)
        |> List.map (\( k, v ) -> Input.view time submitted fields k v)
        |> Html.div [ HtmlAttributes.class "m-0 columns is-multiline input-field" ]
