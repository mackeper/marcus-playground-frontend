module Pages.Tracker exposing (Model, Msg, page)

import Api.Client exposing (..)
import Api.Tracker
import Common.Tracker.Visits exposing (Visits)
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Layouts
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


type alias Model =
    { visits : Api.Client.Data Visits
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { visits = Loading }
    , Api.Tracker.getVisits GetVisitsResponse |> Effect.sendCmd
    )



-- UPDATE


type Msg
    = SendGetVisitsRequest
    | GetVisitsResponse (Result Http.Error Visits)


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        SendGetVisitsRequest ->
            ( model, Effect.none )

        GetVisitsResponse response ->
            case response of
                Ok visits ->
                    ( { model | visits = Api.Client.Success visits }, Effect.none )

                Err error ->
                    ( { model | visits = Api.Client.Failure error }, Effect.none )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


viewTracker : Visits -> Html Msg
viewTracker visits =
    article []
        [ text ("Visits: " ++ String.fromInt visits.count)
        ]


viewLoading : Html Msg
viewLoading =
    article [ attribute "aria-busy" "true" ]
        [ text "Loading..." ]


view : Model -> View Msg
view model =
    { title = "Tracker"
    , body = [
    case model.visits of
        Loading ->
            viewLoading

        Api.Client.Success visits ->
            viewTracker visits

        Api.Client.Failure error ->
            article []
                [ text (Api.Tracker.getGetVisitsErrorMessage error) ]
                ]}
