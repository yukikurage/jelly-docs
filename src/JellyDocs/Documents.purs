module JellyDocs.Documents where

import Prelude

import Data.Array (concatMap, find)
import Data.Maybe (Maybe)

data Documents = Documents (Array String) String String (Array Documents)

derive instance Eq Documents

rootDocuments :: Array Documents
rootDocuments =
  [ overview
  , installation
  , tutorials
  ]

allDocuments :: Array Documents
allDocuments = go rootDocuments
  where
  go :: Array Documents -> Array Documents
  go [] = []
  go docs = docs <> go (concatMap (\(Documents _ _ _ children) -> children) docs)

overview :: Documents
overview = Documents [] "Overview" "overview" []

installation :: Documents
installation = Documents [] "Installation" "installation" []

tutorials :: Documents
tutorials = Documents [] "Tutorials" "tutorials" [ staticHtml ]

staticHtml :: Documents
staticHtml = Documents [ "tutorials" ] "Static HTML" "static-html" []

documentToPath :: Documents -> Array String
documentToPath (Documents parent _ id _) = parent <> [ id ]

pathToDocument :: Array String -> Maybe Documents
pathToDocument path = find (\doc -> documentToPath doc == path) allDocuments
