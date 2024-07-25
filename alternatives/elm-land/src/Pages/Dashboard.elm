module Pages.Dashboard exposing (Model, Msg, page)

import Api.Client
import Api.Dashboard
import Api.SL
import Common.Date exposing (Date, formatTimeWithoutSeconds)
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Extra exposing (role)
import Html.Events exposing (..)
import Http
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Task
import Time
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
    { departures : Api.Client.Data (List Api.SL.Departures)
    , currentTime : Date
    }


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
            { departures = Api.Client.Loading
            , currentTime = Date (Time.millisToPosix 0) Time.utc
            }
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
    , Cmd.batch
        [ Api.Dashboard.getTodoEntries GetTodoEntriesResponse
        , Api.SL.getEntries GetSLDeparturesRespose
        , Task.perform GetCurrentTime Time.now
        ]
        |> Effect.sendCmd
    )



-- UPDATE


type Msg
    = NoOp
    | TodoAddItem
    | TodoCheckItem Api.Dashboard.TodoEntry Bool
    | TodoOnInput String
    | GetTodoEntriesResponse (Result Http.Error (List Api.Dashboard.TodoEntry))
    | PostTodoEntryResult (Result Http.Error Api.Dashboard.TodoEntry)
    | CompleteTodoEntryResult (Result Http.Error ())
    | GetSLDeparturesRespose (Result Http.Error (List Api.SL.Departures))
    | GetCurrentTime Time.Posix


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Effect.none
            )

        TodoAddItem ->
            ( model, Api.Dashboard.postTodoEntry PostTodoEntryResult (Api.Dashboard.todoEntry model.todo.newItem) |> Effect.sendCmd )

        PostTodoEntryResult (Ok _) ->
            let
                todo =
                    model.todo
            in
            ( { model | todo = { todo | newItem = "" } }, Api.Dashboard.getTodoEntries GetTodoEntriesResponse |> Effect.sendCmd )

        PostTodoEntryResult (Err _) ->
            ( model, Effect.none )

        TodoCheckItem todoEntry True ->
            ( model, Api.Dashboard.completeTodoEntry CompleteTodoEntryResult todoEntry |> Effect.sendCmd )

        TodoCheckItem todoEntry False ->
            ( model, Api.Dashboard.uncompleteTodoEntry CompleteTodoEntryResult todoEntry |> Effect.sendCmd )

        CompleteTodoEntryResult (Ok _) ->
            ( model, Effect.none )

        CompleteTodoEntryResult (Err _) ->
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
            ( { model | todo = { todo | items = Api.Client.Success (List.filter (\x -> not x.isCompleted) items) } }, Effect.none )

        GetTodoEntriesResponse (Err error) ->
            let
                todo =
                    model.todo
            in
            ( { model | todo = { todo | items = Api.Client.Failure error } }, Effect.none )

        GetSLDeparturesRespose (Ok departures) ->
            let
                sl =
                    model.sl
            in
            ( { model | sl = { sl | departures = Api.Client.Success departures } }, Effect.none )

        GetSLDeparturesRespose (Err error) ->
            let
                sl =
                    model.sl
            in
            ( { model | sl = { sl | departures = Api.Client.Failure error } }, Effect.none )

        GetCurrentTime time ->
            let
                sl =
                    model.sl
            in
            ( { model | sl = { sl | currentTime = Date time (Time.customZone 120 []) } }, Api.SL.getEntries GetSLDeparturesRespose |> Effect.sendCmd )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


viewTodo2 : Api.Client.Data (List Api.Dashboard.TodoEntry) -> Html Msg
viewTodo2 items =
    case items of
        Api.Client.Loading ->
            div [ attribute "aria-busy" "true" ] [ text "Loading..." ]

        Api.Client.Failure error ->
            text (Api.Dashboard.getTodoErrorMessage error)

        Api.Client.Success items2 ->
            ul [] (List.map (\item -> div [] [ label [] [ input [ type_ "checkbox", onCheck (TodoCheckItem item) ] [], text item.title ] ]) items2)


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


viewSl2 : SlModel -> Html Msg
viewSl2 model =
    case model.departures of
        Api.Client.Loading ->
            div [ attribute "aria-busy" "true" ] [ text "Loading..." ]

        Api.Client.Failure error ->
            text (Api.SL.getErrorMessage error)

        Api.Client.Success departures ->
            ul []
                [ li []
                    [ text "Lektorsstigen"
                    , ul
                        []
                        (List.map
                            (\departure ->
                                li
                                    []
                                    [ text departure.destination
                                    , text " "
                                    , ins [] [ text departure.display ]
                                    , text " ("
                                    , i [] [ text (formatTimeWithoutSeconds departure.expected) ]
                                    , text ")"
                                    ]
                            )
                            departures
                        )
                    ]
                ]


viewSl : Model -> Html Msg
viewSl model =
    div []
        [ text "SL"
        , viewSl2 model.sl
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
