module JellyDocs.Api.Top where

import Prelude

import Effect.Aff (Aff)
import Effect.Class.Console (log)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (readTextFile)

getTopMD :: Aff String
getTopMD = do
  log "docs/overview.md"
  readTextFile UTF8 $ "docs/en/overview.md"
