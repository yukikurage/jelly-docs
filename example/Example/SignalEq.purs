module Example.SignalEq where

import Prelude

import Data.Tuple.Nested ((/\))
import Jelly.Data.Component (Component, el, el', text, textSig)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop (on)
import Jelly.Data.Signal (modifyAtom_, newState, newStateEq, writeAtom)
import Jelly.Hooks.UseEffect (useEffect)
import Web.HTML.Event.EventTypes (click)

signalEqExample :: forall context. Component context
signalEqExample = hooks do
  signalWithoutEq /\ atomWithoutEq <- newState true
  signalWithEq /\ atomWithEq <- newStateEq true

  updateCountWithoutEqSig /\ updateCountWithoutEqAtom <- newStateEq 0
  updateCountWithEqSig /\ updateCountWithEqAtom <- newStateEq 0

  useEffect do
    _ <- signalWithoutEq
    pure do
      modifyAtom_ updateCountWithoutEqAtom $ add 1
      mempty

  useEffect do
    _ <- signalWithEq
    pure do
      modifyAtom_ updateCountWithEqAtom $ add 1
      mempty

  pure do
    el "button" [ on click \_ -> writeAtom atomWithoutEq true *> writeAtom atomWithEq true ] $ text "True"
    el "button" [ on click \_ -> writeAtom atomWithoutEq false *> writeAtom atomWithEq false ] $ text "False"
    el' "div" do
      text "Update count without Eq: "
      textSig $ show <$> updateCountWithoutEqSig
    el' "div" do
      text "Update count with Eq: "
      textSig $ show <$> updateCountWithEqSig
