# Component switching

## `useHooks_` function

Component can be swapped with another component by using `useHooks_` function. The type of `useHooks_` is below:

```purescript
useHooks_ :: forall a. MonadHooks m. Signal (m a) -> m Unit
```

### Example

```preview
switching
```

```purescript
module Example.Switching where

import Prelude

import Data.Tuple.Nested ((/\))
import Jelly.Component (class Component, text, textSig)
import Jelly.Element as JE
import Jelly.Prop (on)
import Jelly.Signal (modifyChannel)
import Jelly.Hooks (newStateEq, useHooks_)
import Web.HTML.Event.EventTypes (click)

switchingExample :: forall m. Component m => m Unit
switchingExample = do
  componentNumSig /\ componentNumChannel <- newStateEq 1

  JE.button [ on click \_ -> modifyChannel componentNumChannel (_ + 1) ] $ text "Increment"
  JE.button [ on click \_ -> modifyChannel componentNumChannel (_ - 1) ] $ text "Decrement"
  JE.div' do
    textSig $ pure "Component number: " <> show <$> componentNumSig
  JE.div' do
    useHooks_ do
      componentNum <- componentNumSig
      pure case componentNum of
        1 -> component1
        2 -> component2
        3 -> component3
        _ -> text "No such component"

component1 :: forall m. Component m => m Unit
component1 = text "This is component 1"

component2 :: forall m. Component m => m Unit
component2 = text "This is component 2"

component3 :: forall m. Component m => m Unit
component3 = text "This is component 3"

```

## Other predefined functions for lifecycle

Jelly provides some other predefined functions for lifecycle below, which are defined by using `useHooks_` function internally.

```purescript
useIf_ :: forall m. MonadHooks m => Signal Boolean -> m a -> m a -> m Unit
useWhen_ :: forall m. MonadHooks m => Signal Boolean -> m a -> m Unit
```

The `useIf_ ` function is particularly useful when used with `do` notation, since it eliminates the need for parentheses.

```purescript
useIf_  conditionSig
  do
    component1
  do
    component2
```
