module Api.Blog exposing (getBlogEntries, getBlogErrorMessage, postBlogEntry, putBlogEntry)

import Api.Client exposing (getErrorMessage, getList, post, put)
import Common.Blog.Entry exposing (Entry, entryDecoder, entryEncoder)
import Http


url : String
url =
    "https://blog.realmoneycompany.com/entries"


getBlogEntries : (Result Http.Error (List Entry) -> msg) -> Cmd msg
getBlogEntries msg =
    getList msg entryDecoder url


postBlogEntry : (Result Http.Error Entry -> msg) -> Entry -> Cmd msg
postBlogEntry msg entry =
    post msg entryEncoder entryDecoder entry url


putBlogEntry : (Result Http.Error () -> msg) -> Entry -> Cmd msg
putBlogEntry msg entry =
    put msg entryEncoder entry (url ++ "/" ++ String.fromInt entry.id)


getBlogErrorMessage : Http.Error -> String
getBlogErrorMessage error =
    getErrorMessage error "Get blog entries failed."
