# Hooks

## `hooks` function

Hooks is a way to execute effects in a component's life cycle (on mount & unmount).

Using `useCleaner` function, you can register a function to be executed when the component is unmounted.

Then, you can convert `m (Component m)` to `Component m` with the `hooks` function.

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
import Jelly.Component (Component, hooks, text)
import Jelly.Hooks (class MonadHooks, useCleaner)

hooksExample :: forall m. MonadHooks m => Component m
hooksExample = hooks do
  log "Mounted"

  useCleaner do
    log "Unmounted"

  pure $ text "This is Hooks"

```
