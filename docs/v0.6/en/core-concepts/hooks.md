# Hooks

## `hooks` function

Hooks is a way to execute effects in a component's life cycle (on mount & unmount).

Using `useCleanup` function in `Hooks` Monad and converting it to `Component` by `hooks` function, you can attach effects to a component.

`hooks` has following type:

```purescript
hooks :: forall context. Hooks context (Component context) -> Component context
```

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

```
