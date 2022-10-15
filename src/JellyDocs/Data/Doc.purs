module JellyDocs.Data.Doc
  ( DocListItem
  ) where

type Doc =
  { id :: String
  , title :: String
  , content :: String
  , section :: String
  }

type DocListItem =
  { id :: String
  , title :: String
  , section :: String
  }
