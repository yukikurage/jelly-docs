module Example.HelloWorld.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Core.Aff (awaitQuerySelector)
import Jelly.Core.Data.Component (Component, el_, text)
import Jelly.Core.Mount (mount_)
import Web.DOM.Element as Element
import Web.DOM.ParentNode (QuerySelector(..))

type Context = ()

main :: Effect Unit
main = launchAff_ do
  appMaybe <- awaitQuerySelector (QuerySelector "#app")
  case appMaybe of
    Nothing -> pure unit
    Just app -> liftEffect $ mount_ {} bodyComponent $ Element.toNode app

bodyComponent :: Component Context
bodyComponent = do
  el_ "h1" do
    text $ pure "Hello World!"
