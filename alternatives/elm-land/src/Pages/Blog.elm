module Pages.Blog exposing (Model, Msg, page, viewEntry)

import Api.Blog
import Api.Client
import Common.Blog.Entry exposing (Entry)
import Common.Date exposing (formatDate)
import Common.HtmlUtils as HtmlUtils
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
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
    { zone : Time.Zone
    , entries : Api.Client.Data (List Entry)
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { zone = Time.utc
      , entries = Api.Client.Loading
      }
    , Api.Blog.getBlogEntries GetBlogEntriesResponse
        |> Effect.sendCmd
    )



-- UPDATE


type Msg
    = SendGetBlogEntriesRequest
    | GetBlogEntriesResponse (Result Http.Error (List Entry))


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        SendGetBlogEntriesRequest ->
            ( model, Api.Blog.getBlogEntries GetBlogEntriesResponse |> Effect.sendCmd )

        GetBlogEntriesResponse (Ok entries) ->
            ( { model | entries = Api.Client.Success entries }, Effect.none )

        GetBlogEntriesResponse (Err error) ->
            ( { model | entries = Api.Client.Failure error }, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Blog"
    , body =
        [ case model.entries of
            Api.Client.Loading ->
                article [ attribute "aria-busy" "true" ] [ text "Loading..." ]

            Api.Client.Success data ->
                div [ class "blog" ] (viewPosts data)

            Api.Client.Failure error ->
                article [] [ text (Api.Client.getErrorMessage error "") ]
        ]
    }


viewPosts : List Entry -> List (Html Msg)
viewPosts entires =
    List.map viewEntry entires


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
