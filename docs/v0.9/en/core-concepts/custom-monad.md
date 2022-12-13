# Custom Monad

In Jelly, you can introduce your own monads as Hooks. Of course, there are some restrictions.

## Derive MonadHooks class

As we have seen, Hooks are abstracted in the `MonadHooks` class.

```haskell
class MonadEffect m <= MonadHooks m where
  -- | Add a cleaner
  useCleaner :: Effect Unit -> m Unit
  -- | Unwrap a Signal
  useHooks :: forall a. Signal (m a) -> m (Signal a)
```

The `Hooks` monad is one of the monads that satisfies this, but newly defined monads can also be embedded in Jelly if they can implement it. In fact, `ReaderT r m` is `MonadHooks` if `m` is `MonadHooks`.

```haskell
instance MonadHooks m => MonadHooks (ReaderT r m) where
  useCleaner = lift <<< useCleaner
  useHooks sig = do
    r <- ask
    lift $ useHooks $ flip runReaderT r <$> sig
```

## Use custom Monad

For example, suppose you want to use a `MangeInt` typeclass that can read and change the state of an `Int` type anywhere.

```haskell
class Monad m <= MangeInt m where
  useCountSignal :: m (Signal Int)
  useCountChannel :: m (Channel Int)
```

With this monad, you could implement the following components.

```haskell
parentComponent :: forall m. MonadHooks m => MangeInt m => Component m
parentComponent = hooks do
  countChannel <- useCountChannel

  pure do
    JE.button [ on click \_ -> modifyChannel_ countChannel (add 1) ] $ text "Increment"
    childComponent

childComponent :: forall m. MonadHooks m => MangeInt m => Component m
childComponent = hooks do
  countSig <- useCountSignal

  pure do
    textSig $ show <$> countSig
```

Even though the Signal is not passed between components, the value of the Signal changed in parentComponent can be referenced by child components. You must create a monad that will make this possible. Here it is.

```haskell

newtype CustomM a = CustomM (ReaderT (Signal Int /\ Channel Int) Hooks a)

derive newtype instance Functor CustomM
derive newtype instance Apply CustomM
derive newtype instance Applicative CustomM
derive newtype instance Bind CustomM
derive newtype instance Monad CustomM
derive newtype instance MonadEffect CustomM
derive newtype instance MonadHooks CustomM
derive newtype instance MonadAsk (Signal Int /\ Channel Int) CustomM
derive newtype instance MonadRec CustomM
derive newtype instance MonadReader (Signal Int /\ Channel Int) CustomM

runCustomM :: forall a. CustomM a -> Signal Int /\ Channel Int -> Hooks a
runCustomM (CustomM m) = runReaderT m

instance MangeInt CustomM where
  useCountSignal = asks fst
  useCountChannel = asks snd
```

Use ReaderT to have `Signal Int` and `Channel Int` globally.

In the main function, create the state and then use the `runCustomM` function to run the application.

```haskell
main :: Effect Unit
main = launchAff_ do
  mb <- awaitBody
  runHooks_ do
    state <- useStateEq 0
    runCustomM (traverse_ (mount parentComponent) mb) state
```

The overall program is as follows.

##### 🚩 Example

<pre class="preview">context</pre>

```haskell
import Prelude

import Control.Monad.Reader (class MonadAsk, class MonadReader, ReaderT, asks, runReaderT)
import Control.Monad.Rec.Class (class MonadRec)
import Data.Foldable (traverse_)
import Data.Tuple (fst, snd)
import Data.Tuple.Nested (type (/\))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (class MonadEffect)
import Jelly.Aff (awaitBody)
import Jelly.Component (Component, hooks, text, textSig)
import Jelly.Element as JE
import Jelly.Hooks (class MonadHooks, Hooks, runHooks_, useStateEq)
import Jelly.Hydrate (mount)
import Jelly.Prop (on)
import Jelly.Signal (Channel, Signal, modifyChannel_)
import Web.DOM (Node)
import Web.HTML.Event.EventTypes (click)

main :: Effect Unit
main = launchAff_ do
  mb <- awaitBody
  runHooks_ do
    state <- useStateEq 0
    runCustomM (traverse_ (mount parentComponent) mb) state

newtype CustomM a = CustomM (ReaderT (Signal Int /\ Channel Int) Hooks a)

derive newtype instance Functor CustomM
derive newtype instance Apply CustomM
derive newtype instance Applicative CustomM
derive newtype instance Bind CustomM
derive newtype instance Monad CustomM
derive newtype instance MonadEffect CustomM
derive newtype instance MonadHooks CustomM
derive newtype instance MonadAsk (Signal Int /\ Channel Int) CustomM
derive newtype instance MonadRec CustomM
derive newtype instance MonadReader (Signal Int /\ Channel Int) CustomM

runCustomM :: forall a. CustomM a -> Signal Int /\ Channel Int -> Hooks a
runCustomM (CustomM m) = runReaderT m

class Monad m <= MangeInt m where
  useCountSignal :: m (Signal Int)
  useCountChannel :: m (Channel Int)

instance MangeInt CustomM where
  useCountSignal = asks fst
  useCountChannel = asks snd

parentComponent :: forall m. MonadHooks m => MangeInt m => Component m
parentComponent = hooks do
  countChannel <- useCountChannel

  pure do
    JE.button [ on click \_ -> modifyChannel_ countChannel (add 1) ] $ text "Increment"
    childComponent

childComponent :: forall m. MonadHooks m => MangeInt m => Component m
childComponent = hooks do
  countSig <- useCountSignal

  pure do
    textSig $ show <$> countSig
```
