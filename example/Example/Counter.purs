module Example.Counter where

import Prelude

import Data.Tuple.Nested ((/\))
import Jelly.Component (Component, hooks, text, textSig)
import Jelly.Element as JE
import Jelly.Hooks (class MonadHooks)
import Jelly.Prop (on)
import Jelly.Signal (modifyChannel_, newState)
import Web.HTML.Event.EventTypes (click)

counterExample :: forall m. MonadHooks m => Component m
counterExample = hooks do
  countSig /\ countChannel <- newState 0

  pure do
    JE.button [ on click \_ -> modifyChannel_ countChannel (_ + 1) ] $ text "Increment"
    JE.button [ on click \_ -> modifyChannel_ countChannel (_ - 1) ] $ text "Decrement"
    JE.div' do
      text "Count: "
      textSig $ show <$> countSig
