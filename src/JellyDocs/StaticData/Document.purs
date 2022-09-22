module JellyDocs.StaticData.Document where

import Prelude

import Effect.Aff (Aff)
import Effect.Class.Console (log)
import JellyDocs.Documents (documentIdToPath)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (readTextFile)

documentStaticData :: Array String -> Aff String
documentStaticData documentId = do
  log $ documentIdToPath documentId
  readTextFile UTF8 $ documentIdToPath documentId
