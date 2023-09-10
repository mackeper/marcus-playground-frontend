module Pages.UsernameGenerator.UsernameGenerator exposing (Category, Model, Msg(..), init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Pages.UsernameGenerator.Adjectives as Adjectives
import Pages.UsernameGenerator.Animals as Animals
import Pages.UsernameGenerator.Nouns as Nouns
import Random
import Random.List


type alias Category =
    { name : String
    , isUsed : Bool
    , items : List String
    }


type alias Model =
    { usernames : List String
    , numberOfResults : Int
    , seed : Random.Seed
    , categories : List Category
    }


type Msg
    = GenerateUsername
    | GetNewSeed Int
    | ToggleCategory Int


view : Model -> Html Msg
view model =
    article [ class "username-generator" ]
        [ div [] (viewCategories model.categories)
        , button [ onClick GenerateUsername ] [ text "Generate username" ]
        , viewUsernames model.usernames
        ]


viewCategories : List Category -> List (Html Msg)
viewCategories categories =
    List.indexedMap (\index category -> label [] [ input [ type_ "checkbox", checked category.isUsed, onClick (ToggleCategory index) ] [], text category.name ]) categories


viewUsernames : List String -> Html Msg
viewUsernames usernames =
    ul [] (List.map viewUsername usernames)


viewUsername : String -> Html Msg
viewUsername username =
    li [] [ text username ]


getAdjectives : Category
getAdjectives =
    { name = "Adjectives"
    , isUsed = True
    , items = Adjectives.getAdjectives
    }


getAnimals : Category
getAnimals =
    { name = "Animals"
    , isUsed = True
    , items = Animals.getAnimals
    }


getNouns : Category
getNouns =
    { name = "Nouns"
    , isUsed = False
    , items = Nouns.getNouns
    }


getCoolNumbers : Category
getCoolNumbers =
    { name = "Cool numbers"
    , isUsed = False
    , items =
        [ "1337"
        , "42"
        , "1994"
        , "1995"
        , "1338"
        , "3000"
        , "2000"
        ]
    }


getAllCategories : List Category
getAllCategories =
    [ getAdjectives, getAnimals, getCoolNumbers, getNouns ]


getConcatinatedCategories : List Category -> Random.Seed -> ( List String, Random.Seed )
getConcatinatedCategories categories seed =
    case List.filter (\category -> category.isUsed) categories of
        [] ->
            ( [], seed )

        [ head ] ->
            Random.step (Random.List.shuffle head.items) seed

        head :: tail ->
            let
                ( words, newSeed ) =
                    Random.step (Random.List.shuffle head.items) seed

                ( words2, newSeed2 ) =
                    getConcatinatedCategories tail newSeed
            in
            ( List.map2 (\x y -> x ++ y) words words2, newSeed2 )


getRandomUsernames : List Category -> Random.Seed -> List String
getRandomUsernames categories seed =
    Tuple.first (getConcatinatedCategories categories seed)


getGenerator : Cmd Msg
getGenerator =
    Random.generate GetNewSeed (Random.int 0 99999)


init : ( Model, Cmd Msg )
init =
    ( initialModel, getGenerator )


initialModel : Model
initialModel =
    { usernames = []
    , numberOfResults = 10
    , seed = Random.initialSeed 42
    , categories = getAllCategories
    }


updateCategoryIsUsed : Model -> Int -> List Category
updateCategoryIsUsed model index =
    List.indexedMap
        (\i category ->
            if i == index then
                { category | isUsed = not category.isUsed }

            else
                category
        )
        model.categories


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GenerateUsername ->
            ( { model | usernames = List.take model.numberOfResults (getRandomUsernames model.categories model.seed) }, getGenerator )

        GetNewSeed value ->
            ( { model | seed = Random.initialSeed value }, Cmd.none )

        ToggleCategory index ->
            ( { model | categories = updateCategoryIsUsed model index }, Cmd.none )
