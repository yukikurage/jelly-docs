module Example.SignalC where

import Prelude

import Data.Tuple.Nested ((/\))
import Jelly (Component, hooks, on, signalC, text, textSig)
import Jelly.Data.Signal (modifyAtom_, newStateEq)
import Jelly.Element as JE
import Web.HTML.Event.EventTypes (click)

signalCExample :: forall context. Component context
signalCExample = hooks do
  componentNumSig /\ componentNumAtom <- newStateEq 1
  pure do
    JE.button [ on click \_ -> modifyAtom_ componentNumAtom (_ + 1) ] $ text "Increment"
    JE.button [ on click \_ -> modifyAtom_ componentNumAtom (_ - 1) ] $ text "Decrement"
    JE.div' do
      textSig $ pure "Component number: " <> show <$> componentNumSig
    JE.div' do
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
