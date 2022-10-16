module Example.Context where

import Prelude

import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Jelly.Data.Component (Component, el, text, textSig)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop (on)
import Jelly.Data.Signal (Atom, Signal, patch_, signal)
import Jelly.Hooks.UseContext (useContext)
import Jelly.Mount (mount_)
import Web.DOM (Node)
import Web.HTML.Event.EventTypes (click)

type Context = (countState :: Signal Int /\ Atom Int)

mountWithContext :: Node -> Effect Unit
mountWithContext node = do
  countState <- signal 0
  mount_ { countState } parentComponent node

parentComponent :: Component Context
parentComponent = hooks do
  { countState: _ /\ countAtom } <- useContext

  pure do
    el "button" [ on click \_ -> patch_ countAtom (add 1) ] $ text "Increment"
    childComponent

childComponent :: Component Context
childComponent = hooks do
  { countState: countSig /\ _ } <- useContext

  pure do
    textSig $ show <$> countSig
