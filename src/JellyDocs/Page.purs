module JellyDocs.Page where

import Prelude

import Jelly.Router.Data.Url (Url)
import Data.Map as Map

-- | File Path (e.g. ["overview"], ["tutorials", "static-html"])
type DocumentId = Array String

data Page = PageNotFound | PageDocument DocumentId

derive instance Eq Page

pageToUrl :: Page -> Url
pageToUrl page =
  let
    path = case page of
      PageNotFound -> [ "404" ]
      PageDocument [ "overview" ] -> []
      PageDocument docId -> docId
  in
    { path: path
    , query: Map.empty
    , hash: ""
    }

urlToPage :: Url -> Page
urlToPage url =
  case url.path of
    [ "404" ] -> PageNotFound
    [] -> PageDocument [ "overview" ]
    path -> PageDocument path
