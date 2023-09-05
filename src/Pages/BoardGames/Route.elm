module Pages.BoardGames.Route exposing (Route(..), matchRoute)
import Url.Parser exposing (Parser, s, oneOf, map, top)

type Route
    = GameList
    | Celebrities
    | Spyfall

matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map GameList top
        , map Celebrities (s "celebrities")
        , map Spyfall (s "spyfall")
        ]
