module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Pages.About.About as About
import Pages.Blog.Blog as Blog
import Pages.Blog.NewEntry as BlogNewEntry
import Pages.Dev.Tools.Tools as DevTools
import Pages.Diet.Diet as Diet
import Pages.Games.CS.CS as GamesCS
import Pages.Home.Home as Home
import Pages.UsernameGenerator.UsernameGenerator as UsernameGenerator
import Platform.Cmd as Cmd
import Route exposing (Route(..))
import Url
import Pages.Tracker.Tracker as Tracker
import Pages.BoardGames.BoardGames as BoardGames



{-
   Add new page:
   1. Add to type Page
   2. Add to type Msg
   3. Add to initCurrentPage
   4. Add to update

   *. Add to Route.elm
-}


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , property : String
    , route : Route
    , page : Page
    }


type Page
    = NotFound
    | Home Home.Model
    | About About.Model
    | Blog Blog.Model
    | BlogNewEntry BlogNewEntry.Model
    | Diet Diet.Model
    | DevTools DevTools.Model
    | GamesCS GamesCS.Model
    | UsernameGenerator UsernameGenerator.Model
    | Tracker Tracker.Model
    | BoardGames BoardGames.Model


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        model =
            { key = key
            , url = url
            , property = ""
            , route = Route.parseUrl url
            , page = NotFound
            }
    in
    initCurrentPage ( model, Cmd.none )


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | HomeMsg Home.Msg
    | AboutMsg About.Msg
    | BlogMsg Blog.Msg
    | BlogNewEntryMsg BlogNewEntry.Msg
    | DietMsg Diet.Msg
    | DevToolsMsg DevTools.Msg
    | GamesCSMsg GamesCS.Msg
    | UsernameGeneratorMsg UsernameGenerator.Msg
    | TrackerMsg Tracker.Msg
    | BoardGamesMsg BoardGames.Msg


initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, existingCmds ) =
    let
        ( currentPage, pageCmd ) =
            case model.route of
                Route.NotFound ->
                    ( NotFound, Cmd.none )

                Route.Home ->
                    Home.init |> initTo Home HomeMsg

                Route.UsernameGenerator ->
                    UsernameGenerator.init |> initTo UsernameGenerator UsernameGeneratorMsg

                Route.About ->
                    About.init |> initTo About AboutMsg

                Route.Blog ->
                    Blog.init |> initTo Blog BlogMsg

                Route.BlogNewEntry ->
                    BlogNewEntry.init |> initTo BlogNewEntry BlogNewEntryMsg

                Route.Diet ->
                    Diet.init |> initTo Diet DietMsg

                Route.DevTools ->
                    DevTools.init |> initTo DevTools DevToolsMsg

                Route.GamesCS ->
                    GamesCS.init |> initTo GamesCS GamesCSMsg
                    
                Route.Tracker ->
                    Tracker.init |> initTo Tracker TrackerMsg

                Route.BoardGames ->
                    BoardGames.init |> initTo BoardGames BoardGamesMsg
    in
    ( { model | page = currentPage }, Cmd.batch [ existingCmds, pageCmd ] )


initTo : (otherModel -> Page) -> (otherMsg -> Msg) -> ( otherModel, Cmd otherMsg ) -> ( Page, Cmd Msg )
initTo toModel toMsg ( model, cmd ) =
    ( toModel model, Cmd.map toMsg cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( UrlRequested urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        ( UrlChanged url, _ ) ->
            ( { model | url = url, route = Route.parseUrl url }, Cmd.none ) |> initCurrentPage

        ( UsernameGeneratorMsg subMsg, UsernameGenerator pageModel ) ->
            UsernameGenerator.update subMsg pageModel |> updateTo model UsernameGenerator UsernameGeneratorMsg

        ( AboutMsg subMsg, About pageModel ) ->
            About.update subMsg pageModel |> updateTo model About AboutMsg

        ( BlogMsg subMsg, Blog pageModel ) ->
            Blog.update subMsg pageModel |> updateTo model Blog BlogMsg

        ( BlogNewEntryMsg subMsg, BlogNewEntry pageModel ) ->
            BlogNewEntry.update subMsg pageModel |> updateTo model BlogNewEntry BlogNewEntryMsg

        ( DietMsg subMsg, Diet pageModel ) ->
            Diet.update subMsg pageModel |> updateTo model Diet DietMsg

        ( HomeMsg subMsg, Home pageModel ) ->
            Home.update subMsg pageModel |> updateTo model Home HomeMsg

        ( DevToolsMsg subMsg, DevTools pageModel ) ->
            DevTools.update subMsg pageModel |> updateTo model DevTools DevToolsMsg

        ( GamesCSMsg subMsg, GamesCS pageModel ) ->
            GamesCS.update subMsg pageModel |> updateTo model GamesCS GamesCSMsg

        ( _, _ ) ->
            ( model, Cmd.none )


updateTo : Model -> (oldModel -> Page) -> (oldMsg -> Msg) -> ( oldModel, Cmd oldMsg ) -> ( Model, Cmd Msg )
updateTo model toModel toMsg ( subModel, subCmd ) =
    ( { model | page = toModel subModel }, Cmd.map toMsg subCmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        _ ->
            Sub.none


view : Model -> Browser.Document Msg
view model =
    { title = "Real Money Company"
    , body =
        [ div [ class "container" ]
            [ nav []
                [ ul []
                    [ viewLink "/home"
                    , viewLink "/usernamegenerator"
                    , viewLink "/games/cs"
                    , viewLink "/games/idleon"
                    , viewLink "/dev/tools"
                    , viewLink "/about"
                    , viewLink "/blog"
                    , viewLink "/blog/new"
                    , viewLink "/diet"
                    , viewLink "/tracker"
                    , viewLink "/boardgames"
                    ]
                ]
            , div [ class "main-content" ] [ viewPage model ]
            ]
        ]
    }


viewPage : Model -> Html Msg
viewPage model =
    case model.page of
        NotFound ->
            text "Not found"
        
        Home pageModel ->
            Home.view pageModel |> Html.map HomeMsg

        About aboutModel ->
            About.view aboutModel |> Html.map AboutMsg

        Blog pageModel ->
            Blog.view pageModel |> Html.map BlogMsg

        BlogNewEntry pageModel ->
            BlogNewEntry.view pageModel |> Html.map BlogNewEntryMsg

        Diet pageModel ->
            Diet.view pageModel |> Html.map DietMsg

        DevTools pageModel ->
            DevTools.view pageModel |> Html.map DevToolsMsg

        GamesCS pageModel ->
            GamesCS.view pageModel |> Html.map GamesCSMsg

        UsernameGenerator pageModel ->
            UsernameGenerator.view pageModel |> Html.map UsernameGeneratorMsg
        
        Tracker pageModel ->
            Tracker.view pageModel |> Html.map TrackerMsg

        BoardGames pageModel ->
            BoardGames.view pageModel |> Html.map BoardGamesMsg



viewLink : String -> Html Msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
