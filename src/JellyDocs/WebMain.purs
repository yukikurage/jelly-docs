module JellyDocs.WebMain where

import Prelude

import Affjax.Web (driver)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Aff (awaitDocument)
import JellyDocs.AppT (hydrateApp)
import JellyDocs.RootComponent (rootComponent)
import Signal.Hooks (runHooks_)

main :: Effect Unit
main = launchAff_ do
  -- Await Document
  d <- awaitDocument
  -- Run App
  liftEffect $ runHooks_ $ hydrateApp rootComponent driver d
