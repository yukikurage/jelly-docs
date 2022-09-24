module JellyDocs.ClientMain where

import Prelude

import Data.Maybe (fromMaybe)
import Effect (Effect)
import Effect.Aff (joinFiber, launchAff_)
import Effect.Class (liftEffect)
import Jelly.Core.Aff (awaitDocument)
import Jelly.Core.Mount (hydrate)
import Jelly.Generator.Data.StaticData (newStaticData)
import Jelly.Router.Data.Router (newRouter, provideRouterContext)
import JellyDocs.RootComponent (rootComponent)
import Web.HTML.HTMLDocument as HTMLDocument

main :: Effect Unit
main = launchAff_ do
  -- Await Document
  d <- awaitDocument

  -- Make Router
  router <- newRouter (\url -> pure url)

  -- Fetch static Data
  docsFiber <- liftEffect $ newStaticData $ [ "data", "docs.json" ]
  notFoundMDFiber <- liftEffect $ newStaticData $ [ "data", "not-found.json" ]
  topMDFiber <- liftEffect $ newStaticData $ [ "data", "top.json" ]

  docs <- fromMaybe mempty <$> joinFiber docsFiber
  notFoundMD <- fromMaybe "" <$> joinFiber notFoundMDFiber
  topMD <- fromMaybe "" <$> joinFiber topMDFiber

  let
    context = provideRouterContext router { docs, notFoundMD, topMD }

  -- Run App
  void $ liftEffect $ hydrate context rootComponent $ HTMLDocument.toNode d
