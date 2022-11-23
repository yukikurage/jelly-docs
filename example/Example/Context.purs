module Example.Context where

import Prelude

import Control.Monad.Reader (class MonadAsk, class MonadReader, ReaderT, asks, runReaderT)
import Control.Monad.Rec.Class (class MonadRec)
import Data.Tuple (fst, snd)
import Data.Tuple.Nested (type (/\))
import Effect.Class (class MonadEffect)
import Jelly.Component (Component, hooks, text, textSig)
import Jelly.Element as JE
import Jelly.Hooks (class MonadHooks, Hooks, useStateEq)
import Jelly.Hydrate (mount)
import Jelly.Prop (on)
import Jelly.Signal (Channel, Signal, modifyChannel_)
import Web.DOM (Node)
import Web.HTML.Event.EventTypes (click)

newtype ContextM a = ContextM (ReaderT (Signal Int /\ Channel Int) Hooks a)

derive newtype instance Functor ContextM
derive newtype instance Apply ContextM
derive newtype instance Applicative ContextM
derive newtype instance Bind ContextM
derive newtype instance Monad ContextM
derive newtype instance MonadEffect ContextM
derive newtype instance MonadHooks ContextM
derive newtype instance MonadAsk (Signal Int /\ Channel Int) ContextM
derive newtype instance MonadRec ContextM
derive newtype instance MonadReader (Signal Int /\ Channel Int) ContextM

runContextM :: forall a. ContextM a -> Signal Int /\ Channel Int -> Hooks a
runContextM (ContextM m) = runReaderT m

class Monad m <= Context m where
  useCountSignal :: m (Signal Int)
  useCountChannel :: m (Channel Int)

instance Context ContextM where
  useCountSignal = ContextM $ asks fst
  useCountChannel = ContextM $ asks snd

mountWithContext :: Node -> Hooks Unit
mountWithContext node = do
  state <- useStateEq 0
  runContextM (mount parentComponent node) state

parentComponent :: forall m. MonadHooks m => Context m => Component m
parentComponent = hooks do
  countChannel <- useCountChannel

  pure do
    JE.button [ on click \_ -> modifyChannel_ countChannel (add 1) ] $ text "Increment"
    childComponent

childComponent :: forall m. MonadHooks m => Context m => Component m
childComponent = hooks do
  countSig <- useCountSignal

  pure do
    textSig $ show <$> countSig
