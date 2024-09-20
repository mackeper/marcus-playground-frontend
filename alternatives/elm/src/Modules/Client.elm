module Modules.Client exposing (get, getErrorMessage, getList, post, put)

import Http
import Json.Decode
import Json.Encode


get : (Result Http.Error a -> msg) -> Json.Decode.Decoder a -> String -> Cmd msg
get msg decoder url =
    Http.get
        { url = url
        , expect = Http.expectJson msg decoder
        }


getList : (Result Http.Error (List a) -> msg) -> Json.Decode.Decoder a -> String -> Cmd msg
getList msg decoder url =
    Http.get
        { url = url
        , expect = Http.expectJson msg (Json.Decode.list decoder)
        }


post : (Result Http.Error a -> msg) -> (a -> Json.Encode.Value) -> Json.Decode.Decoder a -> a -> String -> Cmd msg
post msg encoder decoder data url =
    Http.post
        { url = url
        , body = Http.jsonBody (encoder data)
        , expect = Http.expectJson msg decoder
        }


put : (Result Http.Error () -> msg) -> (a -> Json.Encode.Value) -> a -> String -> Cmd msg
put msg encode data url =
    Http.request
        { method = "PUT"
        , url = url
        , body = Http.jsonBody (encode data)
        , expect = Http.expectWhatever msg
        , headers = []
        , timeout = Nothing
        , tracker = Nothing
        }


getErrorMessage : Http.Error -> String -> String
getErrorMessage error suffix =
    case error of
        Http.BadUrl errorMsg ->
            "Error (BadUrl " ++ errorMsg ++ " ) " ++ suffix

        Http.Timeout ->
            "Error (Timeout) " ++ suffix

        Http.NetworkError ->
            "Error (NetworkError) " ++ suffix

        Http.BadStatus errorCode ->
            "Error (BadStatus,  " ++ String.fromInt errorCode ++ " ) " ++ suffix

        Http.BadBody errorMsg ->
            "Error (BadBody, " ++ errorMsg ++ " ) " ++ suffix
