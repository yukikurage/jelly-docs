module JellyDocs.ClientMain where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Core.Aff (awaitDocument)
import Jelly.Core.Hydrate (hydrate_)
import Jelly.Generator.Data.StaticData (newStaticData, provideStaticDataContext)
import Jelly.Router.Data.Router (newRouter, provideRouterContext)
import JellyDocs.RootComponent (rootComponent)
import Web.HTML.HTMLDocument as HTMLDocument

main :: Effect Unit
main = launchAff_ do
  -- Await Document
  d <- awaitDocument

  staticData@{ loadData } <- newStaticData []

  let
    beforeEach url = do
      void $ loadData url.path
      pure url

  -- Make Router
  router <- newRouter [] beforeEach

  let
    context = provideRouterContext router $ provideStaticDataContext staticData {}

  -- Run App
  liftEffect $ hydrate_ context rootComponent $ HTMLDocument.toNode d
