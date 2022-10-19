module Example.Counter where

import Prelude

import Data.Tuple.Nested ((/\))
import Jelly.Data.Component (Component, el, el', text, textSig)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop (on)
import Jelly.Data.Signal (modifyAtom_, newStateEq)
import Web.HTML.Event.EventTypes (click)

counterExample :: forall context. Component context
counterExample = hooks do
  countSig /\ countAtom <- newStateEq 0

  pure do
    el "button" [ on click \_ -> modifyAtom_ countAtom (_ + 1) ] $ text "Increment"
    el "button" [ on click \_ -> modifyAtom_ countAtom (_ - 1) ] $ text "Decrement"
    el' "div" do
      text "Count: "
      textSig $ show <$> countSig
