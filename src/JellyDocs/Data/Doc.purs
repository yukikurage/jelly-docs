module JellyDocs.Data.Doc where

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
