module JellyDocs.Page where

import Prelude

import Data.Map as Map
import Data.Maybe (Maybe(..))
import Jelly.Router.Data.Url (Url)
import JellyDocs.Documents (Documents, documentToPath, pathToDocument)

data Page = PageNotFound | PageDocument Documents | PageTop

derive instance Eq Page

pageToUrl :: Page -> Url
pageToUrl page =
  let
    path = case page of
      PageDocument docId -> documentToPath docId
      PageNotFound -> [ "404" ]
      PageTop -> []
  in
    { path: path
    , query: Map.empty
    , hash: ""
    }

urlToPage :: Url -> Page
urlToPage url =
  case url.path of
    [] -> PageTop
    path | Just doc <- pathToDocument path -> PageDocument doc
    _ -> PageNotFound
