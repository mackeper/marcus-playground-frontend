module Pages.UsernameGenerator exposing (Model, Msg, page)

import Api
import Api.UsernameGenerator
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Layouts exposing (Layout)
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
        |> Page.withLayout toLayout


toLayout : Model -> Layouts.Layout Msg
toLayout model =
    Layouts.Navbar
        {}



-- INIT


type alias Username =
    String


type alias Model =
    { usernameData : Api.Data (List Username)
    , categories : List Category
    , count : Int
    }


type alias Category =
    { name : String
    , enabled : Bool
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { usernameData = Api.Loading
      , categories =
            [ { name = "Adjectives", enabled = True }
            , { name = "Animals", enabled = True }
            , { name = "Cool numbers", enabled = False }
            , { name = "Nouns", enabled = False }
            ]
      , count = 10
      }
    , Api.UsernameGenerator.getUsernames
        { onResponse = UsernameGeneratorResponded
        , categories =
            [ { name = "Adjectives", enabled = True }
            , { name = "Animals", enabled = True }
            , { name = "Cool numbers", enabled = False }
            , { name = "Nouns", enabled = False }
            ]
        , count = 10
        }
        |> Effect.sendCmd
    )



-- UPDATE


type Msg
    = NoOp
    | GenerateUsername
    | UsernameGeneratorResponded (Result Http.Error (List Username))
    | ToggleCategory String


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Effect.none
            )

        GenerateUsername ->
            ( model
            , Api.UsernameGenerator.getUsernames
                { onResponse = UsernameGeneratorResponded
                , categories = model.categories
                , count = model.count
                }
                |> Effect.sendCmd
            )

        UsernameGeneratorResponded (Ok listOfUsernames) ->
            ( { model | usernameData = Api.Success listOfUsernames }
            , Effect.none
            )

        UsernameGeneratorResponded (Err error) ->
            ( { model | usernameData = Api.Failure error }
            , Effect.none
            )

        ToggleCategory categoryName ->
            ( { model
                | categories =
                    List.map
                        (\category ->
                            if category.name == categoryName then
                                { category | enabled = not category.enabled }

                            else
                                category
                        )
                        model.categories
              }
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


viewCategories : Model -> Html Msg
viewCategories model =
    p []
        (List.map
            (\category ->
                label
                    []
                    [ input
                        [ type_ "checkbox"
                        , checked category.enabled
                        , onClick (ToggleCategory category.name)
                        ]
                        []
                    , text category.name
                    ]
            )
            model.categories
        )


viewUsernames : Model -> Html Msg
viewUsernames model =
    case model.usernameData of
        Api.Loading ->
            p [ attribute "aria-busy" "true" ]
                [ text "Loading..." ]

        Api.Failure error ->
            p []
                [ text (Api.toUserFriendlyMessage error) ]

        Api.Success usernames ->
            p []
                [ ul
                    []
                    (List.map
                        (\username ->
                            li [] [ text username ]
                        )
                        usernames
                    )
                ]


view : Model -> View Msg
view model =
    { title = "Pages.UsernameGenerator"
    , body =
        [ article []
            [ viewCategories model
            , button [ onClick GenerateUsername ] [ text "Generate username" ]
            , viewUsernames model
            ]
        ]
    }
