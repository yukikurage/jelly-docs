# Stateful Component

## Signal and Channel

`Signal` is a type to represent a value that changes over time.

And if `Signal` is the output, then `Channel` represents the input.
You can manipulate values with the `writeChannel` and `modifyChannel` functions.

`Signal` and `Channel` can be created using `newState` function.

You can display `Signal String` by `textSig` function.

### Example

Let's make a simple counter.

```preview
counter
```

```purescript
module Example.Counter where

import Prelude

import Data.Tuple.Nested ((/\))
import Jelly.Component (class Component, text, textSig)
import Jelly.Element as JE
import Jelly.Prop (on)
import Jelly.Signal (modifyChannel, newState)
import Web.HTML.Event.EventTypes (click)

counterExample :: forall m. Component m => m Unit
counterExample = do
  countSig /\ countChannel <- newState 0

  JE.button [ on click \_ -> modifyChannel countChannel (_ + 1) ] $ text "Increment"
  JE.button [ on click \_ -> modifyChannel countChannel (_ - 1) ] $ text "Decrement"
  JE.div' do
    text "Count: "
    textSig $ show <$> countSig

```
