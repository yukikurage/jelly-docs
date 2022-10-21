module Example.Context where

import Prelude

import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Jelly (Component, hooks, mount_, on, text, textSig)
import Jelly.Data.Signal (Atom, Signal, modifyAtom_, newStateEq)
import Jelly.Element as JE
import Jelly.Hooks (useContext)
import Web.DOM (Node)
import Web.HTML.Event.EventTypes (click)

type Context = (countSig :: Signal Int, countAtom :: Atom Int)

mountWithContext :: Node -> Effect Unit
mountWithContext node = do
  countSig /\ countAtom <- newStateEq 0
  mount_ { countSig, countAtom } parentComponent node

parentComponent :: Component Context
parentComponent = hooks do
  { countAtom } <- useContext

  pure do
    JE.button [ on click \_ -> modifyAtom_ countAtom (add 1) ] $ text "Increment"
    childComponent

childComponent :: Component Context
childComponent = hooks do
  { countSig } <- useContext

  pure do
    textSig $ show <$> countSig
