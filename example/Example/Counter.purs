module Example.Counter where

import Prelude

import Data.Tuple.Nested ((/\))
import Jelly (Component, hooks, on, text, textSig)
import Jelly.Data.Signal (modifyAtom_, newStateEq)
import Jelly.Element as JE
import Web.HTML.Event.EventTypes (click)

counterExample :: forall context. Component context
counterExample = hooks do
  countSig /\ countAtom <- newStateEq 0

  pure do
    JE.button [ on click \_ -> modifyAtom_ countAtom (_ + 1) ] $ text "Increment"
    JE.button [ on click \_ -> modifyAtom_ countAtom (_ - 1) ] $ text "Decrement"
    JE.div' do
      text "Count: "
      textSig $ show <$> countSig
