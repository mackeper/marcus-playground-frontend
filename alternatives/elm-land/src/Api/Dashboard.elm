module Api.Dashboard exposing (..)

import Api.Client exposing (getErrorMessage, getList, post, put, putOnlyUrl)
import Common.Date exposing (Date, dateFromMs, decodeDate)
import Http
import Json.Decode
import Json.Encode
import Layouts.Navbar exposing (Msg)


type alias TodoEntry =
    { uuid : String
    , title : String
    , isCompleted : Bool
    , createdAt : Date
    , completedAt : Maybe Date
    }


todoEntry : String -> TodoEntry
todoEntry title =
    { uuid = ""
    , title = title
    , isCompleted = False
    , createdAt = dateFromMs 0
    , completedAt = Nothing
    }


url : String
url =
    "https://dashboard.realmoneycompany.com/todo"


urlComplete : String -> String
urlComplete uuid =
    "https://dashboard.realmoneycompany.com/todo/" ++ uuid ++ "/complete"


urlUncomplete : String -> String
urlUncomplete uuid =
    "https://dashboard.realmoneycompany.com/todo/" ++ uuid ++ "/uncomplete"


entryDecoder : Json.Decode.Decoder TodoEntry
entryDecoder =
    Json.Decode.map5 TodoEntry
        (Json.Decode.field "id" Json.Decode.string)
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


completeTodoEntry : (Result Http.Error () -> msg) -> TodoEntry -> Cmd msg
completeTodoEntry msg entry =
    putOnlyUrl msg (urlComplete entry.uuid)


uncompleteTodoEntry : (Result Http.Error () -> msg) -> TodoEntry -> Cmd msg
uncompleteTodoEntry msg entry =
    putOnlyUrl msg (urlUncomplete entry.uuid)


putTodoEntry : (Result Http.Error () -> msg) -> TodoEntry -> Cmd msg
putTodoEntry msg entry =
    put msg entryEncoder entry (url ++ "/" ++ String.fromInt 1)


getTodoErrorMessage : Http.Error -> String
getTodoErrorMessage error =
    getErrorMessage error "Get todo entries failed."
