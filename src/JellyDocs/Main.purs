module JellyDocs.Main where

import Prelude

import Control.Parallel (parTraverse, parTraverse_)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Foreign.Object (fromFoldable)
import Jelly.Generator.HTML (generateHTML)
import Jelly.Generator.Script (generateScript)
import Jelly.Generator.StaticData (generateStaticData)
import Jelly.Router.Data.Router (mockRouter, provideRouterContext)
import JellyDocs.Api.Doc (docsWithoutContent, getDoc, getDocs, getSections)
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
  -- Generate Static Data
  docItms <- generateStaticData (outDir <> [ "data", "docs.json" ]) getDocs
  sections <- generateStaticData (outDir <> [ "data", "sections.json" ]) getSections
  notFoundMD <- generateStaticData (outDir <> [ "data", "not-found.json" ]) getNotFoundMD
  topMD <- generateStaticData (outDir <> [ "data", "top.json" ]) getTopMD

  docs <- parTraverse (\{ id } -> generateStaticData (outDir <> [ "data", "docs", id <> ".json" ]) (getDoc id)) docItms

  -- Generate Script
  generateScript (outDir <> [ "index.js" ]) "JellyDocs.ClientMain"

  let
    docFibs = fromFoldable $ map (\doc -> doc.id /\ pure (pure doc)) docs
    sectionFibs = fromFoldable $ map (\sectionItm -> sectionItm.id /\ pure (pure sectionItm)) sections
    notFoundFib = pure $ pure notFoundMD
    topFib = pure $ pure topMD

  -- Generate HTML
  let
    genHtml page = do
      router <- mockRouter (pageToUrl page) (\url -> pure url)
      let
        context = provideRouterContext router { docs: docFibs, sections: sectionFibs, notFoundMD: notFoundFib, topMD: topFib }
      generateHTML (outDir <> (pageToUrl page).path <> [ "index.html" ]) context rootComponent

  parTraverse_ genHtml genPages

  pure unit
