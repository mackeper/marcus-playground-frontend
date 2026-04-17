module Pages.Tracker.Visits exposing (Visits, visitsDecoder, visitsEncoder)

import Json.Decode
import Json.Encode


visitsDecoder : Json.Decode.Decoder Visits
visitsDecoder =
    Json.Decode.map Visits
        (Json.Decode.field "count" Json.Decode.int)


visitsEncoder : Visits -> Json.Encode.Value
visitsEncoder visits =
    Json.Encode.object
        [ ( "count", Json.Encode.int visits.count ) ]


type alias Visits =
    { count : Int
    }
