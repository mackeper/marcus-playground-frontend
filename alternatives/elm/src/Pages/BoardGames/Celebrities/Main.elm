module Pages.BoardGames.Celebrities.Main exposing (Model, Msg, gameInfo, init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Pages.BoardGames.Celebrities.CreateGame as CreateGame
import Pages.BoardGames.Celebrities.Game as Game
import Pages.BoardGames.Celebrities.JoinGame as JoinGame
import Pages.BoardGames.Celebrities.Menu as Menu
import Pages.BoardGames.Celebrities.Route as Route exposing (Route)
import Pages.BoardGames.GameInfo exposing (GameInfo)


gameInfo : GameInfo
gameInfo =
    GameInfo "celebrities" "Celebrities" "Celebrities" "png" 2 10 10 8 5 5


type Page
    = NotFound
    | Menu Menu.Model
    | CreateGame CreateGame.Model
    | JoinGame JoinGame.Model
    | Game Game.Model


type Msg
    = MenuMsg Menu.Msg
    | CreateGameMsg CreateGame.Msg
    | JoinGameMsg JoinGame.Msg
    | GameMsg Game.Msg


type alias Model =
    { page : Page
    , route : Route
    }


currentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
currentPage ( model, cmds ) =
    let
        ( page, pageCmds ) =
            case model.route of
                Route.Menu ->
                    Menu.init |> initTo Menu MenuMsg

                Route.CreateGame ->
                    CreateGame.init |> initTo CreateGame CreateGameMsg

                Route.JoinGame gameId ->
                    JoinGame.init gameId |> initTo JoinGame JoinGameMsg

                Route.Game gameId ->
                    Game.init gameId |> initTo Game GameMsg
    in
    ( { model | page = page }, pageCmds )


init : Route -> ( Model, Cmd Msg )
init route =
    let
        model =
            { page = NotFound
            , route = route
            }
    in
    currentPage ( model, Cmd.none )


initTo : (otherModel -> Page) -> (otherMsg -> Msg) -> ( otherModel, Cmd otherMsg ) -> ( Page, Cmd Msg )
initTo toModel toMsg ( model, cmd ) =
    ( toModel model, Cmd.map toMsg cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( MenuMsg subMsg, Menu pageModel ) ->
            Menu.update subMsg pageModel |> updateTo model Menu MenuMsg

        ( CreateGameMsg subMsg, CreateGame pageModel ) ->
            CreateGame.update subMsg pageModel |> updateTo model CreateGame CreateGameMsg

        ( JoinGameMsg subMsg, JoinGame pageModel ) ->
            JoinGame.update subMsg pageModel |> updateTo model JoinGame JoinGameMsg

        ( GameMsg subMsg, Game pageModel ) ->
            Game.update subMsg pageModel |> updateTo model Game GameMsg

        ( _, _ ) ->
            ( model, Cmd.none )


updateTo : Model -> (oldModel -> Page) -> (oldMsg -> Msg) -> ( oldModel, Cmd oldMsg ) -> ( Model, Cmd Msg )
updateTo model toModel toMsg ( subModel, subCmd ) =
    ( { model | page = toModel subModel }, Cmd.map toMsg subCmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewPage : Page -> Html Msg
viewPage page =
    case page of
        NotFound ->
            div [] [ text "Celebrities: Not found!" ]

        Menu model ->
            Menu.view model |> Html.map MenuMsg

        CreateGame model ->
            CreateGame.view model |> Html.map CreateGameMsg

        JoinGame model ->
            JoinGame.view model |> Html.map JoinGameMsg

        Game model ->
            Game.view model |> Html.map GameMsg


view : Model -> Html Msg
view model =
    div []
        [ ul []
            [ li [] [ a [ href "/boardgames/celebrities" ] [ text "Menu" ] ]
            , li [] [ a [ href "/boardgames/celebrities/create" ] [ text "Create Game" ] ]
            , li [] [ a [ href "/boardgames/celebrities/join" ] [ text "Join Game" ] ]
            , li [] [ a [ href "/boardgames/celebrities/game/133337" ] [ text "Game" ] ]
            ]
        , article [] [ viewPage model.page ]
        ]
