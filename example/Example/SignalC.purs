module Example.SignalC where

import Prelude

import Data.Tuple.Nested ((/\))
import Jelly.Data.Component (Component, el, el', signalC, text, textSig)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop (on)
import Jelly.Data.Signal (patch_, signal)
import Web.HTML.Event.EventTypes (click)

signalCExample :: forall context. Component context
signalCExample = hooks do
  componentNumSig /\ componentNumAtom <- signal 1
  pure do
    el "button" [ on click \_ -> patch_ componentNumAtom (_ + 1) ] $ text "Increment"
    el "button" [ on click \_ -> patch_ componentNumAtom (_ - 1) ] $ text "Decrement"
    el' "div" do
      textSig $ pure "Component number: " <> show <$> componentNumSig
    el' "div" do
      signalC do
        componentNum <- componentNumSig
        pure case componentNum of
          1 -> component1
          2 -> component2
          3 -> component3
          _ -> text "No such component"

component1 :: forall context. Component context
component1 = text "This is component 1"

component2 :: forall context. Component context
component2 = text "This is component 2"

component3 :: forall context. Component context
component3 = text "This is component 3"
