module Api.Dashboard exposing (..)

import Api.Client exposing (getErrorMessage, getList, post, put)
import Http
import Json.Encode
import Json.Decode


type alias TodoEntry =
    { id : Int
    , title : String
    , description : String
    }

url : String
url =
    "https://dashboard.realmoneycompany.com/todo"

entryDecoder : Json.Decode.Decoder TodoEntry
entryDecoder =
    Json.Decode.map3 TodoEntry
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "description" Json.Decode.string)

entryEncoder : TodoEntry -> Json.Encode.Value
entryEncoder entry =
    Json.Encode.object
        [ ( "id", Json.Encode.int entry.id )
        , ( "title", Json.Encode.string entry.title )
        , ( "description", Json.Encode.string entry.description )
        ]


getTodoEntries : (Result Http.Error (List TodoEntry) -> msg) -> Cmd msg
getTodoEntries msg =
    getList msg entryDecoder url


postTodoEntry : (Result Http.Error TodoEntry -> msg) -> TodoEntry -> Cmd msg
postTodoEntry msg entry =
    post msg entryEncoder entryDecoder entry url


putTodoEntry : (Result Http.Error () -> msg) -> TodoEntry -> Cmd msg
putTodoEntry msg entry =
    put msg entryEncoder entry (url ++ "/" ++ String.fromInt entry.id)


getTodoErrorMessage : Http.Error -> String
getTodoErrorMessage error =
    getErrorMessage error "Get blog entries failed."
