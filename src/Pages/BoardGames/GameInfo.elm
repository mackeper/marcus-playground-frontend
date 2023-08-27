module Pages.BoardGames.GameInfo exposing (GameInfo)

type alias GameInfo =
    { name: String
    , description: String
    , image: String
    , minPlayers: Int
    , maxPlayers: Int
    , minAge: Int
    , playTime: Int
    , difficulty: Int
    , rating: Int
    }
