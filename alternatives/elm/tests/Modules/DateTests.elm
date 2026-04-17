module Modules.DateTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode
import Json.Encode
import Modules.Date exposing (Date, dateFromMs, decodeDate, encodeDate, formatDate)
import Test exposing (..)


suite : Test
suite =
    describe "Date"
        [ describe "formatDate"
            [ test "Format a generic posix to date (no zfill)"
                (\_ -> Expect.equal "11:11:11 11/11-2023" (formatDate (dateFromMs 1699701071000)))
            , test "Format a generic posix to date (all zfill)"
                (\_ -> Expect.equal "01:01:01 01/01-2023" (formatDate (dateFromMs 1672534861000)))
            ]
        , describe "Json"
            [ test "Encode a date"
                (\_ -> Expect.equal "1699701071000" (Json.Encode.encode 0 (encodeDate (dateFromMs 1699701071000))))
            , test "Decode a date"
                (\_ -> Expect.equal (dateFromMs 1699701071000) (Result.withDefault (dateFromMs 0) (Json.Decode.decodeString decodeDate "1699701071000")))
            ]
        ]
