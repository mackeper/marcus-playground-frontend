module Modules.Quantities.Test exposing (..)

type Unit =
    Unit String String

type Quantity value unit
    = Quantity value unit

type Kilogram a b=
    Unit a b

type alias Mass =
    Quantity Float (Kilogram String String)

kilogram : Float -> Mass
kilogram value =
