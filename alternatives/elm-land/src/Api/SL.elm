module Api.SL exposing (..)

import Api.Client
import Common.Date exposing (Date, decodeIso8601ToDateTime)
import Http
import Json.Decode


type alias Departures =
    { destination : String
    , scheduled : Date
    , expected : Date
    , display : String
    }


url : String
url =
    "https://transport.integration.sl.se/v1/sites/1180/departures"


entryDecoder : Json.Decode.Decoder Departures
entryDecoder =
    Json.Decode.map4 Departures
        (Json.Decode.field "destination" Json.Decode.string)
        (Json.Decode.field "scheduled" decodeIso8601ToDateTime)
        (Json.Decode.field "expected" decodeIso8601ToDateTime)
        (Json.Decode.field "display" Json.Decode.string)


departuresListDecoder : Json.Decode.Decoder (List Departures)
departuresListDecoder =
    Json.Decode.field "departures" (Json.Decode.list entryDecoder)


getEntries : (Result Http.Error (List Departures) -> msg) -> Cmd msg
getEntries msg =
    Api.Client.get msg departuresListDecoder url


getErrorMessage : Http.Error -> String
getErrorMessage error =
    Api.Client.getErrorMessage error "Get SL entries failed."
