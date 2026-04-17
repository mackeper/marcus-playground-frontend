module Pages.Diet.Micronutrient exposing (Micronutrient, getMicronutrients, toString)

import Modules.Quantities.Mass exposing (Mass, inMicrograms, inMilligrams, micrograms, milligrams)


type alias Micronutrient =
    { name : String
    , dailyIntake : Mass
    }


toString : Micronutrient -> String
toString micronutrient =
    micronutrient.name ++ " Daily intake: " ++ String.fromFloat (inMilligrams micronutrient.dailyIntake)


getMicronutrients : List Micronutrient
getMicronutrients =
    [ Micronutrient "Iron" (milligrams 0.0018)
    , Micronutrient "Fluor" (milligrams 0.05)
    , Micronutrient "Fosfor" (milligrams 700)
    , Micronutrient "Jod" (micrograms 150)
    , Micronutrient "Järn" (milligrams 9)
    , Micronutrient "Kalcium" (milligrams 1000)
    , Micronutrient "Kalium" (milligrams 3500)
    , Micronutrient "Koppar" (milligrams 1)
    , Micronutrient "Krom" (micrograms 40)
    , Micronutrient "Magnesium" (milligrams 350)
    , Micronutrient "Mangan" (milligrams 2.5)
    , Micronutrient "Molybden" (micrograms 50)
    , Micronutrient "Natrium" (milligrams 2400)
    , Micronutrient "Selen" (micrograms 55)
    , Micronutrient "Zink" (milligrams 11)
    , Micronutrient "Antioxidanter" (milligrams 0)
    , Micronutrient "A-vitamin" (micrograms 700)
    , Micronutrient "Biotin" (micrograms 30)
    , Micronutrient "C-vitamin" (milligrams 75)
    , Micronutrient "D-vitamin" (micrograms 10)
    , Micronutrient "E-vitamin" (milligrams 10)
    , Micronutrient "Folat" (micrograms 300)
    , Micronutrient "K-vitamin" (micrograms 75)
    , Micronutrient "Niacin" (milligrams 18)
    , Micronutrient "Pantotensyra" (milligrams 6)
    , Micronutrient "Riboflavin" (milligrams 1.6)
    , Micronutrient "Tiamin" (milligrams 1.2)
    , Micronutrient "Vitamin B6" (milligrams 1.4)
    , Micronutrient "Vitamin B12" (micrograms 2.5)
    ]
