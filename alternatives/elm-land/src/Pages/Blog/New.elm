module Pages.Blog.New exposing (Model, Msg, page)

import Api.Blog
import Common.Blog.Entry exposing (Entry)
import Common.Date exposing (Date)
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Layouts
import Page exposing (Page)
import Pages.Blog as Blog
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


type alias Model =
    { entry : Entry
    , getEntriesError : String
    , entries : List Entry
    }


init : () -> ( Model, Effect Msg )
init () =
    ( Model (Entry 0 "" "" (Date (Time.millisToPosix 0) Time.utc) (Date (Time.millisToPosix 0) Time.utc) [] False False) "" []
    , Cmd.batch [ Api.Blog.getBlogEntries BlogEntriesReceived, Task.perform GetCurrentTime Time.now ] |> Effect.sendCmd
    )



-- UPDATE


type Msg
    = UpdateTitle String
    | UpdateContent String
    | UpdateDate String
    | UpdateTags String
    | UpdatePublished Bool
    | LoadEntry Entry
    | Post
    | PostResult (Result Http.Error Entry)
    | Put
    | PutResult (Result Http.Error ())
    | BlogMsg Blog.Msg
    | BlogEntriesReceived (Result Http.Error (List Entry))
    | GetCurrentTime Time.Posix


handleError : Model -> Http.Error -> ( Model, Effect Msg )
handleError model error =
    case error of
        Http.BadUrl errorMsg ->
            ( { model | getEntriesError = "Error (BadUrl): failed to fetch blog entries. " ++ errorMsg }, Effect.none )

        Http.Timeout ->
            ( { model | getEntriesError = "Error (Timeout): failed to fetch blog entries." }, Effect.none )

        Http.NetworkError ->
            ( { model | getEntriesError = "Error (NetworkError): failed to fetch blog entries." }, Effect.none )

        Http.BadStatus errorCode ->
            ( { model | getEntriesError = "Error (BadStatus): failed to fetch blog entries. " ++ String.fromInt errorCode }, Effect.none )

        Http.BadBody errorMsg ->
            ( { model | getEntriesError = "Error (BadBody): failed to fetch blog entries. " ++ errorMsg }, Effect.none )


update : Msg -> Model -> ( Model, Effect Msg )
update msg ({ entry } as model) =
    case msg of
        UpdateTitle newTitle ->
            ( { model | entry = { entry | title = newTitle } }, Effect.none )

        UpdateContent newContent ->
            ( { model | entry = { entry | content = newContent } }, Effect.none )

        UpdateDate newDate ->
            ( { model | entry = { entry | createdAt = Common.Date.parseIso8601ToDateTime newDate } }, Effect.none )

        UpdateTags newTags ->
            ( { model | entry = { entry | tags = String.split "," newTags } }, Effect.none )

        UpdatePublished newPublished ->
            ( { model | entry = { entry | published = newPublished } }, Effect.none )

        GetCurrentTime time ->
            ( { model | entry = { entry | createdAt = Date time Time.utc } }, Effect.none )

        Post ->
            ( model, Cmd.batch [ Api.Blog.postBlogEntry PostResult entry, Api.Blog.getBlogEntries BlogEntriesReceived ] |> Effect.sendCmd )

        PostResult result ->
            case result of
                Ok newEntry ->
                    ( { model | entry = newEntry }, Effect.none )

                Err error ->
                    handleError model error

        Put ->
            ( model, Api.Blog.putBlogEntry PutResult entry |> Effect.sendCmd )

        PutResult _ ->
            ( model, Effect.none )

        BlogEntriesReceived result ->
            case result of
                Ok entries ->
                    ( { model | entries = entries }, Effect.none )

                Err error ->
                    handleError model error

        BlogMsg _ ->
            ( model, Effect.none )

        -- Ignore
        LoadEntry entryToLoad ->
            ( { model | entry = entryToLoad }, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


viewEntriesList : Model -> List (Html Msg)
viewEntriesList model =
    List.map (\x -> button [ class "secondary outline", onClick (LoadEntry x) ] [ text (String.fromInt x.id ++ " " ++ x.title) ]) model.entries


viewPostOrPut : Model -> Html Msg
viewPostOrPut model =
    if model.entry.id == 0 then
        button [ onClick Post ] [ text "Save" ]

    else
        button [ onClick Put ] [ text "Update" ]


view : Model -> View Msg
view model =
    { title = "Blog - New Entry"
    , body =
        [ div [ class "blog-new-entry" ]
            [ div [ class "blog-new-entry-editor grid" ]
                [ div [ class "blog-new-entry-form" ]
                    [ input [ placeholder "Title", type_ "text", onInput UpdateTitle, value model.entry.title ] []
                    , textarea [ placeholder "Content", onInput UpdateContent, value model.entry.content, rows 10 ] []
                    , input [ placeholder "Date", type_ "datetime-local", onInput UpdateDate, value (Common.Date.parseDateTimeToIso8601 model.entry.createdAt) ] []
                    , input [ placeholder "Tags (comma separated)", type_ "text", onInput UpdateTags, value (String.join "," model.entry.tags) ] []
                    , label [ for "newEntryPublishedCheckbox" ]
                        [ input [ type_ "checkbox", id "newEntryPublishedCheckbox", onCheck UpdatePublished, checked model.entry.published ] [ text "Publish" ]
                        , text "Published"
                        ]
                    , viewPostOrPut model
                    ]
                , div [ class "blog-new-entry-list" ]
                    [ ul [] (viewEntriesList model)
                    ]
                ]
            , div [] [ text model.getEntriesError ]
            , div [] [ Blog.viewEntry model.entry |> Html.map BlogMsg ]
            ]
        ]
    }
