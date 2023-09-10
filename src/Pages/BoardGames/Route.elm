module Pages.BoardGames.Route exposing (Route(..), matchRoute)

import Pages.BoardGames.Celebrities.Route as CelebritiesRoute
import Url.Parser exposing ((</>), Parser, map, oneOf, s, top)


type Route
    = GameList
    | Celebrities CelebritiesRoute.Route
    | Spyfall


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map GameList top
        , map Celebrities (s "celebrities" </> CelebritiesRoute.matchRoute)
        , map Spyfall (s "spyfall")
        ]
