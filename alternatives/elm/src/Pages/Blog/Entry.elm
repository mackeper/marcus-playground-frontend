module Pages.Blog.Entry exposing (Entry, entryDecoder, entryEncoder)

import Json.Decode
import Json.Encode
import Modules.Date exposing (Date, decodeDate, encodeDate)


type alias Entry =
    { id : Int
    , title : String
    , content : String
    , createdAt : Date
    , updatedAt : Date
    , tags : List String
    , published : Bool
    , isDeleted : Bool
    }


entryDecoder : Json.Decode.Decoder Entry
entryDecoder =
    Json.Decode.map8 Entry
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "content" Json.Decode.string)
        (Json.Decode.field "createdAt" decodeDate)
        (Json.Decode.field "updatedAt" decodeDate)
        (Json.Decode.field "tags" (Json.Decode.list Json.Decode.string))
        (Json.Decode.field "published" Json.Decode.bool)
        (Json.Decode.field "isDeleted" Json.Decode.bool)


entryEncoder : Entry -> Json.Encode.Value
entryEncoder entry =
    Json.Encode.object
        [ ( "id", Json.Encode.int entry.id )
        , ( "title", Json.Encode.string entry.title )
        , ( "content", Json.Encode.string entry.content )
        , ( "createdAt", encodeDate entry.createdAt )
        , ( "updatedAt", encodeDate entry.updatedAt )
        , ( "tags", Json.Encode.list Json.Encode.string entry.tags )
        , ( "published", Json.Encode.bool entry.published )
        , ( "isDeleted", Json.Encode.bool entry.published )
        ]
