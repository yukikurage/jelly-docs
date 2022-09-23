module JellyDocs.StaticData.Top where

import Prelude

import Effect.Aff (Aff)
import Effect.Class.Console (log)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (readTextFile)

topStaticData :: Aff String
topStaticData = do
  log "docs/overview.md"
  readTextFile UTF8 $ "docs/overview.md"
