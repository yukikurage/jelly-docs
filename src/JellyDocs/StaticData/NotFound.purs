module JellyDocs.StaticData.NotFound where

import Prelude

import Effect.Aff (Aff)
import Effect.Class.Console (log)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (readTextFile)

notFoundStaticData :: Aff String
notFoundStaticData = do
  log "docs/not-found.md"
  readTextFile UTF8 $ "docs/not-found.md"
