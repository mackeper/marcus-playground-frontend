module Pages.BoardGames.Celebrities.Game exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Extra exposing (role)


type alias GameId =
    String


type Msg
    = Msg1
    | Msg2


type alias Model =
    { gameId : GameId
    , players : List String
    }


init : GameId -> ( Model, Cmd Msg )
init gameId =
    ( Model gameId [ "Player 1", "Player 2", "Player 3", "Player 4" ], Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg1 ->
            ( model, Cmd.none )

        Msg2 ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewPlayers : List String -> Html msg
viewPlayers players =
    table [ role "grid" ] (List.map (\player -> tr [] [ td [] [ text player ] ]) players)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.gameId ]
        , viewPlayers model.players
        , button [] [ text "Start" ]
        ]
