module Pages.BoardGames.Spy exposing (Model, Msg, gameInfo, init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.BoardGames.GameInfo exposing (GameInfo)


gameInfo : GameInfo
gameInfo =
    GameInfo "spyfall" "Spyfall" "https://www.spyfall.app/" "png" 2 10 10 8 5 5


type alias Model =
    { text1 : String
    , text2 : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "Hello" "World", Cmd.none )


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
        [ text "Spyfall"
        ]
