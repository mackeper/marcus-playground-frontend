module Pages.Blog.NewEntry exposing (Model, Msg(..), init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Extra exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Modules.Date as Date exposing (Date)
import Pages.Blog.Blog as Blog exposing (Msg(..))
import Pages.Blog.BlogClient as BlogClient
import Pages.Blog.Entry exposing (Entry)
import Platform.Cmd as Cmd
import Route exposing (Route(..))
import Task
import Time


type alias Model =
    { entry : Entry
    , getEntriesError : String
    , entries : List Entry
    }


init : ( Model, Cmd Msg )
init =
    ( Model (Entry 0 "" "" (Date (Time.millisToPosix 0) Time.utc) (Date (Time.millisToPosix 0) Time.utc) [] False False) "" []
    , Cmd.batch [ BlogClient.getBlogEntries BlogEntriesReceived, Task.perform GetCurrentTime Time.now ]
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


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


handleError : Model -> Error -> ( Model, Cmd Msg )
handleError model error =
    case error of
        BadUrl errorMsg ->
            ( { model | getEntriesError = "Error (BadUrl): failed to fetch blog entries. " ++ errorMsg }, Cmd.none )

        Timeout ->
            ( { model | getEntriesError = "Error (Timeout): failed to fetch blog entries." }, Cmd.none )

        NetworkError ->
            ( { model | getEntriesError = "Error (NetworkError): failed to fetch blog entries." }, Cmd.none )

        BadStatus errorCode ->
            ( { model | getEntriesError = "Error (BadStatus): failed to fetch blog entries. " ++ String.fromInt errorCode }, Cmd.none )

        BadBody errorMsg ->
            ( { model | getEntriesError = "Error (BadBody): failed to fetch blog entries. " ++ errorMsg }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ entry } as model) =
    case msg of
        UpdateTitle newTitle ->
            ( { model | entry = { entry | title = newTitle } }, Cmd.none )

        UpdateContent newContent ->
            ( { model | entry = { entry | content = newContent } }, Cmd.none )

        UpdateDate newDate ->
            ( { model | entry = { entry | createdAt = Date.parseIso8601ToDateTime newDate } }, Cmd.none )

        UpdateTags newTags ->
            ( { model | entry = { entry | tags = String.split "," newTags } }, Cmd.none )

        UpdatePublished newPublished ->
            ( { model | entry = { entry | published = newPublished } }, Cmd.none )

        GetCurrentTime time ->
            ( { model | entry = { entry | createdAt = Date time Time.utc } }, Cmd.none )

        Post ->
            ( model, Cmd.batch [ BlogClient.postBlogEntry PostResult entry, BlogClient.getBlogEntries BlogEntriesReceived ] )

        PostResult result ->
            case result of
                Ok newEntry ->
                    ( { model | entry = newEntry }, Cmd.none )

                Err error ->
                    handleError model error

        Put ->
            ( model, BlogClient.putBlogEntry PutResult entry )

        PutResult _ ->
            ( model, Cmd.none )

        BlogEntriesReceived result ->
            case result of
                Ok entries ->
                    ( { model | entries = entries }, Cmd.none )

                Err error ->
                    handleError model error

        BlogMsg _ ->
            ( model, Cmd.none )

        -- Ignore
        LoadEntry entryToLoad ->
            ( { model | entry = entryToLoad }, Cmd.none )


viewEntriesList : Model -> List (Html Msg)
viewEntriesList model =
    List.map (\x -> button [ class "secondary outline", onClick (LoadEntry x) ] [ text (String.fromInt x.id ++ " " ++ x.title) ]) model.entries


viewPostOrPut : Model -> Html Msg
viewPostOrPut model =
    if model.entry.id == 0 then
        button [ onClick Post ] [ text "Save" ]

    else
        button [ onClick Put ] [ text "Update" ]


view : Model -> Html Msg
view model =
    div [ class "blog-new-entry" ]
        [ div [ class "blog-new-entry-editor grid" ]
            [ div [ class "blog-new-entry-form" ]
                [ input [ placeholder "Title", type_ "text", onInput UpdateTitle, value model.entry.title ] []
                , textarea [ placeholder "Content", onInput UpdateContent, value model.entry.content, rows 10 ] []
                , input [ placeholder "Date", type_ "datetime-local", onInput UpdateDate, value (Date.parseDateTimeToIso8601 model.entry.createdAt) ] []
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
