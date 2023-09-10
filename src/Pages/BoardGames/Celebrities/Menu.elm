module Pages.BoardGames.Celebrities.Menu exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)


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
        [ h1 [] [ text "Menu" ]
        , a [ href "/boardgames/celebrities/create" ] [ button [] [ text "Create new game" ] ]
        , a [ href "/boardgames/celebrities/join" ] [ button [] [ text "Join game" ] ]
        ]
