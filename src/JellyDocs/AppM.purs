module JellyDocs.AppM where

import Prelude

import Affjax (AffjaxDriver)
import Control.Monad.Reader (class MonadAsk, class MonadReader, ReaderT, ask, runReaderT)
import Control.Monad.Rec.Class (class MonadRec)
import Data.Either (hush)
import Data.Maybe (fromMaybe)
import Data.Tuple (Tuple)
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Jelly.Hooks (class MonadHooks, Hooks, runHooks)
import Jelly.Router (class Router, RouterT, routerLink, routerLink', runMockRouterT, runRouterT, useCurrentRoute, usePushRoute, useReplaceRoute)
import JellyDocs.Api.Doc (getDoc, getDocs, getSections)
import JellyDocs.Api.NotFound (getNotFoundMD)
import JellyDocs.Api.Top (getTopMD)
import JellyDocs.Capability.Api (class Api)
import JellyDocs.Capability.Nav (class Nav)
import JellyDocs.Data.Page (Page(..), pageToRoute, routeToPage)

newtype AppM a = AppM (ReaderT AffjaxDriver (RouterT Hooks) a)

derive newtype instance Functor AppM
derive newtype instance Apply AppM
derive newtype instance Applicative AppM
derive newtype instance Bind AppM
derive newtype instance Monad AppM
derive newtype instance MonadEffect AppM
derive newtype instance MonadHooks AppM
derive newtype instance Router AppM
derive newtype instance MonadAsk AffjaxDriver AppM
derive newtype instance MonadReader AffjaxDriver AppM
derive newtype instance MonadRec AppM

runAppMWeb :: forall m a. MonadEffect m => AppM a -> AffjaxDriver -> m (Tuple a (Effect Unit))
runAppMWeb (AppM m) driver = runHooks $ runRouterT $ runReaderT m driver

runAppMNode :: forall m a. MonadEffect m => AppM a -> AffjaxDriver -> Page -> m (Tuple a (Effect Unit))
runAppMNode (AppM m) driver page = runHooks $ runMockRouterT (runReaderT m driver) (pageToRoute page)

instance Nav AppM where
  usePushPage = usePushRoute <<< pageToRoute
  useReplacePage = useReplaceRoute <<< pageToRoute
  useCurrentPage = map (map (fromMaybe PageNotFound <<< hush <<< routeToPage)) useCurrentRoute
  pageLink = routerLink <<< pageToRoute
  pageLink' = routerLink' <<< pageToRoute

instance Api AppM where
  useDocsApi = getDocs <$> ask
  useDocApi = getDoc <$> ask
  useSectionsApi = getSections <$> ask
  useNotFoundApi = getNotFoundMD <$> ask
  useTopApi = getTopMD <$> ask
