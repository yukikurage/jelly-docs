module JellyDocs.ClientMain where

import Prelude

import Control.Parallel (parTraverse)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Foreign.Object (fromFoldable, lookup)
import Jelly.Core.Aff (awaitDocument)
import Jelly.Core.Mount (hydrate)
import Jelly.Generator.Data.StaticData (loadStaticData, newStaticData)
import Jelly.Router.Data.Router (newRouter, provideRouterContext)
import JellyDocs.Data.Doc (DocListItem)
import JellyDocs.Data.Page (Page(..), urlToPage)
import JellyDocs.Data.Section (Section)
import JellyDocs.RootComponent (rootComponent)
import Web.HTML.HTMLDocument as HTMLDocument

main :: Effect Unit
main = launchAff_ do
  -- Await Document
  d <- awaitDocument

  -- Fetch static Data
  docsFiber <- liftEffect $ newStaticData $ [ "data", "docs.json" ]
  sectionsFiber <- liftEffect $ newStaticData $ [ "data", "sections.json" ]
  notFoundMDFiber <- liftEffect $ newStaticData $ [ "data", "not-found.json" ]
  topMDFiber <- liftEffect $ newStaticData $ [ "data", "top.json" ]

  docs :: Array DocListItem <- fromMaybe mempty <$> loadStaticData docsFiber
  sections :: Array Section <- fromMaybe mempty <$> loadStaticData sectionsFiber

  docsContext <- fromFoldable <$> flip parTraverse docs \doc -> do
    sd <- liftEffect $ newStaticData [ "data", "docs", doc.id <> ".json" ]
    pure $ doc.id /\ sd

  void $ loadStaticData notFoundMDFiber
  void $ loadStaticData topMDFiber

  let
    sectionsContext = fromFoldable $ map (\sct -> sct.id /\ pure (pure sct)) sections

  let
    beforeEach url = case urlToPage url of
      PageDoc docId | Just sd <- lookup docId docsContext -> do
        void $ loadStaticData sd
        pure url
      _ -> pure url
  -- Make Router
  router <- newRouter beforeEach

  let
    context = provideRouterContext router
      { docs: docsContext
      , notFoundMD: notFoundMDFiber
      , topMD: topMDFiber
      , sections: sectionsContext
      }

  -- Run App
  void $ liftEffect $ hydrate context rootComponent $ HTMLDocument.toNode d
