module Common.Dashboard.Meals exposing (..)


type Category
    = Breakfast
    | Lunch
    | Dinner
    | Snack


type alias Meal =
    { uuid : String
    , name : String
    , category : String
    }



-- { meals =
--     [ ( "Monday", "Hamburger / red lentil burger" )
--     , ( "Tuesday", "Fried rice" )
--     , ( "Wednesday", "Tofu pasta" )
--     , ( "Thursday", "Panncakes" )
--     , ( "Friday", "Tacos / Wrap" )
--     ]
-- }


getAvailableMeals : List Meal
getAvailableMeals =
    [ { uuid = "29756894-e816-4852-a820-3e3a15572984", name = "Hamburger ", category = "Dinner" }
    , { uuid = "2b405184-8708-411d-b53c-16ace9c9cb9e", name = "Fried rice", category = "Dinner" }
    , { uuid = "4eb2f5d4-7171-4387-ad00-470e0ae5556e", name = "Tofu pasta", category = "Dinner" }
    , { uuid = "4bbe29cd-05ce-4f1d-bd9c-66146ebb51b9", name = "Pancakes", category = "Breakfast" }
    , { uuid = "e201993a-de54-4b33-9b09-17fb20166b7f", name = "Tacos", category = "Dinner" }
    , { uuid = "770ae27b-32d7-4760-a2fd-c9883dc5c4e2", name = "BLT", category = "Dinner" }
    , { uuid = "29d6a61a-bd08-421d-9d33-ed3d1265f0f1", name = "Kebab plate", category = "Dinner" }
    ]
