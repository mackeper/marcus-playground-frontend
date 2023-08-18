module Pages.UsernameGenerator.UsernameGeneratorTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Random
import Route exposing (Route(..))
import Test exposing (..)
import Pages.UsernameGenerator.UsernameGenerator as UsernameGenerator exposing (..)
import Array


initModel : Model
initModel =
    { usernames = []
    , numberOfResults = 1
    , seed = Random.initialSeed 37
    , categories = []
    }


suite : Test
suite =
    describe "UsernameGenerator"
        [ describe "Update"
            [ describe "GenerateUsername"
                [ test "GenerateUsername should generate one username"
                    (\_ ->
                        let
                            ( model, _ ) =
                                update GenerateUsername { initModel | categories = [ (Category "" True ["Hej"]) ] }
                        in
                        Expect.equal "Hej" (Maybe.withDefault "" (List.head model.usernames))
                    )
                , test "GenerateUsername should generate username by concatenating categories"
                    (\_ ->
                        let
                            ( model, _ ) =
                                update GenerateUsername { initModel | categories = [ (Category "" True ["Hej"]), (Category "" True ["På"]), (Category "" True ["Dig"]) ] }
                        in
                        Expect.equal "HejPåDig" (Maybe.withDefault "" (List.head model.usernames))
                    )
                , test "GenerateUsername should use random item from categories"
                    (\_ ->
                        let
                            ( model, _ ) =
                                update GenerateUsername { initModel | categories = [ (Category "" True ["Hej", "Tjena"]), (Category "" True ["På"]), (Category "" True ["Dig", "Er"]) ] }
                        in
                        Expect.equal "TjenaPåEr" (Maybe.withDefault "" (List.head model.usernames))
                    )
                ]
        , describe "GetNewSeed"
            [ test "Should set new seed"
                (\_ ->
                    let
                        ( model, _ ) =
                            update (GetNewSeed 32) initModel
                    in
                    Expect.equal (Random.initialSeed 32) model.seed
                )
            ]
        , describe "ToggleCategory"
            [ test "Should be able to disable category"
                (\_ ->
                    let
                        ( model, _ ) =
                            update (ToggleCategory 1) { initModel | categories = [ (Category "" True ["Hej"]), (Category "" True ["På"]), (Category "" True ["Dig"]) ] }
                    in
                    Expect.equal False (Maybe.withDefault (Category "" True []) (Array.get 1 (Array.fromList model.categories))).isUsed
                )
            , test "Should be able to enable category"
                (\_ ->
                    let
                        ( model, _ ) =
                            update (ToggleCategory 1) { initModel | categories = [ (Category "" True ["Hej"]), (Category "" False ["På"]), (Category "" True ["Dig"]) ] }
                    in
                    Expect.equal True (Maybe.withDefault (Category "" False []) (Array.get 1 (Array.fromList model.categories))).isUsed
                )
            ]
            ]
        ]
