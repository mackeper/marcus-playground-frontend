module Pages.Diet.Diet exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.Diet.Micronutrient as Micronutrient exposing (Micronutrient, getMicronutrients)


type alias Model =
    { text1 : String
    , text2 : String
    , micronutrients : List Micronutrient
    }


init : ( Model, Cmd Msg )
init =
    ( Model "Diet" "World" getMicronutrients, Cmd.none )


type Msg
    = Msg1
    | Msg2


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg1 ->
            ( model, Cmd.none )

        Msg2 ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewMicronutrient : Micronutrient -> Html msg
viewMicronutrient micronutrient =
    article [ class "diet-micronutrient" ]
        [ h2 [] [ text micronutrient.name ]
        , p [] [ text (Micronutrient.toString micronutrient) ]
        ]


view : Model -> Html msg
view model =
    div [ class "diet" ] (List.map viewMicronutrient model.micronutrients)



-- view : Model -> Html Msg
-- view model =
--     div [ class "diet"]
--         [ h1 [] [ text "Vegan Diet: How to Get the Vitamins and Minerals You Need" ]
--         , p [] [ text "A vegan diet can be healthy and satisfying, but it requires some planning and attention to make sure you get all the nutrients your body needs. Here are some tips on how to get enough of the most common nutrients of concern for vegans." ]
--         , h2 [] [ text "Vitamin B12" ]
--         , p [] [ text "Vitamin B12 is essential for the production of red blood cells, DNA, and nerve function. It is only found in animal products, so vegans need to get it from fortified foods or supplements. Some plant foods that are often fortified with vitamin B12 are plant milks, soy products, breakfast cereals, and nutritional yeast. You can also take a vitamin B12 supplement that provides at least 25–100 mcg per day or 2,000 mcg per week.  " ]
--         , h2 [] [ text "Vitamin D" ]
--         , p [] [ text "Vitamin D helps your body absorb calcium and phosphorus, which are important for bone health. It is also involved in immune function, mood regulation, and muscle strength. Vitamin D is mainly produced by your skin when exposed to sunlight, but it can also be found in some foods. However, most plant sources of vitamin D are not very reliable or bioavailable. Therefore, vegans who live in areas with limited sunlight or who have darker skin may need to take a vitamin D supplement that provides at least 600 IU (15 mcg) per day.  " ]
--         , h2 [] [ text "Omega-3 Fatty Acids" ]
--         , p [] [ text "Omega-3 fatty acids are essential for brain and heart health. They can be divided into two types: short-chain and long-chain. Short-chain omega-3s are found in plant foods like flaxseeds, chia seeds, walnuts, and hemp seeds. Long-chain omega-3s are found in fish and algae. Your body can convert some short-chain omega-3s into long-chain omega-3s, but the process is inefficient and may not meet your needs. Therefore, vegans may benefit from taking an algae-based omega-3 supplement that provides at least 200–300 mg of EPA and DHA per day.  " ]
--         , h2 [] [ text "Iron" ]
--         , p [] [ text "Iron is a mineral that helps transport oxygen throughout your body and supports energy production and immune function. There are two types of iron: heme and non-heme. Heme iron is found only in animal products, while non-heme iron is found in plant foods like beans, lentils, tofu, spinach, kale, nuts, seeds, and fortified cereals. Non-heme iron is less well absorbed than heme iron, so vegans need to consume more of it to meet their needs. You can increase your iron absorption by eating vitamin C-rich foods like citrus fruits, strawberries, bell peppers, broccoli, or tomatoes with your iron-rich foods. You can also avoid drinking tea or coffee with your meals, as they can reduce iron absorption. The recommended daily intake of iron for adult men is 8 mg and for adult women is 18 mg (or 8 mg after menopause). If you have low iron levels or symptoms of iron deficiency anemia (such as fatigue, weakness, pale skin, or shortness of breath), you may need to take an iron supplement under the guidance of your doctor.  " ]
--         , h2 [] [ text "Calcium" ]
--         , p [] [ text "Calcium is a mineral that is important for bone health, muscle contraction, nerve transmission, and blood clotting. It is found in dairy products, but also in some plant foods like kale, bok choy, broccoli, okra, almonds, sesame seeds, fortified plant milks, tofu made with calcium sulfate, and calcium-set vegan cheese. The recommended daily intake of calcium for adults is 1,000 mg (or 1,200 mg for women over 50 and men over 70). To ensure you get enough calcium from your vegan diet, try to include at least three servings of calcium-rich plant foods per day. You can also take a calcium supplement if your intake is low or if you have a higher risk of osteoporosis (such as due to age, genetics, or low body weight). However, avoid taking too much calcium (more than 2,500 mg per day), as it can interfere with the absorption of other minerals and cause side effects like constipation, kidney stones, or cardiovascular problems.  " ]
--         , h2 [] [ text "Zinc" ]
--         , p [] [ text "Zinc is a mineral that is involved in many enzymatic reactions, immune function, wound healing, growth, and development. It is found in animal products, but also in some plant foods like beans, lentils, chickpeas, tofu, tempeh, nuts, seeds, oats, quinoa, and fortified cereals. However, plant sources of zinc may have lower bioavailability due to the presence of phytates, which can bind to zinc and reduce its absorption. You can enhance your zinc absorption by soaking, sprouting, or fermenting your plant foods, or by consuming them with foods that contain organic acids (such as citrus fruits, tomatoes, or vinegar). The recommended daily intake of zinc for adults is 11 mg for men and 8 mg for women. If you have low zinc levels or symptoms of zinc deficiency (such as poor wound healing, hair loss, loss of taste or smell, or increased susceptibility to infections), you may need to take a zinc supplement under the guidance of your doctor. However, avoid taking too much zinc (more than 40 mg per day), as it can cause side effects like nausea, vomiting, diarrhea, headaches, or reduced copper absorption.  " ]
--         ]
