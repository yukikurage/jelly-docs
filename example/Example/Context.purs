module Example.Context where

import Prelude

import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Jelly.Data.Component (Component, el, text, textSig)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop (on)
import Jelly.Data.Signal (Atom, Signal, modifyAtom_, newStateEq)
import Jelly.Hooks.UseContext (useContext)
import Jelly.Mount (mount_)
import Web.DOM (Node)
import Web.HTML.Event.EventTypes (click)

type Context = Signal Int /\ Atom Int

mountWithContext :: Node -> Effect Unit
mountWithContext node = do
  countState <- newStateEq 0
  mount_ countState parentComponent node

parentComponent :: Component Context
parentComponent = hooks do
  _ /\ countAtom <- useContext

  pure do
    el "button" [ on click \_ -> modifyAtom_ countAtom (add 1) ] $ text "Increment"
    childComponent

childComponent :: Component Context
childComponent = hooks do
  countSig /\ _ <- useContext

  pure do
    textSig $ show <$> countSig
