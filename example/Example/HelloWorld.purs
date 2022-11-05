module Example.HelloWorld where

import Prelude

import Data.Foldable (traverse_)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Aff (awaitBody)
import Jelly.Component (class Component, text)
import Jelly.Element as JE
import Jelly.Hydrate (mount)
import Signal.Hooks (runHooks_)

main :: Effect Unit
main = launchAff_ do
  appMaybe <- awaitBody
  liftEffect $ runHooks_ $ traverse_ (mount bodyComponent) appMaybe

bodyComponent :: forall m. Component m => m Unit
bodyComponent = do
  JE.h1' do
    text "Hello World!"
