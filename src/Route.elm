module Route exposing (Route(..), parseUrl)

import Pages.BoardGames.Route as BoardGamesRoute
import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = NotFound
    | About
    | Blog
    | BlogNewEntry
    | DevTools
    | Diet
    | GamesCS
    | GamesCookieClicker
    | Home
    | UsernameGenerator
    | Tracker
    | BoardGames BoardGamesRoute.Route


parseUrl : Url -> Route
parseUrl url =
    case parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFound


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map Home top
        , map Home (s "home")
        , map About (s "about")
        , map Blog (s "blog")
        , map BlogNewEntry (s "blog" </> s "new")
        , map DevTools (s "dev" </> s "tools")
        , map Diet (s "diet")
        , map GamesCS (s "games" </> s "cs")
        , map GamesCookieClicker (s "games" </> s "cookieclicker")
        , map UsernameGenerator (s "usernamegenerator")
        , map Tracker (s "tracker")
        , map BoardGames (s "boardgames" </> BoardGamesRoute.matchRoute)
        ]
