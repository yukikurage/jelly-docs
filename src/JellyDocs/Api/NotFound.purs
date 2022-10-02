module JellyDocs.Api.NotFound where

import Prelude

import Effect.Aff (Aff)
import Effect.Class.Console (log)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (readTextFile)

getNotFoundMD :: Aff String
getNotFoundMD = do
  log "docs/not-found.md"
  readTextFile UTF8 $ "docs/en/not-found.md"
