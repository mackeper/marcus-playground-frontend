module Pages.Games.CS.CS exposing (Model, Msg(..), init, subscriptions, update, view)

import Html exposing (..)
import Modules.HtmlUtils as HtmlUtils
import Pages.Games.CS.Autoexec exposing (getConfig)


type alias Model =
    { text1 : String
    , text2 : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model getConfig "World", Cmd.none )


type Msg
    = Msg1
    | Msg2


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg1 ->
            ( model, Cmd.none )

        Msg2 ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ p [] (HtmlUtils.textHtml model.text1)
        , hr [] []
        ]
