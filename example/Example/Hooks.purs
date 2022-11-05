module Example.Hooks where

import Prelude

import Data.Tuple.Nested ((/\))
import Effect.Class.Console (log)
import Jelly.Component (class Component, text)
import Jelly.Element as JE
import Jelly.Prop (on)
import Signal (writeChannel)
import Signal.Hooks (newStateEq, useCleaner, useIf_)
import Web.HTML.Event.EventTypes (click)

hooksExample :: forall m. Component m => m Unit
hooksExample = do
  log "Mounted"

  useCleaner do
    log "Unmounted"

  text "This is Hooks"

hooksExampleWrapper :: forall m. Component m => m Unit
hooksExampleWrapper = do
  isMountedSig /\ isMountedChannel <- newStateEq true

  JE.button [ on click \_ -> writeChannel isMountedChannel true ] $ text "Mount"
  JE.button [ on click \_ -> writeChannel isMountedChannel false ] $ text "Unmount"
  useIf_ isMountedSig
    do JE.div' hooksExample
    do JE.div' $ text "Unmounted"
