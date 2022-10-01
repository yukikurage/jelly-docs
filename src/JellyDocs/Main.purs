module JellyDocs.Main where

import Prelude

import Data.Array (concatMap)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Jelly.Generator.Generate (generate)
import JellyDocs.Api.Doc (getDoc, getSections)
import JellyDocs.Api.NotFound (getNotFoundMD)
import JellyDocs.Api.Top (getTopMD)
import JellyDocs.Data.Page (Page(..), pageToUrl, urlToPage)
import JellyDocs.RootComponent (rootComponent)
import Simple.JSON (writeJSON)

main :: Effect Unit
main = launchAff_ do
  sections <- getSections
  let
    docs = concatMap (_.docs) sections
    docPaths = map (\{ id } -> (pageToUrl $ PageDoc id).path) docs
    paths = docPaths <> map ((_.path) <<< pageToUrl) [ PageTop, PageNotFound ]

  let
    config =
      { output: [ "public" ]
      , clientMain: "JellyDocs.ClientMain"
      , paths
      , getStaticData: \path -> case urlToPage { path, hash: mempty, query: mempty } of
          PageDoc docId -> writeJSON <$> getDoc docId
          PageNotFound -> getNotFoundMD
          PageTop -> getTopMD
      , getGlobalData: pure $ writeJSON sections
      , component: rootComponent
      }

  generate {} config
