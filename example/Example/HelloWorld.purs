module Example.HelloWorld where

import Prelude

import Data.Foldable (traverse_)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Aff (awaitBody)
import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Hooks (runHooks_)
import Jelly.Hydrate (mount)

main :: Effect Unit
main = launchAff_ do
  appMaybe <- awaitBody
  liftEffect $ runHooks_ $ traverse_ (mount helloComponent) appMaybe

helloComponent :: forall m. Component m
helloComponent = do
  JE.div' do
    text "Hello World! "
    text "this is component"

hello3Component :: forall m. Component m
hello3Component = do
  helloComponent
  helloComponent
  helloComponent
