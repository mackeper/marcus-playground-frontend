module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Extra exposing (role)
import Html.Events exposing (onClick)
import Pages.About.About as About
import Pages.Blog.Blog as Blog
import Pages.Blog.NewEntry as BlogNewEntry
import Pages.BoardGames.BoardGames as BoardGames
import Pages.Dev.Tools.Tools as DevTools
import Pages.Diet.Diet as Diet
import Pages.Games.CS.CS as GamesCS
import Pages.Home.Home as Home
import Pages.Tracker.Tracker as Tracker
import Pages.UsernameGenerator.UsernameGenerator as UsernameGenerator
import Platform.Cmd as Cmd
import Route exposing (Route(..))
import Svg
import Svg.Attributes as SvgAttributes
import Url



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
    , navbarOpened : Bool
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
            , navbarOpened = False
            }
    in
    initCurrentPage ( model, Cmd.none )


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | ToggleNavbar
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

                Route.BoardGames gameId ->
                    BoardGames.init gameId |> initTo BoardGames BoardGamesMsg
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

        ( ToggleNavbar, _ ) ->
            ( { model | navbarOpened = not model.navbarOpened }, Cmd.none )

        ( UsernameGeneratorMsg subMsg, UsernameGenerator pageModel ) ->
            UsernameGenerator.update subMsg pageModel |> updateTo model UsernameGenerator UsernameGeneratorMsg

        ( AboutMsg subMsg, About pageModel ) ->
            About.update subMsg pageModel |> updateTo model About AboutMsg

        ( BlogMsg subMsg, Blog pageModel ) ->
            Blog.update subMsg pageModel |> updateTo model Blog BlogMsg

        ( BlogNewEntryMsg subMsg, BlogNewEntry pageModel ) ->
            BlogNewEntry.update subMsg pageModel |> updateTo model BlogNewEntry BlogNewEntryMsg

        ( BoardGamesMsg subMsg, BoardGames pageModel) ->
            BoardGames.update subMsg pageModel |> updateTo model BoardGames BoardGamesMsg

        ( DietMsg subMsg, Diet pageModel ) ->
            Diet.update subMsg pageModel |> updateTo model Diet DietMsg

        ( HomeMsg subMsg, Home pageModel ) ->
            Home.update subMsg pageModel |> updateTo model Home HomeMsg

        ( DevToolsMsg subMsg, DevTools pageModel ) ->
            DevTools.update subMsg pageModel |> updateTo model DevTools DevToolsMsg

        ( GamesCSMsg subMsg, GamesCS pageModel ) ->
            GamesCS.update subMsg pageModel |> updateTo model GamesCS GamesCSMsg

        ( TrackerMsg subMsg, Tracker pageModel ) ->
            Tracker.update subMsg pageModel |> updateTo model Tracker TrackerMsg

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
            [ viewNavbar
            , viewMobileNavbar model
            , main_ [ class "main-content" ] [ viewPage model ]
            ]
        , viewFooter
        ]
    }


viewFooter : Html msg
viewFooter =
    footer [ class "container" ]
        [ Svg.svg
            [ SvgAttributes.width "24"
            , SvgAttributes.height "24"
            , SvgAttributes.viewBox "0 0 24 24"
            ]
            [ Svg.path
                [ SvgAttributes.d "M12 0C5.37 0 0 5.37 0 12c0 5.3 3.438 9.8 8.207 11.385.6.113.82-.262.82-.582 0-.287-.01-1.04-.015-2.04-3.338.725-4.042-1.61-4.042-1.61-.546-1.386-1.334-1.756-1.334-1.756-1.09-.744.083-.73.083-.73 1.205.085 1.838 1.236 1.838 1.236 1.07 1.834 2.806 1.304 3.484.995.108-.776.42-1.305.76-1.605-2.664-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.236-3.22-.125-.3-.54-1.523.12-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.4 3-.405 1.02.005 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.66 1.653.245 2.876.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.63-5.47 5.92.42.37.815 1.104.815 2.22 0 1.6-.015 2.89-.015 3.29 0 .32.215.7.825.58 4.765-1.585 8.203-6.084 8.203-11.385C24 5.37 18.63 0 12 0"
                ]
                []
            ]
        , Svg.svg
            [ SvgAttributes.width "24"
            , SvgAttributes.height "24"
            , SvgAttributes.viewBox "0 0 24 24"
            ]
            [ Svg.path
                [ SvgAttributes.d "M20.57 0H3.43A3.45 3.45 0 0 0 0 3.43v17.14A3.45 3.45 0 0 0 3.43 24h17.14A3.45 3.45 0 0 0 24 20.57V3.43A3.45 3.45 0 0 0 20.57 0zM7.2 20.6H4.4V10.4h2.8zM5.8 9.07h-.02a1.53 1.53 0 0 1-1.52-1.53 1.53 1.53 0 0 1 1.52-1.53 1.54 1.54 0 1 1 0 3.06zm14.8 11.53h-2.8v-5.1c0-1.3-.02-2.98-1.8-2.98-1.8 0-2.08 1.4-2.08 2.86v5.22H9.8V10.4h2.68v1.52h.04a3.7 3.7 0 0 1 3.32-1.84c3.54 0 4.2 2.34 4.2 5.4v6.52z"
                ]
                []
            ]
        ]


viewMobileNavbar : Model -> Html Msg
viewMobileNavbar model =
    nav [ class "mobile-navbar" ]
        [ div [ class "backdrop", class (mobileNavbarClassName model), onClick ToggleNavbar ] []
        , ul []
            [ li [] [ a [ href "#", onClick ToggleNavbar ] [ drawBurger ] ]
            , li [] [ text "Real Money Company" ]
            , li []
                [ aside [ class (mobileNavbarClassName model) ]
                    [ nav [] viewNavbarMenu
                    ]
                ]
            ]
        ]


mobileNavbarClassName : Model -> String
mobileNavbarClassName model =
    if model.navbarOpened then
        "opened"

    else
        "closed"


viewNavbar : Html Msg
viewNavbar =
    nav [ class "desktop-navbar" ] viewNavbarMenu


viewNavbarMenu : List (Html Msg)
viewNavbarMenu =
    [ ul []
        [ li [] [ text "Real Money Company" ]
        ]
    , ul []
        [ viewLink "Home" "/"
        , viewLink "Username Generator" "/usernamegenerator"
        , viewDropdown
            "Games"
            [ viewLink "CS" "/games/cs"
            , viewLink "Idleon" "/games/idleon"
            ]
        , viewDropdown
            "Dev"
            [ viewLink "Tools" "/dev/tools"
            ]
        , viewDropdown "Blog"
            [ viewLink "Blog" "/blog"
            , viewLink "New Entry" "/blog/new"
            ]
        , viewLink "Diet" "/diet"
        , viewLink "Tracker" "/tracker"
        , viewLink "Boardgames" "/boardgames"
        , viewLink "About" "/about"
        ]
    ]

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


drawBurger : Html msg
drawBurger =
    Svg.svg
        [ SvgAttributes.width "24"
        , SvgAttributes.height "24"
        , SvgAttributes.viewBox "0 0 24 24"
        , SvgAttributes.strokeWidth "2"
        , SvgAttributes.stroke "currentColor"
        , SvgAttributes.fill "none"
        , SvgAttributes.strokeLinecap "round"
        ]
        [ Svg.line [ SvgAttributes.x1 "3", SvgAttributes.y1 "6", SvgAttributes.x2 "21", SvgAttributes.y2 "6" ] []
        , Svg.line [ SvgAttributes.x1 "3", SvgAttributes.y1 "12", SvgAttributes.x2 "21", SvgAttributes.y2 "12" ] []
        , Svg.line [ SvgAttributes.x1 "3", SvgAttributes.y1 "18", SvgAttributes.x2 "21", SvgAttributes.y2 "18" ] []
        ]


viewDropdown : String -> List (Html msg) -> Html msg
viewDropdown title items =
    li [ role "list", dir "rtl" ]
        [ a [ href "#", attribute "aria-haspopup" "listbox" ] [ text title ]
        , ul [ role "listbox " ] items
        ]


viewLink : String -> String -> Html Msg
viewLink title path =
    li [] [ a [ href path, onClick ToggleNavbar ] [ text title ] ]
