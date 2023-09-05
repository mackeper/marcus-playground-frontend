module Pages.BoardGames.BoardGamesList exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.BoardGames.Celebrities as Celebrities
import Pages.BoardGames.GameInfo exposing (GameInfo)
import Pages.BoardGames.Spy as Spy


type alias Model =
    { games : List GameInfo
    }


init : ( Model, Cmd Msg )
init =
    ( Model [ Celebrities.gameInfo, Spy.gameInfo ], Cmd.none )


type Msg
    = Msg1


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg1 ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewGameInfos : List GameInfo -> Html Msg
viewGameInfos gameInfos =
    div [ class "board-games-gameinfos grid" ] (List.map viewGameInfo gameInfos)


viewGameInfo : GameInfo -> Html Msg
viewGameInfo gameInfo =
    article [ class "board-games-gameinfo" ]
        [ div [ class "headings" ]
            [ h2 [] [ text gameInfo.name ]
            , h3 [] [ text gameInfo.description ]
            ]
        , div []
            [ a [ href ("/boardgames/" ++ gameInfo.id) ] [ button [] [ text "Start" ] ]
            , div [] [ text ("Age: " ++ String.fromInt gameInfo.minAge ++ "+") ]
            , div [] [ text ("Players: " ++ String.fromInt gameInfo.minPlayers ++ " - " ++ String.fromInt gameInfo.maxPlayers ++ "") ]
            , div [] [ text ("Duration: " ++ String.fromInt gameInfo.playTime ++ "~") ]
            , div [] [ text ("Difficulty: " ++ String.fromInt gameInfo.difficulty ++ "/5") ]
            ]
        ]


view : Model -> Html Msg
view model =
    div [ class "board-games" ]
        [ viewGameInfos model.games
        ]
