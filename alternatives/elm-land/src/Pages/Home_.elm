module Pages.Home_ exposing (Model, Msg, page)

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
    { title = "Home"
    , body =
        [ div [ class "home" ]
            [ div [ class "welcome-text" ]
                [ h1 [] [ text "Welcome to my personal website!" ]
                , p [] [ text "Embark on a journey through my digital realm—a convergence of passions, creativity, and technology. This multifaceted platform serves as a reflection of my diverse interests, all meticulously curated in one virtual space." ]
                , p [] [ text "As you navigate through these virtual corridors, you'll discover a myriad of captivating features. The heart of this site is my blog—a canvas where thoughts, ideas, and insights come to life. Whether delving into the latest developments in the tech world, sharing experiences from my ventures into various games, or unraveling the intricacies of my coding endeavors, this blog encapsulates my intellectual escapades." ]
                , p [] [ text "Curious about the mind behind the screen? Don't miss the \"About Me\" page, where I unveil the layers that constitute my identity. You'll find the fusion of my background, aspirations, and the journey that led me to this digital crossroads." ]
                , p [] [ text "Speaking of journeys, my corner dedicated to development tools is a testament to my commitment to innovation. Here, you'll unearth resources that have been instrumental in shaping my coding odysseys—tools that streamline processes, enhance efficiency, and bring ideas to life with elegance." ]
                , p [] [ text "But that's not all. For fellow gaming enthusiasts, I've curated an assortment of tools tailored to various games. From guides and strategies to interactive resources, this section adds a new dimension to your gaming escapades." ]
                , p [] [ text "At the heart of it all is a passion for pushing the boundaries of frontend design. This site isn't just a virtual space; it's a testament to the latest trends, an embodiment of captivating aesthetics, and a showcase of what's possible when technology meets creativity." ]
                , p [] [ text "So, welcome once again to my digital haven—a testament to the synergy between artistry, innovation, and exploration. Your journey starts now. Explore, learn, and immerse yourself in all that awaits!" ]
                , p [] [ text "[Your Name]" ]
                ]
            ]
        ]
    }
