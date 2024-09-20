module Modules.HtmlUtils exposing (..)

import Html exposing (Html)
import Html.Parser
import Html.Parser.Util


textHtml : String -> List (Html msg)
textHtml t =
    case Html.Parser.run t of
        Ok nodes ->
            Html.Parser.Util.toVirtualDom nodes

        Err _ ->
            []
