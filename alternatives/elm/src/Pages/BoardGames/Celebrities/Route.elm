module Pages.BoardGames.Celebrities.Route exposing (Route(..), matchRoute)

import Url.Parser exposing ((</>), Parser, map, oneOf, s, string, top)


type Route
    = Menu
    | CreateGame
    | JoinGame (Maybe String)
    | Game String


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map Menu top
        , map CreateGame (s "create")
        , map (JoinGame Nothing) (s "join")
        , map (\x -> JoinGame (Just x)) (s "join" </> string)
        , map Game (s "game" </> string)
        ]
