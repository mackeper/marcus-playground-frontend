module Layouts.Navbar exposing (Model, Msg, Props, layout)

import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Extra exposing (..)
import Html.Events exposing (..)
import Layout exposing (Layout)
import Route exposing (Route)
import Shared
import Svg
import Svg.Attributes as SvgAttributes
import View exposing (View)


type alias Props =
    {}


layout : Props -> Shared.Model -> Route () -> Layout () Model Msg contentMsg
layout props shared route =
    Layout.new
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { navbarOpened : Bool }


init : () -> ( Model, Effect Msg )
init _ =
    ( { navbarOpened = False
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = ToggleNavbar


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ToggleNavbar ->
            ( { model | navbarOpened = not model.navbarOpened }, Effect.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


viewFooter : Html msg
viewFooter =
    footer [ class "container" ]
        [ a [ href "https://github.com/mackeper" ]
            [ Svg.svg
                -- Github
                [ SvgAttributes.width "24"
                , SvgAttributes.height "24"
                , SvgAttributes.viewBox "0 0 24 24"
                ]
                [ Svg.path
                    [ SvgAttributes.d "M12 0C5.37 0 0 5.37 0 12c0 5.3 3.438 9.8 8.207 11.385.6.113.82-.262.82-.582 0-.287-.01-1.04-.015-2.04-3.338.725-4.042-1.61-4.042-1.61-.546-1.386-1.334-1.756-1.334-1.756-1.09-.744.083-.73.083-.73 1.205.085 1.838 1.236 1.838 1.236 1.07 1.834 2.806 1.304 3.484.995.108-.776.42-1.305.76-1.605-2.664-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.236-3.22-.125-.3-.54-1.523.12-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.4 3-.405 1.02.005 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.66 1.653.245 2.876.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.63-5.47 5.92.42.37.815 1.104.815 2.22 0 1.6-.015 2.89-.015 3.29 0 .32.215.7.825.58 4.765-1.585 8.203-6.084 8.203-11.385C24 5.37 18.63 0 12 0"
                    ]
                    []
                ]
            ]
        , a [ href "https://www.linkedin.com/in/marcus-%C3%B6stling/" ]
            [ Svg.svg
                -- LinkedIn
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
        ]


viewLink : String -> String -> Html Msg
viewLink title path =
    li [] [ a [ href path, onClick ToggleNavbar, class "secondary" ] [ text title ] ]


viewDropdown : String -> List (Html contentMsg) -> Html contentMsg
viewDropdown title items =
    li []
        [ details [ class "dropdown" ]
            [ summary [] [ text title ]
            , ul [] items
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
        , viewLink "Username Generator" "/username-generator"
        , viewDropdown
            "Games"
            [ viewLink "CS" "/games/cs"
            , viewLink "Cookie Clicker" "/games/cookieclicker"
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
        , viewLink "Dashboard" "/dashboard"
        , viewLink "About" "/about"
        ]
    ]


view : { toContentMsg : Msg -> contentMsg, content : View contentMsg, model : Model } -> View contentMsg
view { toContentMsg, model, content } =
    { title = content.title
    , body =
        [ Html.div [ class "container" ]
            [ viewNavbar |> Html.map toContentMsg
            , viewMobileNavbar model |> Html.map toContentMsg
            , div [] content.body
            , viewFooter
            ]
        ]
    }
