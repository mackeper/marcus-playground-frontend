module Pages.Tracker.Tracker exposing (Model, Msg(..), init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    { text1 : String
    , text2 : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "Tracker" " page", Cmd.none )


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
        [ text model.text1
        , text model.text2
        ]
