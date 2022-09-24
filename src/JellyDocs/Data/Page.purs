module JellyDocs.Data.Page where

import Prelude

import Jelly.Router.Data.Url (Url)

data Page = PageNotFound | PageDoc String | PageTop

derive instance Eq Page

pageToUrl :: Page -> Url
pageToUrl page =
  let
    path = case page of
      PageDoc docId -> [ "docs", docId ]
      PageNotFound -> [ "404" ]
      PageTop -> []
  in
    { path: path
    , query: mempty
    , hash: ""
    }

urlToPage :: Url -> Page
urlToPage url =
  case url.path of
    [] -> PageTop
    [ "docs", docId ] -> PageDoc docId
    _ -> PageNotFound
