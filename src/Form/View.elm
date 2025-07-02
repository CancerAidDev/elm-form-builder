module Form.View exposing (view)

{-| Form.View


# View

@docs view

-}

import Dict
import Form.Field as Field
import Form.Fields as Fields
import Form.Locale as Locale
import Form.Msg as Msg
import Form.View.Input as Input
import Html
import Html.Attributes as HtmlAttributes
import Time


{-| -}
view : Time.Posix -> Bool -> Locale.Locale -> Fields.Fields -> Html.Html Msg.Msg
view time submitted locale fields =
    Html.div [ HtmlAttributes.class "form-container" ]
        (fields
            |> Dict.toList
            |> List.sortBy (\( _, field ) -> Field.getOrder field)
            |> List.map (\( k, v ) -> Input.view time submitted locale fields k v)
        )
