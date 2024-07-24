module Pages.Dashboard exposing (Model, Msg, page)

import Api.Client
import Api.Dashboard
import Common.Date exposing (dateFromMs)
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Extra exposing (role)
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


type alias TodoModel =
    { items : Api.Client.Data (List Api.Dashboard.TodoEntry)
    , newItem : String
    }


type alias CalendarModel =
    { events : List String }


type alias SlModel =
    { events : List String }


type alias MealPlanModel =
    { meals : List ( String, String ) }


type alias Model =
    { todo : TodoModel
    , calendar : CalendarModel
    , sl : SlModel
    , mealPlan : MealPlanModel
    , note : String
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { todo =
            { items = Api.Client.Loading
            , newItem = ""
            }
      , calendar =
            { events = [ "event1", "event2" ] }
      , sl =
            { events = [ "sl1", "sl2" ] }
      , mealPlan =
            { meals =
                [ ( "Monday", "Hamburger / red lentil burger" )
                , ( "Tuesday", "Fried rice" )
                , ( "Wednesday", "Tofu pasta" )
                , ( "Thursday", "Panncakes" )
                , ( "Friday", "Tacos / Wrap" )
                ]
            }
      , note = "note"
      }
    , Api.Dashboard.getTodoEntries GetTodoEntriesResponse |> Effect.sendCmd
    )



-- UPDATE


type Msg
    = NoOp
    | TodoAddItem
    | TodoOnInput String
    | GetTodoEntriesResponse (Result Http.Error (List Api.Dashboard.TodoEntry))
    | PostTodoEntryResult (Result Http.Error Api.Dashboard.TodoEntry)


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Effect.none
            )

        TodoAddItem ->
            ( model, Api.Dashboard.postTodoEntry PostTodoEntryResult (Api.Dashboard.TodoEntry model.todo.newItem False (dateFromMs 0) Maybe.Nothing) |> Effect.sendCmd )

        PostTodoEntryResult (Ok _) ->
            let
                todo =
                    model.todo
            in
            ( { model | todo = { todo | newItem = "" } }, Api.Dashboard.getTodoEntries GetTodoEntriesResponse |> Effect.sendCmd )

        PostTodoEntryResult (Err _) ->
            ( model, Effect.none )

        -- add todo item
        TodoOnInput value ->
            let
                todo =
                    model.todo
            in
            ( { model | todo = { todo | newItem = value } }, Effect.none )

        GetTodoEntriesResponse (Ok items) ->
            let
                todo =
                    model.todo
            in
            ( { model | todo = { todo | items = Api.Client.Success items } }, Effect.none )

        GetTodoEntriesResponse (Err error) ->
            let
                todo =
                    model.todo
            in
            ( { model | todo = { todo | items = Api.Client.Failure error } }, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


viewTodo2 : Api.Client.Data (List Api.Dashboard.TodoEntry) -> Html Msg
viewTodo2 items =
    case items of
        Api.Client.Loading ->
            text "Loading..."

        Api.Client.Failure error ->
            text (Api.Dashboard.getTodoErrorMessage error)

        Api.Client.Success items2 ->
            ul [] (List.map (\item -> div [] [ label [] [ input [ type_ "checkbox" ] [], text item.title ] ]) items2)


viewTodo : Model -> Html Msg
viewTodo model =
    div []
        [ text "Todo"
        , Html.form []
            [ fieldset [ role "group" ]
                [ input [ type_ "text", placeholder "Add item", value model.todo.newItem, onInput TodoOnInput ] []
                , input [ type_ "button", value "+", onClick TodoAddItem ] []
                ]
            ]
        , viewTodo2 model.todo.items
        ]


viewCalendar : Model -> Html Msg
viewCalendar model =
    div []
        [ text "Calendar"
        , ul [] (List.map (\event -> li [] [ text event ]) model.calendar.events)
        ]


viewSl : Model -> Html Msg
viewSl model =
    div []
        [ text "SL"
        , ul [] (List.map (\event -> li [] [ text event ]) model.sl.events)
        ]


viewNote : Model -> Html Msg
viewNote model =
    div []
        [ text "Note"
        , p [] [ text model.note ]
        ]


viewMealPlan : Model -> Html Msg
viewMealPlan model =
    div []
        [ text "Meal Plan"
        , table []
            (List.map
                (\( day, meal ) ->
                    tr []
                        [ td [] [ text day ]
                        , td [] [ text meal ]
                        ]
                )
                model.mealPlan.meals
            )
        ]


viewDashboard : Model -> Html Msg
viewDashboard model =
    div [ class "grid" ]
        [ viewTodo model
        , div [] [ viewCalendar model, viewMealPlan model ]
        , div [] [ viewSl model, viewNote model ]
        ]


view : Model -> View Msg
view model =
    { title = "Pages.Dashboard"
    , body = [ viewDashboard model ]
    }
