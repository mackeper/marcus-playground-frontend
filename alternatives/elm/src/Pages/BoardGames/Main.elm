module Pages.BoardGames.Main exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.BoardGames.BoardGamesList as BoardGamesList
import Pages.BoardGames.Celebrities.Main as Celebrities
import Pages.BoardGames.Route as Route exposing (Route(..))
import Pages.BoardGames.Spy as Spy


type alias Model =
    { game : Game
    , route : Route
    }


type Msg
    = BoardGamesListMsg BoardGamesList.Msg
    | CelebritiesMsg Celebrities.Msg
    | SpyMsg Spy.Msg


type Game
    = NotFound
    | BoardGamesList BoardGamesList.Model
    | Celebrities Celebrities.Model
    | Spy Spy.Model


currentGame : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
currentGame ( model, cmds ) =
    let
        ( game, gameCmds ) =
            case model.route of
                Route.GameList ->
                    BoardGamesList.init |> initTo BoardGamesList BoardGamesListMsg

                Route.Celebrities route ->
                    Celebrities.init route |> initTo Celebrities CelebritiesMsg

                Route.Spyfall ->
                    Spy.init |> initTo Spy SpyMsg
    in
    ( { model | game = game }, gameCmds )


init : Route -> ( Model, Cmd Msg )
init route =
    let
        model =
            { game = NotFound
            , route = route
            }
    in
    currentGame ( model, Cmd.none )


initTo : (otherModel -> Game) -> (otherMsg -> Msg) -> ( otherModel, Cmd otherMsg ) -> ( Game, Cmd Msg )
initTo toModel toMsg ( model, cmd ) =
    ( toModel model, Cmd.map toMsg cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.game ) of
        ( BoardGamesListMsg subMsg, BoardGamesList pageModel ) ->
            BoardGamesList.update subMsg pageModel |> updateTo model BoardGamesList BoardGamesListMsg

        ( CelebritiesMsg subMsg, Celebrities pageModel ) ->
            Celebrities.update subMsg pageModel |> updateTo model Celebrities CelebritiesMsg

        ( SpyMsg subMsg, Spy pageModel ) ->
            Spy.update subMsg pageModel |> updateTo model Spy SpyMsg

        ( _, _ ) ->
            ( model, Cmd.none )


updateTo : Model -> (oldModel -> Game) -> (oldMsg -> Msg) -> ( oldModel, Cmd oldMsg ) -> ( Model, Cmd Msg )
updateTo model toModel toMsg ( subModel, subCmd ) =
    ( { model | game = toModel subModel }, Cmd.map toMsg subCmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewGame : Game -> Html Msg
viewGame game =
    case game of
        NotFound ->
            div [] [ text "Board game not found!" ]

        BoardGamesList model ->
            BoardGamesList.view model |> Html.map BoardGamesListMsg

        Celebrities model ->
            Celebrities.view model |> Html.map CelebritiesMsg

        Spy model ->
            Spy.view model |> Html.map SpyMsg


view : Model -> Html Msg
view model =
    div [ class "board-games" ]
        [ viewGame model.game
        ]
