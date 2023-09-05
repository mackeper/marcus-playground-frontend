module Pages.BoardGames.BoardGamesRoute exposing (..)


type Route
    = BoardGamesList
    | Celebrities
    | Spyfall


matchRoute : Maybe String -> Route
matchRoute gameId =
    case gameId of
        Just "celebrities" ->
            Celebrities

        Just "spyfall" ->
            Spyfall

        _ ->
            BoardGamesList
