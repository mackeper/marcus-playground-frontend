module Modules.Quantities.Mass exposing (Mass, milligrams, inMilligrams, micrograms, inMicrograms, toString, kilograms, inKilograms, grams, inGrams, nanograms, inNanograms)

import Modules.Quantities.Quantity exposing (Quantity(..))
import Modules.Quantities.Unit exposing (Unit(..))

type Kilogram = Float

type alias Mass = Quantity Float Kilogram

kilograms : Float -> Mass
kilograms value = Quantity value

inKilograms : Mass -> Float
inKilograms (Quantity value) = value

grams : Float -> Mass
grams value = Quantity (value * 1e-3)

inGrams : Mass -> Float
inGrams mass = (inKilograms mass) * 1e3

milligrams : Float -> Mass
milligrams value = Quantity (value * 1e-6)

inMilligrams : Mass -> Float
inMilligrams mass = (inKilograms mass) * 1e6

micrograms : Float -> Mass
micrograms value = Quantity (value * 1e-9)

inMicrograms : Mass -> Float
inMicrograms mass = (inKilograms mass) * 1e9

nanograms : Float -> Mass
nanograms value = Quantity (value * 1e-12)

inNanograms : Mass -> Float
inNanograms mass = (inKilograms mass) * 1e12

toString : Mass -> String
toString mass =
    let
        (value, unit) =
            if  inKilograms mass >= 1 then 
                (inKilograms mass, "kg")
            else if inGrams mass >= 1 then
                (inGrams mass, "g")
            else if inMilligrams mass >= 1 then
                (inMilligrams mass, "mg")
            else if inMicrograms mass >= 1 then
                (inMicrograms mass, "µg")
            else
                (inNanograms mass, "ng")
    in
    String.fromFloat value ++ " " ++ unit
