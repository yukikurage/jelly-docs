module JellyDocs.Hooks.UseWindowHeight where

import Prelude

import Data.Tuple.Nested ((/\))
import Effect.Class (liftEffect)
import Jelly.Hooks (class MonadHooks, useEvent, useStateEq)
import Jelly.Signal (Signal, writeChannel)
import Web.Event.Event (EventType(..))
import Web.HTML (window)
import Web.HTML.Window (innerHeight, toEventTarget)

useWindowHeight :: forall m. MonadHooks m => m (Signal Int)
useWindowHeight = do
  w <- liftEffect $ window
  initH <- liftEffect $ innerHeight w
  hSig /\ hChn <- useStateEq initH

  useEvent (toEventTarget w) (EventType "resize") \_ -> do
    h <- liftEffect $ innerHeight w
    writeChannel hChn h

  pure hSig
