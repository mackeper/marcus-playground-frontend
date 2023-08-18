module Pages.Blog.BlogClient exposing (..)

import Http
import Json.Decode
import Json.Encode
import Modules.Date exposing (Date)
import Pages.Blog.Entry exposing (Entry)
import Time


url : String
url =
    "https://blog.realmoneycompany.com/entries"


decodeDate : Json.Decode.Decoder Date
decodeDate =
    Json.Decode.int
        |> Json.Decode.andThen (\ms -> Json.Decode.succeed (Time.millisToPosix ms))
        |> Json.Decode.andThen (\posix -> Json.Decode.succeed (Date posix Time.utc))


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
        , ( "createdAt", Json.Encode.int (Time.posixToMillis entry.createdAt.time) )
        , ( "updatedAt", Json.Encode.int (Time.posixToMillis entry.updatedAt.time) )
        , ( "tags", Json.Encode.list Json.Encode.string entry.tags )
        , ( "published", Json.Encode.bool entry.published )
        , ( "isDeleted", Json.Encode.bool entry.published )
        ]


getBlogEntries : (Result Http.Error (List Entry) -> msg) -> Cmd msg
getBlogEntries msg =
    Http.get
        { url = url
        , expect = Http.expectJson msg (Json.Decode.list entryDecoder)
        }


postBlogEntry : (Result Http.Error Entry -> msg) -> Entry -> Cmd msg
postBlogEntry msg entry =
    Http.post
        { url = url
        , body = Http.jsonBody (entryEncoder entry)
        , expect = Http.expectJson msg entryDecoder
        }


putBlogEntry : (Result Http.Error () -> msg) -> Entry -> Cmd msg
putBlogEntry msg entry =
    Http.request
        { method = "PUT"
        , url = url ++ "/" ++ (entry.id |> String.fromInt)
        , body = Http.jsonBody (entryEncoder entry)
        , expect = Http.expectWhatever msg
        , headers = []
        , timeout = Nothing
        , tracker = Nothing
        }
