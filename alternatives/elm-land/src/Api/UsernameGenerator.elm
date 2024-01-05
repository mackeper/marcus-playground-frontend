module Api.UsernameGenerator exposing (getUsernames)

import Api.Client
import Http
import Json.Decode


getUsernames :
    { onResponse : Result Http.Error (List Username) -> msg
    , categories : List { name : String, enabled : Bool }
    , count : Int
    }
    -> Cmd msg
getUsernames options =
    Api.Client.get
        options.onResponse
        decoder
        ("https://usernamegenerator.realmoneycompany.com?"
            ++ "count="
            ++ String.fromInt options.count
            ++ "&"
            ++ String.join "&"
                (List.map
                    (\c ->
                        String.replace " " "_" (String.toLower c.name)
                            ++ "="
                            ++ (if c.enabled then
                                    "true"

                                else
                                    "false"
                               )
                    )
                    options.categories
                )
        )


decoder : Json.Decode.Decoder (List Username)
decoder =
    Json.Decode.list usernameDecoder


type alias Username =
    String


usernameDecoder : Json.Decode.Decoder Username
usernameDecoder =
    Json.Decode.string
