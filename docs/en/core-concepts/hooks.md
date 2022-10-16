# Hooks

Hooks is a way to execute effects in a component's life cycle (on mount & unmount).

Using `useUnmountEffect` function in `Hooks` Monad and converting it to `Component` by `hooks` function, you can attach effects to a component.

`hooks` has following type:

```purescript
hooks :: forall context. Hooks context (Component context) -> Component context
```

## Example

Open devtools and see the console.

```purescript
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
```

```preview
hooks
```
