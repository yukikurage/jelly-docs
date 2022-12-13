module Example.Context where

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

mountWithContext :: Node -> Hooks Unit
mountWithContext node = do
  state <- useStateEq 0
  runCustomM (mount parentComponent node) state

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
