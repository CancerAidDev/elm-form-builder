module Form.Format.Markdown exposing (toHtml)

import Html
import Html.Attributes as HtmlAttributes
import Markdown.Parser as MarkdownParser
import Markdown.Renderer as MarkdownRenderer


defaultHtmlRenderer : MarkdownRenderer.Renderer (Html.Html msg)
defaultHtmlRenderer =
    MarkdownRenderer.defaultHtmlRenderer


linkRenderer : { title : Maybe String, destination : String } -> List (Html.Html msg) -> Html.Html msg
linkRenderer link content =
    case link.title of
        Just title ->
            Html.a
                [ HtmlAttributes.href link.destination
                , HtmlAttributes.title title
                , HtmlAttributes.target "_blank"
                ]
                content

        Nothing ->
            Html.a
                [ HtmlAttributes.href link.destination
                , HtmlAttributes.target "_blank"
                ]
                content


toHtml : String -> Html.Html msg
toHtml markdown =
    case
        markdown
            |> MarkdownParser.parse
            |> Result.mapError (\error -> error |> List.map MarkdownParser.deadEndToString |> String.join "\n")
            |> Result.andThen (MarkdownRenderer.render { defaultHtmlRenderer | link = linkRenderer })
    of
        Ok rendered ->
            Html.div [] rendered

        Err errors ->
            Html.text errors
