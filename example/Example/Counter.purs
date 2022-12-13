module Example.Counter where

import Prelude

import Data.Tuple.Nested ((/\))
import Effect.Class.Console (log)
import Jelly.Component (Component, hooks, text, textSig)
import Jelly.Element as JE
import Jelly.Hooks (class MonadHooks, useCleaner, useHooks_)
import Jelly.Prop (on)
import Jelly.Signal (modifyChannel_, newState)
import Web.HTML.Event.EventTypes (click)

counter :: forall m. MonadHooks m => Component m
counter = hooks do
  countSig /\ countChannel <- newState 0

  pure do
    JE.button [ on click \_ -> modifyChannel_ countChannel (_ + 1) ] $ text "Increment"
    JE.button [ on click \_ -> modifyChannel_ countChannel (_ - 1) ] $ text "Decrement"
    JE.div' do
      text "Count: "
      textSig $ show <$> countSig

counter2 :: forall m. MonadHooks m => Component m
counter2 = hooks do
  countSig /\ countChannel <- newState 0

  useHooks_ $ countSig <#> \count -> do
    log $ "Count is now " <> show count
    useCleaner $ log $ "Count is no longer " <> show count

  pure do
    JE.button [ on click \_ -> modifyChannel_ countChannel (_ + 1) ] $ text "Increment"
    JE.button [ on click \_ -> modifyChannel_ countChannel (_ - 1) ] $ text "Decrement"
    JE.div' do
      text "Count: "
      textSig $ show <$> countSig
