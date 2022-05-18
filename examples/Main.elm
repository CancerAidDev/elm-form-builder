module Main exposing (Model, Msg(..), Person, config, init, main, update, view)

import Browser
import Html exposing (Html, div, h1, input, text)
import Html.Attributes exposing (placeholder)
import Html.Events exposing (onInput)
import Lib.Types.Form as Form


main : Program {} Model Msg
main =
    Browser.element
        { init = always ((init _) (Cmd.none))
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    {
        form : Form.Form
    }


init :( Model )
init form =
    ( model, Cmd.none )



-- UPDATE


type Msg
    = SetQuery String
    | SetTableState Table.State


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetQuery newQuery ->
            ( { model | query = newQuery }
            , Cmd.none
            )

        SetTableState newState ->
            ( { model | tableState = newState }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view { people, tableState, query } =
    let
        lowerQuery =
            String.toLower query

        acceptablePeople =
            List.filter (String.contains lowerQuery << String.toLower << .name) people
    in
    div []
        [ h1 [] [ text "Birthplaces of U.S. Presidents" ]
        , input [ placeholder "Search by Name", onInput SetQuery ] []
        , Table.view config tableState acceptablePeople
        ]


config : Table.Config Person Msg
config =
    Table.config
        { toId = .name
        , toMsg = SetTableState
        , columns =
            [ Table.stringColumn "Name" .name
            , Table.intColumn "Year" .year
            , Table.stringColumn "City" .city
            , Table.stringColumn "State" .state
            ]
        }



-- PEOPLE


type alias Person =
    { name : String
    , year : Int
    , city : String
    , state : String
    }


