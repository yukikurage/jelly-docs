module Example.SignalEq where

import Prelude

import Data.Tuple.Nested ((/\))
import Jelly.Data.Component (Component, el, el', text, textSig)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop (on)
import Jelly.Data.Signal (patch_, send, signal, signalEq)
import Jelly.Hooks.UseSignal (useSignal)
import Web.HTML.Event.EventTypes (click)

signalEqExample :: forall context. Component context
signalEqExample = hooks do
  signalWithoutEq /\ atomWithoutEq <- signal true
  signalWithEq /\ atomWithEq <- signalEq true

  updateCountWithoutEqSig /\ updateCountWithoutEqAtom <- signalEq 0
  updateCountWithEqSig /\ updateCountWithEqAtom <- signalEq 0

  useSignal do
    _ <- signalWithoutEq
    pure do
      patch_ updateCountWithoutEqAtom $ add 1
      mempty

  useSignal do
    _ <- signalWithEq
    pure do
      patch_ updateCountWithEqAtom $ add 1
      mempty

  pure do
    el "button" [ on click \_ -> send atomWithoutEq true *> send atomWithEq true ] $ text "True"
    el "button" [ on click \_ -> send atomWithoutEq false *> send atomWithEq false ] $ text "False"
    el' "div" do
      text "Update count without Eq: "
      textSig $ show <$> updateCountWithoutEqSig
    el' "div" do
      text "Update count with Eq: "
      textSig $ show <$> updateCountWithEqSig
