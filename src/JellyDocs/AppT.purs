module JellyDocs.AppT where

import Prelude

import Affjax (AffjaxDriver)
import Control.Monad.Reader (class MonadAsk, class MonadReader, ReaderT, ask, runReaderT)
import Data.Either (hush)
import Data.Maybe (fromMaybe)
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Jelly.Component (class Component)
import Jelly.Hydrate (HydrateM)
import Jelly.Render (RenderM)
import Jelly.Router (class Router, RouterT, hydrateRouter, renderRouter, routerLink, routerLink', useCurrentRoute, usePushRoute, useReplaceRoute)
import JellyDocs.Api.Doc (getDoc, getDocs, getSections)
import JellyDocs.Api.NotFound (getNotFoundMD)
import JellyDocs.Api.Top (getTopMD)
import JellyDocs.Capability.Api (class Api)
import JellyDocs.Capability.Nav (class Nav)
import JellyDocs.Data.Page (Page(..), pageToRoute, routeToPage)
import Signal.Hooks (class MonadHooks, Hooks)
import Web.DOM (Node)

newtype AppT :: forall k. (k -> Type) -> k -> Type
newtype AppT m a = AppT (ReaderT AffjaxDriver (RouterT m) a)

derive newtype instance Monad m => Functor (AppT m)
derive newtype instance Monad m => Apply (AppT m)
derive newtype instance Monad m => Applicative (AppT m)
derive newtype instance Monad m => Bind (AppT m)
derive newtype instance Monad m => Monad (AppT m)
derive newtype instance MonadEffect m => MonadEffect (AppT m)
derive newtype instance Component m => Component (AppT m)
derive newtype instance MonadHooks m => MonadHooks (AppT m)
derive newtype instance MonadEffect m => Router (AppT m)
derive newtype instance Monad m => MonadAsk AffjaxDriver (AppT m)
derive newtype instance Monad m => MonadReader AffjaxDriver (AppT m)

hydrateApp :: AppT HydrateM Unit -> AffjaxDriver -> Node -> Hooks Unit
hydrateApp (AppT m) = hydrateRouter <<< runReaderT m

renderApp :: AppT RenderM Unit -> AffjaxDriver -> String -> Effect String
renderApp (AppT m) = renderRouter <<< runReaderT m

instance MonadEffect m => Nav (AppT m) where
  usePushPage = usePushRoute <<< pageToRoute
  useReplacePage = useReplaceRoute <<< pageToRoute
  useCurrentPage = map (map (fromMaybe PageNotFound <<< hush <<< routeToPage)) useCurrentRoute
  pageLink = routerLink <<< pageToRoute
  pageLink' = routerLink' <<< pageToRoute

instance Monad m => Api (AppT m) where
  useDocsApi = getDocs <$> ask
  useDocApi = getDoc <$> ask
  useSectionsApi = getSections <$> ask
  useNotFoundApi = getNotFoundMD <$> ask
  useTopApi = getTopMD <$> ask
