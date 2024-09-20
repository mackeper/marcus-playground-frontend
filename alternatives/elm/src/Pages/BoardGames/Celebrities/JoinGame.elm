module Pages.BoardGames.Celebrities.JoinGame exposing (Model, Msg, init, subscriptions, update, view)

import Browser.Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Events.Extra exposing (onChange)
import Modules.MaybeUtils as MaybeUtils
import Pages.BoardGames.Route exposing (Route(..))
import String


type Msg
    = UpdateGameId GameId
    | UpdatePlayerName String
    | UpdateCelebrityName String
    | JoinGame


type alias GameId =
    String


type alias Model =
    { gameId : GameId
    , gameIdProvided : Bool
    , playerName : String
    , celebrityName : String
    }


init : Maybe GameId -> ( Model, Cmd Msg )
init gameId =
    ( Model
        (Maybe.withDefault "" gameId)
        (MaybeUtils.hasValue gameId)
        ""
        ""
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdatePlayerName value ->
            ( { model | playerName = value }, Cmd.none )

        UpdateCelebrityName value ->
            ( { model | celebrityName = value }, Cmd.none )

        JoinGame ->
            if String.length model.gameId == 6 then
                ( model, Browser.Navigation.load <| "/boardgames/celebrities/game/" ++ model.gameId )

            else
                ( model, Cmd.none )

        UpdateGameId newGameId ->
            ( { model | gameId = newGameId }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Join game" ]
        , label [ for "game-id" ] [ text "Game ID" ]
        , input [ type_ "text", placeholder "Game ID", onChange UpdateGameId, maxlength 6, name "game-id", value model.gameId, disabled model.gameIdProvided ] []
        , label [ for "player-name" ] [ text "Name" ]
        , input [ type_ "text", placeholder "Your name", name "player-name", onChange UpdatePlayerName, value model.playerName ] []
        , label [ for "celebrity-name" ] [ text "Celebrity name" ]
        , input [ type_ "text", placeholder "Celebrity name", name "celebrity-name", onChange UpdateCelebrityName, value model.celebrityName ] []
        , button [ onClick JoinGame ] [ text "Join game" ]
        ]
