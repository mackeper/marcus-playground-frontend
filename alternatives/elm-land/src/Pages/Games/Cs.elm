module Pages.Games.Cs exposing (Model, Msg, page)

import Common.CS.Autoexec as Autoexec
import Common.HtmlUtils as HtmlUtils
import Effect exposing (Effect)
import Html
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
        |> Page.withLayout toLayout


toLayout : Model -> Layouts.Layout Msg
toLayout model =
    Layouts.Navbar
        {}



-- INIT


type alias Model =
    { autoexec : String }


init : () -> ( Model, Effect Msg )
init () =
    ( { autoexec = Autoexec.getConfig
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Pages.Games.Cs"
    , body = HtmlUtils.textHtml model.autoexec
    }
