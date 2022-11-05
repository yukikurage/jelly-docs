module Example.Switching where

import Prelude

import Data.Tuple.Nested ((/\))
import Jelly.Component (class Component, text, textSig)
import Jelly.Element as JE
import Jelly.Prop (on)
import Signal (modifyChannel)
import Signal.Hooks (newStateEq, useHooks_)
import Web.HTML.Event.EventTypes (click)

switchingExample :: forall m. Component m => m Unit
switchingExample = do
  componentNumSig /\ componentNumChannel <- newStateEq 1

  JE.button [ on click \_ -> modifyChannel componentNumChannel (_ + 1) ] $ text "Increment"
  JE.button [ on click \_ -> modifyChannel componentNumChannel (_ - 1) ] $ text "Decrement"
  JE.div' do
    textSig $ pure "Component number: " <> show <$> componentNumSig
  JE.div' do
    useHooks_ do
      componentNum <- componentNumSig
      pure case componentNum of
        1 -> component1
        2 -> component2
        3 -> component3
        _ -> text "No such component"

component1 :: forall m. Component m => m Unit
component1 = text "This is component 1"

component2 :: forall m. Component m => m Unit
component2 = text "This is component 2"

component3 :: forall m. Component m => m Unit
component3 = text "This is component 3"
