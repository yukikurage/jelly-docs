module Example.SignalEq where

import Prelude

import Data.Tuple.Nested ((/\))
import Jelly (Component, hooks, on, text, textSig)
import Jelly.Data.Signal (modifyAtom_, newState, newStateEq, writeAtom)
import Jelly.Element as JE
import Jelly.Hooks (useEffect_)
import Web.HTML.Event.EventTypes (click)

signalEqExample :: forall context. Component context
signalEqExample = hooks do
  signalWithoutEq /\ atomWithoutEq <- newState true
  signalWithEq /\ atomWithEq <- newStateEq true

  updateCountWithoutEqSig /\ updateCountWithoutEqAtom <- newStateEq 0
  updateCountWithEqSig /\ updateCountWithEqAtom <- newStateEq 0

  useEffect_ do
    _ <- signalWithoutEq
    pure do
      modifyAtom_ updateCountWithoutEqAtom $ add 1

  useEffect_ do
    _ <- signalWithEq
    pure do
      modifyAtom_ updateCountWithEqAtom $ add 1

  pure do
    JE.button [ on click \_ -> writeAtom atomWithoutEq true *> writeAtom atomWithEq true ] $ text "True"
    JE.button [ on click \_ -> writeAtom atomWithoutEq false *> writeAtom atomWithEq false ] $ text "False"
    JE.div' do
      text "Update count without Eq: "
      textSig $ show <$> updateCountWithoutEqSig
    JE.div' do
      text "Update count with Eq: "
      textSig $ show <$> updateCountWithEqSig
