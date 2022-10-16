module Example.Counter where

import Prelude

import Data.Tuple.Nested ((/\))
import Jelly.Data.Component (Component, el, el', text, textSig)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop (on)
import Jelly.Data.Signal (patch_, signal)
import Web.HTML.Event.EventTypes (click)

counterExample :: forall context. Component context
counterExample = hooks do
  countSig /\ countAtom <- signal 0

  pure $ el' "div" do
    el "button" [ on click \_ -> patch_ countAtom (_ + 1) ] $ text "Increment"
    el "button" [ on click \_ -> patch_ countAtom (_ - 1) ] $ text "Decrement"
    el' "div" do
      text "Count: "
      textSig $ show <$> countSig
