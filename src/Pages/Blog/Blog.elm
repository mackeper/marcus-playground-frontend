module Pages.Blog.Blog exposing (Model, Msg, init, subscriptions, update, view, viewEntry)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http exposing (Error(..))
import Modules.Date exposing (formatDate)
import Modules.HtmlUtils as HtmlUtils
import Pages.Blog.BlogClient as BlogClient
import Pages.Blog.Entry exposing (Entry)
import Platform.Cmd as Cmd
import Time


type alias Model =
    { entries : List Entry
    , test : String
    , zone : Time.Zone
    }


init : ( Model, Cmd Msg )
init =
    ( Model [] "" Time.utc, BlogClient.getBlogEntries DataReceived )


type Msg
    = SendHttpRequest
    | DataReceived (Result Http.Error (List Entry))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendHttpRequest ->
            ( model, BlogClient.getBlogEntries DataReceived )

        DataReceived result ->
            case result of
                Ok entries ->
                    ( { model | entries = entries, test = "" }, Cmd.none )

                Err error ->
                    case error of
                        BadUrl errorMsg ->
                            ( { model | test = "Error (BadUrl): failed to fetch blog entries. " ++ errorMsg }, Cmd.none )

                        Timeout ->
                            ( { model | test = "Error (Timeout): failed to fetch blog entries." }, Cmd.none )

                        NetworkError ->
                            ( { model | test = "Error (NetworkError): failed to fetch blog entries." }, Cmd.none )

                        BadStatus errorCode ->
                            ( { model | test = "Error (BadStatus): failed to fetch blog entries. " ++ String.fromInt errorCode }, Cmd.none )

                        BadBody errorMsg ->
                            ( { model | test = "Error (BadBody): failed to fetch blog entries. " ++ errorMsg }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div [ class "blog" ]
        [ h1 [] [ text model.test ]
        , div [] (viewPosts model)
        ]


viewPosts : Model -> List (Html Msg)
viewPosts model =
    List.map viewEntry model.entries


viewTags : Entry -> List (Html Msg)
viewTags entry =
    List.map (\tag -> code [ class "blog-tag" ] [ text tag ]) entry.tags


viewContent : String -> String
viewContent content =
    String.lines content |> List.map (\x -> "<p>" ++ x ++ "</p>") |> String.join ""


viewEntry : Entry -> Html Msg
viewEntry entry =
    article [ class "blog-entry" ]
        [ header [ class "headings" ]
            [ h2 [] [ text entry.title ]
            , h3 [] [ text (formatDate entry.createdAt) ]
            , p [] (viewTags entry)
            ]
        , p [] (HtmlUtils.textHtml (viewContent entry.content))
        ]
