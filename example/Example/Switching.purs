module Example.Switching where

import Prelude

import Data.Tuple.Nested ((/\))
import Jelly.Component (Component, hooks, switch, text, textSig)
import Jelly.Element as JE
import Jelly.Hooks (class MonadHooks, useStateEq)
import Jelly.Prop (on)
import Jelly.Signal (modifyChannel_)
import Web.HTML.Event.EventTypes (click)

switchingExample :: forall m. MonadHooks m => Component m
switchingExample = hooks do
  componentNumSig /\ componentNumChannel <- useStateEq 1

  pure do
    JE.button [ on click \_ -> modifyChannel_ componentNumChannel (_ + 1) ] $ text "Increment"
    JE.button [ on click \_ -> modifyChannel_ componentNumChannel (_ - 1) ] $ text "Decrement"
    JE.div' do
      textSig $ pure "Component number: " <> show <$> componentNumSig
    JE.div' do
      switch $ componentNumSig <#> case _ of
        1 -> component1
        2 -> component2
        3 -> component3
        _ -> text "No such component"

component1 :: forall m. Component m
component1 = text "This is the first component"

component2 :: forall m. Component m
component2 = text "This is the second component"

component3 :: forall m. Component m
component3 = text "This is the third component"
