module Common.StringUtils exposing (..)


stringFromBool : Bool -> String
stringFromBool bool =
    if bool then
        "true"

    else
        "false"
