module Example.HelloWorld.Main where

import Prelude

import Data.Foldable (traverse_)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Aff (awaitBody)
import Jelly.Data.Component (Component, el', text)
import Jelly.Mount (mount_)

type Context :: Row Type
type Context = ()

main :: Effect Unit
main = launchAff_ do
  appMaybe <- awaitBody
  liftEffect $ traverse_ (mount_ {} bodyComponent) appMaybe

bodyComponent :: Component Context
bodyComponent = do
  el' "h1" do
    text "Hello World!"
