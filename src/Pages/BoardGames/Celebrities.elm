module Pages.BoardGames.Celebrities exposing (Model, Msg, gameInfo, init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Pages.BoardGames.GameInfo exposing (GameInfo)


type alias Model =
    { gameState : GameState
    }

type alias GameId = String

type GameState
    = Menu
    | CreatingGame
    | JoinGameMenu
    | JoiningGame
    | InLobby GameId
    | Playing
    | Finished


gameInfo : GameInfo
gameInfo =
    GameInfo "celebrities" "Celebrities" "Try to find out which celebrity that your co-players choose!" "png" 2 100 4 10 1 5


init : ( Model, Cmd Msg )
init =
    ( Model Menu
    , Cmd.none
    )


type Msg
    = GoToCreateGameMenu
    | CreateGame
    | GoToJoinGameMenu
    | JoinGame GameId


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of

        GoToCreateGameMenu ->
            ( { model | gameState = CreatingGame }
            , Cmd.none
            )

        CreateGame ->
            ( { model | gameState = CreatingGame }
            , Cmd.none
            )

        GoToJoinGameMenu ->
            ( { model | gameState = JoinGameMenu }
            , Cmd.none
            )

        JoinGame gameId ->
            ( { model | gameState = JoiningGame}
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewMenu : Html Msg
viewMenu =
    div []
        [ text "Menu"
        , button [ onClick GoToCreateGameMenu ] [ text "Create new game" ]
        , button [ onClick GoToJoinGameMenu ] [ text "Join game" ]
        ]

viewGameLobby =
    div []
        [ text "Game lobby" ]

viewJoinGameMenu : Html Msg
viewJoinGameMenu =
    div []
        [ text "Join game"
        , input [ type_ "text", placeholder "Game ID" ] []
        , button [ onClick (JoinGame "") ] [ text "Join game" ]
        ]

view : Model -> Html Msg
view model =
    case model.gameState of
        Menu ->
            viewMenu

        CreatingGame ->
            article [ attribute "aria-busy" "true" ] [ text "Creating game.." ]

        JoinGameMenu ->
            article [ ] [ viewJoinGameMenu ]

        JoiningGame ->
            article [ attribute "aria-busy" "true" ] [ text "Joining game..." ]

        InLobby gameId ->
            article [] [ text ("In lobby " ++ gameId) ]

        Playing ->
            article [] [ text "Playing" ]

        Finished ->
            article [] [ text "Finished" ]
