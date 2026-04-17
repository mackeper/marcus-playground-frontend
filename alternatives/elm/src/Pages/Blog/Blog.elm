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


type BlogState
    = Loading
    | Loaded
    | Error String


type alias Model =
    { entries : List Entry
    , test : String
    , zone : Time.Zone
    , state : BlogState
    }


init : ( Model, Cmd Msg )
init =
    ( Model [] "" Time.utc Loading, BlogClient.getBlogEntries GetBlogEntriesResponse )


type Msg
    = SendGetBlogEntriesRequest
    | GetBlogEntriesResponse (Result Http.Error (List Entry))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendGetBlogEntriesRequest ->
            ( model, BlogClient.getBlogEntries GetBlogEntriesResponse )

        GetBlogEntriesResponse result ->
            case result of
                Ok entries ->
                    ( { model | entries = entries, state = Loaded }, Cmd.none )

                Err error ->
                    ( { model | state = Error (BlogClient.getBlogErrorMessage error) }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    case model.state of
        Loading ->
            article [ attribute "aria-busy" "true" ] [ text "Loading..." ]

        Loaded ->
            div [ class "blog" ] (viewPosts model)

        Error error ->
            article [] [ text error ]


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
        , details []
            [ summary [] [ text "\u{200E}" ]
            , p [] (HtmlUtils.textHtml (viewContent entry.content))
            ]
        ]
