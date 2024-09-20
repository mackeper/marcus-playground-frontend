module Pages.BoardGames.Celebrities.CreateGame exposing (Model, Msg, init, subscriptions, update, view)

import Browser.Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Events.Extra exposing (onChange)
import Random
import Random.Char
import Random.String


type Msg
    = UpdatePlayerName String
    | UpdateCelebrityName String
    | CreateGame
    | GetNewSeed Int


type alias Model =
    { playerName : String
    , celebrityName : String
    , seed : Random.Seed
    }


getGenerator : Cmd Msg
getGenerator =
    Random.generate GetNewSeed (Random.int 0 99999)


init : ( Model, Cmd Msg )
init =
    ( Model "Hello" "World" (Random.initialSeed 0), getGenerator )


getRandomGameId : Model -> ( Model, String )
getRandomGameId model =
    let
        ( result, seed ) =
            Random.step (Random.String.string 6 Random.Char.latin) model.seed
    in
    ( { model | seed = seed }, result )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdatePlayerName value ->
            ( { model | playerName = value }, Cmd.none )

        UpdateCelebrityName value ->
            ( { model | celebrityName = value }, Cmd.none )

        CreateGame ->
            let
                ( updatedModel, gameId ) =
                    getRandomGameId model
            in
            ( updatedModel, Browser.Navigation.load <| "/boardgames/celebrities/game/" ++ gameId )

        GetNewSeed value ->
            ( { model | seed = Random.initialSeed value }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Create Game" ]
        , label [ for "player-name" ] [ text "Name" ]
        , input [ type_ "text", placeholder "Your name", name "player-name", onChange UpdatePlayerName ] [ text model.playerName ]
        , label [ for "celebrity-name" ] [ text "Celebrity name" ]
        , input [ type_ "text", placeholder "Celebrity name", name "celebrity-name", onChange UpdateCelebrityName ] [ text model.celebrityName ]
        , button [ onClick CreateGame ] [ text "Create" ]
        ]
