# Stateful Component

`Signal` is a reactive value that represents a state. Combined with `Hooks` and `Components`, Stateful components can be created.

## Signal and Channel

To create a `Signal`, use the `newState` function.

```haskell
newState :: forall m a. MonadEffect m => a -> m (Tuple (Signal a) (Channel a))
```

This function takes an initial value and returns a tuple of `Signal` and `Channel`. `Signal`, as mentioned earlier, represents a state, while `Channel`, conversely, represents an input. You can change the value of `Signal` through `writeChannel` or `modifyChannel`.

```haskell
writeChannel :: forall m a. MonadEffect m => Channel a -> a -> m Unit
modifyChannel :: forall m a. MonadEffect m => Channel a -> (a -> a) -> m a
modifyChannel_ :: forall m a. MonadEffect m => Channel a -> (a -> a) -> m Unit
```

The value of `Signal` can always be retrieved by `readSignal`.

```haskell
readSignal :: forall m a. MonadEffect m => Signal a -> m a
```

And since `Signal` is a monad, it can be composed by the do syntax.

```haskell
signal1 /\ channel1 <- newState 0
signal2 /\ channel2 <- newState 0

-- Compose signals
newSignal = do
  x1 <- signal1
  x2 <- signal2
  pure $ x1 + x2

log =<< readSignal newSignal -- 0 (0 + 0)

writeChannel channel1 1
log =<< readSignal newSignal -- 1 (1 + 0)

writeChannel channel2 2
log =<< readSignal newSignal -- 3 (1 + 2)
```

## Signal and Text

The value of `Signal` can be converted to a Text Component by `textSig`.

```haskell
textSig :: forall m. Component m => Signal String -> m Unit
```

The component created by this function is updated each time the value of Signal is changed.

## Stateful Component

Let's create a counter using `Signal`. This can be done using only the functions described so far.

##### 🚩 Example

<pre class="preview">counter</pre>

```purescript
import Prelude

import Data.Tuple.Nested ((/\))
import Jelly.Component (Component, hooks, text, textSig)
import Jelly.Element as JE
import Jelly.Hooks (class MonadHooks)
import Jelly.Prop (on)
import Jelly.Signal (modifyChannel_, newState)
import Web.HTML.Event.EventTypes (click)

counter :: forall m. MonadHooks m => Component m
counter = hooks do
  countSig /\ countChannel <- newState 0

  pure do
    JE.button [ on click \_ -> modifyChannel_ countChannel (_ + 1) ] $ text "Increment"
    JE.button [ on click \_ -> modifyChannel_ countChannel (_ - 1) ] $ text "Decrement"
    JE.div' do
      text "Count: "
      textSig $ show <$> countSig
```

## Reactively perform hooks

Let's take a look at the `useHooks` function. This is equivalent to React's useEffect.

```haskell
useHooks :: forall m a. MonadHooks m => Signal (m a) -> m (Signal a)
useHooks_ :: forall m a. MonadHooks m => Signal (m a) -> m Unit
```

The `useHooks` function executes Hooks each time it is updated. The Cleanup Effect added by useCleaner is executed immediately before the next execution. An example will be easier to understand.

##### 🚩 Example

In addition to the counter created above, add the ability to log each time the count is updated. Open the console and check the log.

<pre class="preview">counter2</pre>

```haskell
counter2 :: forall m. MonadHooks m => Component m
counter2 = hooks do
  countSig /\ countChannel <- newState 0

  useHooks_ $ countSig <#> \count -> do
    log $ "Count is now " <> show count
    useCleaner $ log $ "Count is no longer " <> show count

  pure do
    JE.button [ on click \_ -> modifyChannel_ countChannel (_ + 1) ] $ text "Increment"
    JE.button [ on click \_ -> modifyChannel_ countChannel (_ - 1) ] $ text "Decrement"
    JE.div' do
      text "Count: "
      textSig $ show <$> countSig
```

## Signal as props

When separating Component, you may want to take arguments. What follows are mostly **bad** examples.

```haskell
component :: forall m. MonadHooks m => String -> Component m
component str = do
  text str
```

As it is, the value of `str` cannot be manipulated from the parent component. It should take a `Signal String` to allow the value to be changed from the parent component.

```haskell
component :: forall m. MonadHooks m => Signal String -> Component m
component strSig = do
  textSig strSig
```

## Component Switching

Sometimes you may want to switch components depending on the value of Signal, in which case you can use the `switch` function.

```haskell
switch :: forall m. Signal (Component m) → Component m
```

`switch` can embed a Component that varies with Signal into a Component.

##### 🚩 Example

<pre class="preview">switching</pre>

```haskell
import Prelude

import Data.Tuple.Nested ((/\))
import Jelly.Component (Component, hooks, switch, text, textSig)
import Jelly.Element as JE
import Jelly.Hooks (class MonadHooks, useStateEq)
import Jelly.Prop (on)
import Jelly.Signal (modifyChannel_)
import Web.HTML.Event.EventTypes (click)

switchingExample :: forall m. MonadHooks m => Component m
switchingExample = hooks do
  componentNumSig /\ componentNumChannel <- useStateEq 1

  pure do
    JE.button [ on click \_ -> modifyChannel_ componentNumChannel (_ + 1) ] $ text "Increment"
    JE.button [ on click \_ -> modifyChannel_ componentNumChannel (_ - 1) ] $ text "Decrement"
    JE.div' do
      textSig $ pure "Component number: " <> show <$> componentNumSig
    JE.div' do
      switch $ componentNumSig <#> case _ of
        1 -> component1
        2 -> component2
        3 -> component3
        _ -> text "No such component"

component1 :: forall m. Component m
component1 = text "This is the first component"

component2 :: forall m. Component m
component2 = text "This is the second component"

component3 :: forall m. Component m
component3 = text "This is the third component"
```
