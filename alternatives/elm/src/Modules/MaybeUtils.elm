module Modules.MaybeUtils exposing (hasValue, isNothing)


isNothing : Maybe a -> Bool
isNothing value =
    case value of
        Nothing ->
            True

        _ ->
            False


hasValue : Maybe a -> Bool
hasValue value =
    not (isNothing value)
