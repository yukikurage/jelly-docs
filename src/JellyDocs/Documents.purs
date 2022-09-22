module JellyDocs.Documents where

import Prelude

import Data.Array (concatMap, (:))
import Data.String (joinWith)

data Documents = Documents String (Array Documents)

documents :: Array Documents
documents =
  [ Documents "overview" []
  , Documents "installation" []
  , Documents "tutorials" [ Documents "static-html" [] ]
  ]

documentIds :: Array (Array String)
documentIds = concatMap go documents
  where
  go (Documents id children) =
    let
      chs = concatMap (map (id : _) <<< go) $ children
      root = [ [ id ] ]
    in
      root <> chs

documentIdToPath :: Array String -> String
documentIdToPath id =
  "docs/" <> joinWith "/" id <> ".md"
