module JellyDocs.WebMain where

import Prelude

import Affjax.Web (driver)
import Data.Foldable (traverse_)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Aff (awaitDocument)
import JellyDocs.AppT (hydrateApp)
import JellyDocs.Hooks.UseWindowHeight (useWindowHeight)
import JellyDocs.RootComponent (rootComponent)
import Signal.Hooks (runHooks_, useHooks_)
import Web.DOM.Document (documentElement)
import Web.DOM.Element (setAttribute)
import Web.HTML (window)
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.Window (document)

main :: Effect Unit
main = launchAff_ do
  -- Await Document
  d <- awaitDocument
  -- Run App
  liftEffect $ runHooks_ do
    whSig <- useWindowHeight
    useHooks_ $ whSig <#> \wh -> liftEffect do
      doc <- document =<< window
      docEl <- documentElement $ HTMLDocument.toDocument doc
      traverse_ (setAttribute "style" ("--window-height: " <> show wh <> "px")) docEl
    hydrateApp rootComponent driver d
