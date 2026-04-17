module Modules.Quantities.MassTests exposing (..)

import Expect exposing (..)
import Test exposing (..)
import Modules.Quantities.Mass as Mass

suite : Test
suite =
    describe "Mass"
        [ describe "toString"
            [ test "1 kg"
                (\_ -> Expect.equal "1 kg" (Mass.toString (Mass.kilograms 1)))
            , test "1 g"
                (\_ -> Expect.equal "1 g" (Mass.toString (Mass.grams 1)))
            , test "1 mg"
                (\_ -> Expect.equal "1 mg" (Mass.toString (Mass.milligrams 1)))
            , test "1 µg"
                (\_ -> Expect.equal "1 µg" (Mass.toString (Mass.micrograms 1)))
            , test "1 ng"
                (\_ -> Expect.equal "1 ng" (Mass.toString (Mass.nanograms 1)))
            ]
        , describe "in converters"
            [ test "1 kg"
                (\_ -> Expect.equal 1 (Mass.inKilograms (Mass.kilograms 1)))
            , test "1 g"
                (\_ -> Expect.equal 1 (Mass.inGrams (Mass.grams 1)))
            , test "1 mg"
                (\_ -> Expect.equal 1 (Mass.inMilligrams (Mass.milligrams 1)))
            , test "1 µg"
                (\_ -> Expect.equal 1 (Mass.inMicrograms (Mass.micrograms 1)))
            , test "1 ng"
                (\_ -> Expect.equal 1 (Mass.inNanograms (Mass.nanograms 1)))
            ]
        ]
