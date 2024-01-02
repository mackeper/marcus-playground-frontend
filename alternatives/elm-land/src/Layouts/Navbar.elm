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


viewLink : String -> String -> Html Msg
viewLink title path =
    li [] [ a [ href path, onClick ToggleNavbar ] [ text title ] ]


viewDropdown : String -> List (Html contentMsg) -> Html contentMsg
viewDropdown title items =
    li [ role "list", dir "rtl" ]
        [ a [ href "#", attribute "aria-haspopup" "listbox" ] [ text title ]
        , ul [ role "listbox " ] items
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
            ]
        ]
    }
