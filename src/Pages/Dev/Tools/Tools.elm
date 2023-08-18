module Pages.Dev.Tools.Tools exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)


type alias Tool =
    { id : Int
    , title : String
    , text : String
    }


type alias Model =
    { tools : List Tool
    }


init : ( Model, Cmd Msg )
init =
    ( Model sampleTools, Cmd.none )


type Msg
    = Msg1
    | Msg2


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg1 ->
            ( model, Cmd.none )

        Msg2 ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div [ class "dev-tools" ]
        (viewPosts model)


viewPosts : Model -> List (Html msg)
viewPosts model =
    List.map viewPost model.tools


viewPost : Tool -> Html msg
viewPost post =
    div [ class "tool" ]
        [ h1 [] [ text post.title ]
        , div [] [ text post.text ]
        ]


sampleTools : List Tool
sampleTools =
    [ { id = 1
      , title = "Node.js"
      , text = "A runtime environment that allows running JavaScript on the server, enabling powerful backend development."
      }
    , { id = 2
      , title = "Express.js"
      , text = "A minimal and flexible Node.js web application framework that simplifies building APIs and web applications."
      }
    , { id = 3
      , title = "Django"
      , text = "A high-level Python web framework that encourages rapid development, clean design, and pragmatic programming."
      }
    , { id = 4
      , title = "Flask"
      , text = "A lightweight Python web framework that focuses on simplicity and flexibility, perfect for small to medium-sized applications."
      }
    , { id = 5
      , title = "Ruby on Rails"
      , text = "A web application framework written in Ruby that emphasizes convention over configuration and follows the MVC pattern."
      }
    , { id = 6
      , title = "Spring Boot"
      , text = "A framework for building Java applications that simplifies the development of production-ready applications with minimal setup."
      }
    , { id = 7
      , title = "Laravel"
      , text = "A PHP web application framework known for its elegant syntax, expressive design, and robust features."
      }
    , { id = 8
      , title = "ASP.NET Core"
      , text = "A cross-platform, high-performance framework for building modern, cloud-based, and internet-connected applications."
      }
    , { id = 9
      , title = "FastAPI"
      , text = "A modern, fast, web framework for building APIs with Python 3.7+ based on standard Python type hints."
      }
    , { id = 10
      , title = "PostgreSQL"
      , text = "A powerful, open-source relational database system known for its extensibility, stability, and strong support for SQL."
      }
    , { id = 11
      , title = "MongoDB"
      , text = "A NoSQL database that provides scalability and flexibility for managing unstructured and semi-structured data."
      }
    , { id = 12
      , title = "Redis"
      , text = "An in-memory data store that accelerates data access and caching for high-performance applications."
      }
    , { id = 13
      , title = "GraphQL"
      , text = "A query language for APIs that provides a more efficient, flexible, and organized approach to data fetching."
      }
    , { id = 14
      , title = "Docker"
      , text = "A platform for developing, shipping, and running applications using containerization for consistent and isolated environments."
      }
    , { id = 15
      , title = "Kubernetes"
      , text = "An open-source container orchestration platform for automating deployment, scaling, and management of applications."
      }
    , { id = 16
      , title = "Jenkins"
      , text = "An open-source automation server that helps automate building, testing, and deploying applications."
      }
    , { id = 17
      , title = "Elasticsearch"
      , text = "A distributed, RESTful search and analytics engine designed for horizontal scalability, reliability, and real-time search capabilities."
      }
    , { id = 18
      , title = "RabbitMQ"
      , text = "An open-source message broker that facilitates communication between various services and applications."
      }
    , { id = 19
      , title = "GraphQL"
      , text = "A query language for APIs that provides a more efficient, flexible, and organized approach to data fetching."
      }
    , { id = 20
      , title = "Prometheus"
      , text = "An open-source monitoring and alerting toolkit designed for reliability and scalability in dynamic environments."
      }
    ]
