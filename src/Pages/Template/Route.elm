module Pages.Template.Route exposing (Route(..), matchRoute)

import Url.Parser exposing ((</>), Parser, map, oneOf, s, string, top)


type Route
    = Menu
    | CreateGame
    | JoinGame
    | Game String


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map Menu top
        , map CreateGame (s "create")
        , map JoinGame (s "join")
        , map Game (s "game" </> string)
        ]
