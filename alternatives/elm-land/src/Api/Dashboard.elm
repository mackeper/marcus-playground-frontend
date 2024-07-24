module Api.Dashboard exposing (..)

import Api.Client exposing (getErrorMessage, getList, post, put)
import Common.Date exposing (Date, decodeDate, encodeDate)
import Http
import Json.Decode
import Json.Encode


type alias TodoEntry =
    { title : String
    , isCompleted : Bool
    , createdAt : Date
    , completedAt : Maybe Date
    }


url : String
url =
    "https://dashboard.realmoneycompany.com/todo"


entryDecoder : Json.Decode.Decoder TodoEntry
entryDecoder =
    Json.Decode.map4 TodoEntry
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "isCompleted" Json.Decode.bool)
        (Json.Decode.field "createdAt" decodeDate)
        (Json.Decode.maybe <| Json.Decode.field "completedAt" decodeDate)


entryEncoder : TodoEntry -> Json.Encode.Value
entryEncoder entry =
    Json.Encode.object
        [ ( "title", Json.Encode.string entry.title )
        , ( "content", Json.Encode.string "" )
        ]


getTodoEntries : (Result Http.Error (List TodoEntry) -> msg) -> Cmd msg
getTodoEntries msg =
    getList msg entryDecoder url


postTodoEntry : (Result Http.Error TodoEntry -> msg) -> TodoEntry -> Cmd msg
postTodoEntry msg entry =
    post msg entryEncoder entryDecoder entry url


putTodoEntry : (Result Http.Error () -> msg) -> TodoEntry -> Cmd msg
putTodoEntry msg entry =
    put msg entryEncoder entry (url ++ "/" ++ String.fromInt 1)


getTodoErrorMessage : Http.Error -> String
getTodoErrorMessage error =
    getErrorMessage error "Get blog entries failed."
