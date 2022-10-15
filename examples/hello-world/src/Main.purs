module Example.HelloWorld.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Aff (awaitQuerySelector)
import Jelly.Data.Component (Component, el', text)
import Jelly.Mount (mount_)
import Web.DOM.ParentNode (QuerySelector(..))

type Context :: forall k. Row k
type Context = ()

main :: Effect Unit
main = launchAff_ do
  appMaybe <- awaitQuerySelector (QuerySelector "#app")
  case appMaybe of
    Nothing -> pure unit
    Just app -> liftEffect $ mount_ {} bodyComponent app

bodyComponent :: Component Context
bodyComponent = do
  el' "h1" do
    text "Hello World!"
