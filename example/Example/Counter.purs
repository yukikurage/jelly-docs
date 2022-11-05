module Example.Counter where

import Prelude

import Data.Tuple.Nested ((/\))
import Jelly.Component (class Component, text, textSig)
import Jelly.Element as JE
import Jelly.Prop (on)
import Signal (modifyChannel, newState)
import Web.HTML.Event.EventTypes (click)

counterExample :: forall m. Component m => m Unit
counterExample = do
  countSig /\ countChannel <- newState 0

  JE.button [ on click \_ -> modifyChannel countChannel (_ + 1) ] $ text "Increment"
  JE.button [ on click \_ -> modifyChannel countChannel (_ - 1) ] $ text "Decrement"
  JE.div' do
    text "Count: "
    textSig $ show <$> countSig
