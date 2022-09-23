module JellyDocs.Page where

import Prelude

import Data.Map as Map
import Data.Maybe (Maybe(..))
import Jelly.Router.Data.Url (Url)
import JellyDocs.Documents (Documents, documentToPath, overview, pathToDocument)

data Page = PageNotFound (Array String) | PageDocument Documents

derive instance Eq Page

pageToUrl :: Page -> Url
pageToUrl page =
  let
    path = case page of
      PageDocument doc | doc == overview -> []
      PageDocument docId -> documentToPath docId
      PageNotFound pt -> pt
  in
    { path: path
    , query: Map.empty
    , hash: ""
    }

urlToPage :: Url -> Page
urlToPage url =
  case url.path of
    [] -> PageDocument $ overview
    path | Just doc <- pathToDocument path -> PageDocument doc
    path -> PageNotFound path
