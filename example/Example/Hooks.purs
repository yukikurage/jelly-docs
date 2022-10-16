module Example.Hooks where

import Prelude

import Data.Tuple.Nested ((/\))
import Effect.Class.Console (log)
import Jelly.Data.Component (Component, el, el', text, whenC)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop (on)
import Jelly.Data.Signal (send, signalEq)
import Jelly.Hooks.UseUnmountEffect (useUnmountEffect)
import Web.HTML.Event.EventTypes (click)

hooksExample :: forall context. Component context
hooksExample = hooks do
  log "Mounted"

  useUnmountEffect do
    log "Unmounted"

  pure do
    text "This is Hooks"

hooksExampleWrapper :: forall context. Component context
hooksExampleWrapper = hooks do
  isMountedSig /\ isMountedAtom <- signalEq true

  pure do
    el "button" [ on click \_ -> send isMountedAtom true ] $ text "Mount"
    el "button" [ on click \_ -> send isMountedAtom false ] $ text "Unmount"
    whenC isMountedSig $ el' "div" hooksExample
