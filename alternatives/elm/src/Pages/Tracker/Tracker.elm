module Pages.Tracker.Tracker exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Pages.Tracker.TrackerClient as TrackerClient
import Pages.Tracker.Visits exposing (Visits)


type PageState
    = Loading
    | Loaded Visits
    | Error String


type alias Model =
    { pageState : PageState
    }


init : ( Model, Cmd Msg )
init =
    ( Model Loading, TrackerClient.getVisits GetVisitsResponse )


type Msg
    = SendGetVisitsRequest
    | GetVisitsResponse (Result Http.Error Visits)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendGetVisitsRequest ->
            ( model, Cmd.none )

        GetVisitsResponse response ->
            case response of
                Ok visits ->
                    ( { model | pageState = Loaded visits }, Cmd.none )

                Err error ->
                    ( { model | pageState = Error (TrackerClient.getGetVisitsErrorMessage error) }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewTracker : Visits -> Html Msg
viewTracker visits =
    article []
        [ text ("Visits: " ++ String.fromInt visits.count)
        ]


viewLoading : Html Msg
viewLoading =
    article [ attribute "aria-busy" "true" ]
        [ text "Loading..." ]


view : Model -> Html Msg
view model =
    case model.pageState of
        Loading ->
            viewLoading

        Loaded visits ->
            viewTracker visits

        Error error ->
            article []
                [ text error ]
