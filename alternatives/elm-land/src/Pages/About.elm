module Pages.About exposing (Model, Msg, page)

import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes exposing (..)
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


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init () =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "About"
    , body = [ viewAbout model ]
    }


viewAbout : Model -> Html Msg
viewAbout model =
    div [ class "about-container" ]
        [ sectionAboutMe
        , br [] []
        , sectionAboutSite
        ]


sectionAboutMe : Html Msg
sectionAboutMe =
    div [ class "about-section about-me" ]
        [ h1 [] [ text "About Me" ]
        , p [] [ text "Hey there! I'm John Doe, a passionate software engineer with a background in computer science. Ever since I wrote my first 'Hello, World!' program, I've been captivated by the endless possibilities of technology." ]
        , p [] [ text "My journey in the world of programming began during my college days, where I honed my skills in algorithms, data structures, and software design. Over the years, I've delved into various programming languages, from Java and C++ to Python and JavaScript." ]
        , p [] [ text "When I'm not immersed in code, you'll often find me exploring the realms of fantasy through role-playing games or challenging my mind with intricate puzzles. I believe in the power of code to shape the future and the magic of stories to enrich our lives." ]
        , p [] [ text "Feel free to connect with me on social media. Let's embark on this digital adventure together!" ]
        ]


sectionAboutSite : Html Msg
sectionAboutSite =
    div [ class "about-section about-site" ]
        [ h1 [] [ text "About the Site" ]
        , p [] [ text "Welcome to my digital playground, a testament to my love for technology and design. This website is a fusion of my coding expertise and my creative flair, meticulously crafted to showcase the art of frontend development." ]
        , p [] [ text "Built using a combination of Elm, HTML, and CSS, this site reflects my dedication to staying at the forefront of cutting-edge technologies. Elm, with its functional programming paradigm, has enabled me to create a seamless and interactive user experience." ]
        , p [] [ text "The site's responsive design ensures it looks and feels fantastic on various devices, offering a smooth navigation experience. From the intricate animations to the intuitive user interface, every element has been thoughtfully designed to provide both aesthetic pleasure and functional efficiency." ]
        , p [] [ text "Behind the scenes, I've utilized my coding prowess to optimize performance, prioritize security, and ensure a seamless deployment process. This site isn't just a portfolio—it's a living testament to my commitment to innovation and the harmonious blend of technology and creativity." ]
        ]
