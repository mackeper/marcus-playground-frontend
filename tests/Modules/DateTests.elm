module Modules.DateTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Time
import Modules.Date exposing (Date, formatDate)

suite : Test
suite =
    describe "Date"
        [ describe "formatDate"
            [ test "Format a generic posix to date (no zfill)"
                (\_ -> Expect.equal "11:11:11 11/11-2023" (formatDate (Date (Time.millisToPosix 1699701071000) Time.utc)))
            , test "Format a generic posix to date (all zfill)"
                (\_ -> Expect.equal "01:01:01 01/01-2023" (formatDate (Date (Time.millisToPosix 1672534861000) Time.utc)))
            ]
        ]
