module JellyDocs.Api.Doc where

import Prelude

import Data.Array (concatMap, find)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Jelly.Router.Data.Path (makeRelativeFilePath)
import JellyDocs.Data.Doc (Doc, DocListItem)
import JellyDocs.Data.Section (Section)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (readTextFile)

getDocs :: Aff (Array DocListItem)
getDocs = pure $ concatMap (_.docs) sections

getDoc :: String -> Aff Doc
getDoc docId = do
  docsData <- getDocs
  let
    doc = find (\d -> d.id == docId) docsData

    getDocContent :: DocListItem -> Aff Doc
    getDocContent { id, title, section } = do
      content <- readTextFile UTF8 $ (makeRelativeFilePath [ "docs", section, id <> ".md" ])
      pure { id, title, section, content }
  case doc of
    Just d -> getDocContent d
    Nothing -> pure { id: "", title: "", section: "", content: "" }

getSections :: Aff (Array Section)
getSections = pure $ sections

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
    , title: "Getting Started"
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
    , title: "Core Concepts"
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
    , title: "Advanced Topics"
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
