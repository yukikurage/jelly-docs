module JellyDocs.Api.Doc where

import Prelude

import Control.Parallel (parTraverse)
import Data.Array (filter)
import Data.Tuple.Nested (type (/\), (/\))
import Effect.Aff (Aff)
import Foreign.Object (Object, fromFoldable)
import Jelly.Router.Data.Path (makeRelativeFilePath)
import JellyDocs.Data.Doc (Doc)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (readTextFile)

type DocWithoutContent = { id :: String, title :: String, section :: String }

getDocs :: Aff (Object (Object Doc))
getDocs = fromFoldable <$> parTraverse getSectionDocs sections
  where
  getSectionDocs :: String -> Aff (String /\ Object Doc)
  getSectionDocs sec = do
    sectionDocs <- fromFoldable <$> parTraverse getDocContent (filter (\{ section } -> section == sec) docsWithoutContent)
    pure $ sec /\ sectionDocs
    where
    getDocContent :: DocWithoutContent -> Aff (String /\ Doc)
    getDocContent { id, title, section } = do
      content <- readTextFile UTF8 $ (makeRelativeFilePath [ "docs", section, id <> ".md" ])
      pure $ id /\ { id, title, section, content }

sections :: Array String
sections = [ "getting-started", "core-concepts", "advanced-topics" ]

docsWithoutContent :: Array DocWithoutContent
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
