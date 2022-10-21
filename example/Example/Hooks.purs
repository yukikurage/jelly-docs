module Example.Hooks where

import Prelude

import Data.Tuple.Nested ((/\))
import Effect.Class.Console (log)
import Jelly (Component, hooks, ifC, on, text)
import Jelly.Data.Signal (newStateEq, writeAtom)
import Jelly.Element as JE
import Jelly.Hooks (useCleanup)
import Web.HTML.Event.EventTypes (click)

hooksExample :: forall context. Component context
hooksExample = hooks do
  log "Mounted"

  useCleanup do
    log "Unmounted"

  pure do
    text "This is Hooks"

hooksExampleWrapper :: forall context. Component context
hooksExampleWrapper = hooks do
  isMountedSig /\ isMountedAtom <- newStateEq true

  pure do
    JE.button [ on click \_ -> writeAtom isMountedAtom true ] $ text "Mount"
    JE.button [ on click \_ -> writeAtom isMountedAtom false ] $ text "Unmount"
    ifC isMountedSig
      do JE.div' hooksExample
      do JE.div' $ text "Unmounted"
