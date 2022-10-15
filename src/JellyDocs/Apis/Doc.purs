module JellyDocs.Apis.Doc where

import Prelude

import Affjax (AffjaxDriver, Error(..), get)
import Affjax.ResponseFormat (string)
import Data.Array (concatMap, find)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Jelly.Router.Data.Path (makeRelativeFilePath)
import JellyDocs.Apis.BasePath (apiBasePath)
import JellyDocs.Data.Doc (Doc, DocListItem)
import JellyDocs.Data.Section (Section)

getDocs :: AffjaxDriver -> Aff (Either Error (Array DocListItem))
getDocs _ = pure $ pure $ concatMap (_.docs) sections

getDoc :: AffjaxDriver -> String -> Aff (Either Error Doc)
getDoc driver docId = do
  let
    docListItem = find (\d -> d.id == docId) docsWithoutContent

    getDocContent :: DocListItem -> Aff (Either Error Doc)
    getDocContent { id, title, section } = do
      resEither <- get driver string $ apiBasePath <> makeRelativeFilePath [ "docs", "en", section, id <> ".md" ]
      pure $ resEither <#> \res -> { id, title, section, content: res.body }
  case docListItem of
    Just d -> getDocContent d
    Nothing -> pure $ Left RequestFailedError

getSections :: AffjaxDriver -> Aff (Either Error (Array Section))
getSections _ = pure $ pure $ sections

docsWithoutContent :: Array DocListItem
docsWithoutContent =
  [ { id: "installation"
    , title: "Installation"
    , section: "getting-started"
    }
  , { id: "hello-world"
    , title: "Hello World"
    , section: "getting-started"
    }
  , { id: "static-html"
    , title: "Static HTML"
    , section: "core-concepts"
    }
  , { id: "context"
    , title: "Context"
    , section: "core-concepts"
    }
  , { id: "spa-routing"
    , title: "SPA Routing"
    , section: "advanced-topics"
    }
  , { id: "generate-static-app"
    , title: "Generate Static App"
    , section: "advanced-topics"
    }
  , { id: "hydration"
    , title: "Hydration"
    , section: "advanced-topics"
    }
  ]

sections :: Array Section
sections =
  [ { id: "getting-started"
    , title: "🚀 Getting Started"
    , docs:
        [ { id: "installation"
          , title: "Installation"
          , section: "getting-started"
          }
        , { id: "hello-world"
          , title: "Hello World"
          , section: "getting-started"
          }
        ]
    }
  , { id: "core-concepts"
    , title: "🏗️ Core Concepts"
    , docs:
        [ { id: "static-html"
          , title: "Static HTML"
          , section: "core-concepts"
          }
        , { id: "context"
          , title: "Context"
          , section: "core-concepts"
          }
        ]
    }
  , { id: "advanced-topics"
    , title: "🔧 Advanced Topics"
    , docs:
        [ { id: "spa-routing"
          , title: "SPA Routing"
          , section: "advanced-topics"
          }
        , { id: "generate-static-app"
          , title: "Generate Static App"
          , section: "advanced-topics"
          }
        , { id: "hydration"
          , title: "Hydration"
          , section: "advanced-topics"
          }
        ]
    }
  ]