module Example.Hooks where

import Prelude

import Data.Tuple.Nested ((/\))
import Effect.Class.Console (log)
import Jelly.Data.Component (Component, el, el', ifC, text)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop (on)
import Jelly.Data.Signal (newStateEq, writeAtom)
import Jelly.Hooks.UseCleanup (useCleanup)
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
    el "button" [ on click \_ -> writeAtom isMountedAtom true ] $ text "Mount"
    el "button" [ on click \_ -> writeAtom isMountedAtom false ] $ text "Unmount"
    ifC isMountedSig
      do el' "div" hooksExample
      do el' "div" $ text "Unmounted"
