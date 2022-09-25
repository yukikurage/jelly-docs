module JellyDocs.Data.Section where

import JellyDocs.Data.Doc (DocListItem)

type Section =
  { id :: String
  , title :: String
  , docs :: Array DocListItem
  }
