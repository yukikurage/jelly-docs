module JellyDocs.Hooks.UseWindowHeight where

import Prelude

import Data.Tuple.Nested ((/\))
import Effect.Class (liftEffect)
import Signal (Signal, writeChannel)
import Signal.Hooks (class MonadHooks, newStateEq, useEvent)
import Web.Event.Event (EventType(..))
import Web.HTML (window)
import Web.HTML.Window (innerHeight, toEventTarget)

useWindowHeight :: forall m. MonadHooks m => m (Signal Int)
useWindowHeight = do
  w <- liftEffect $ window
  initH <- liftEffect $ innerHeight w
  hSig /\ hChn <- newStateEq initH

  useEvent (toEventTarget w) (EventType "resize") \_ -> do
    h <- liftEffect $ innerHeight w
    writeChannel hChn h

  pure hSig
