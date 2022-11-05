# Custom Monad

Jelly can wrap the entire app in the ReaderT monad.

## Providing Context

By managing Signal in ReaderT, status can be shared throughout the app.

### Example

Create a `ContextT` monad to share the Int type state.

```preview
context
```

```purescript
module Example.Context where

import Prelude

import Control.Monad.Reader (class MonadAsk, class MonadReader, ReaderT, asks, runReaderT)
import Data.Tuple (fst, snd)
import Data.Tuple.Nested (type (/\))
import Effect.Class (class MonadEffect)
import Jelly.Component (class Component, text, textSig)
import Jelly.Element as JE
import Jelly.Hydrate (HydrateM, mount)
import Jelly.Prop (on)
import Signal (Channel, Signal, modifyChannel)
import Signal.Hooks (class MonadHooks, Hooks, newStateEq)
import Web.DOM (Node)
import Web.HTML.Event.EventTypes (click)

newtype ContextT :: forall k. (k -> Type) -> k -> Type
newtype ContextT m a = ContextT (ReaderT (Signal Int /\ Channel Int) m a)

derive newtype instance Monad m => Functor (ContextT m)
derive newtype instance Monad m => Apply (ContextT m)
derive newtype instance Monad m => Applicative (ContextT m)
derive newtype instance Monad m => Bind (ContextT m)
derive newtype instance Monad m => Monad (ContextT m)
derive newtype instance MonadEffect m => MonadEffect (ContextT m)
derive newtype instance Component m => Component (ContextT m)
derive newtype instance MonadHooks m => MonadHooks (ContextT m)
derive newtype instance Monad m => MonadAsk (Signal Int /\ Channel Int) (ContextT m)
derive newtype instance Monad m => MonadReader (Signal Int /\ Channel Int) (ContextT m)

class Monad m <= Context m where
  useCountSignal :: m (Signal Int)
  useCountChannel :: m (Channel Int)

instance Monad m => Context (ContextT m) where
  useCountSignal = ContextT $ asks fst
  useCountChannel = ContextT $ asks snd

mountContext :: ContextT HydrateM Unit -> Node -> Hooks Unit
mountContext (ContextT cmp) node = do
  state <- newStateEq 0
  mount (runReaderT cmp state) node

mountWithContext :: Node -> Hooks Unit
mountWithContext node = do
  mountContext parentComponent node

parentComponent :: forall m. Component m => Context m => m Unit
parentComponent = do
  countChannel <- useCountChannel

  JE.button [ on click \_ -> modifyChannel countChannel (add 1) ] $ text "Increment"
  childComponent

childComponent :: forall m. Component m => Context m => m Unit
childComponent = do
  countSig <- useCountSignal

  textSig $ show <$> countSig

```
