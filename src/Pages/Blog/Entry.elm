module Pages.Blog.Entry exposing (..)

import Modules.Date exposing (Date)


type alias Entry =
    { id : Int
    , title : String
    , content : String
    , createdAt : Date
    , updatedAt : Date
    , tags : List String
    , published : Bool
    , isDeleted : Bool
    }
