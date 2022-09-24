module JellyDocs.Main where

import Prelude

import Control.Parallel (parTraverse_)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Jelly.Generator.HTML (generateHTML)
import Jelly.Generator.Script (generateScript)
import Jelly.Generator.StaticData (generateStaticData)
import Jelly.Router.Data.Router (mockRouter, provideRouterContext)
import JellyDocs.Api.Doc (docsWithoutContent, getDocs)
import JellyDocs.Api.NotFound (getNotFoundMD)
import JellyDocs.Api.Top (getTopMD)
import JellyDocs.Data.Page (Page(..), pageToUrl)
import JellyDocs.RootComponent (rootComponent)

outDir :: Array String
outDir = [ "public" ]

main :: Effect Unit
main = launchAff_ do
  let
    genPages = [ PageTop, PageNotFound ] <> map (\{ id } -> PageDoc id) docsWithoutContent

  docs <- getDocs
  notFoundMD <- getNotFoundMD
  topMD <- getTopMD

  -- Generate Script
  generateScript (outDir <> [ "index.js" ]) "JellyDocs.ClientMain"

  -- Generate HTML
  let
    genHtml page = do
      router <- mockRouter (pageToUrl page) (\url -> pure url)
      let
        context = provideRouterContext router { docs, notFoundMD, topMD }
      generateHTML (outDir <> (pageToUrl page).path <> [ "index.html" ]) context rootComponent

  parTraverse_ genHtml genPages

  -- Generate Static Data
  _ <- generateStaticData (outDir <> [ "data", "docs.json" ]) $ pure docs
  _ <- generateStaticData (outDir <> [ "data", "not-found.json" ]) $ pure notFoundMD
  _ <- generateStaticData (outDir <> [ "data", "top.json" ]) $ pure topMD

  pure unit
