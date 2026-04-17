module Pages.BoardGames.Celebrities.CelebritiesClient exposing (..)

import Http
import Json.Decode
import Modules.Date exposing (Date, decodeDate, encodeDate)


url : String
url =
    "boardgames.realmoneycompany.com/celebrities"


type GameState
    = NotStarted
    | Started


type alias GameData =
    { id : String
    , players : List String
    , timeleft : Date
    , state : GameState
    }


gameStateDecoder : Json.Decode.Decoder GameState
gameStateDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\state ->
                Json.Decode.succeed
                    (if state == "Started" then
                        Started

                     else
                        NotStarted
                    )
            )


gameDataDecoder : Json.Decode.Decoder GameData
gameDataDecoder =
    Json.Decode.map4 GameData
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "players" (Json.Decode.list Json.Decode.string))
        (Json.Decode.field "timeleft" decodeDate)
        (Json.Decode.field "state" gameStateDecoder)


getGameData : (Result Http.Error GameData -> msg) -> Cmd msg
getGameData msg =
    Http.get
        { url = url
        , expect = Http.expectJson msg gameDataDecoder
        }
