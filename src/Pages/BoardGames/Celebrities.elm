module Pages.BoardGames.Celebrities exposing (Model, Msg(..), init, update, view, subscriptions, gameInfo)


import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.BoardGames.GameInfo exposing (GameInfo)


type alias Model =
    {
    }

gameInfo : GameInfo
gameInfo = GameInfo "Celebrities" "Try to find out which celebrity that your co-players choose!" "png" 2 100 4 10 1 5

init : ( Model, Cmd Msg )
init =
    (
        Model
    , Cmd.none )


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
        [ text gameInfo.name
        ]
