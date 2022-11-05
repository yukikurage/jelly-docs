# Hooks

## `hooks` function

Hooks is a way to execute effects in a component's life cycle (on mount & unmount).

Using `useCleaner` function, you can register a function to be executed when the component is unmounted.

### Example

Open devtools and see the console.

```preview
hooks
```

```purescript
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
```
