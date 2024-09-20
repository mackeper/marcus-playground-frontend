module Pages.Tracker.TrackerClientTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Random
import Route exposing (Route(..))
import Test exposing (..)


suite : Test
suite =
    describe "TrackerClient"
        [ describe "Json"
            [ test "Decode visits from json"
                (\_ ->
                    Expect.equal "" ""
                )
            ]
        ]
