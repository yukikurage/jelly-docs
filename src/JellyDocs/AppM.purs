module JellyDocs.AppM where

import Prelude

import Affjax (AffjaxDriver, Error)
import Control.Monad.Reader (class MonadAsk, class MonadReader, ReaderT, ask, runReaderT)
import Control.Monad.Rec.Class (class MonadRec)
import Data.Either (Either, hush)
import Data.Map (Map, empty, insert, lookup)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple (Tuple)
import Effect (Effect)
import Effect.Aff (Fiber, joinFiber, launchAff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Ref (Ref, new, read, write)
import Jelly.Hooks (class MonadHooks, Hooks, runHooks)
import Jelly.Router (class Router, RouterT, routerLink, routerLink', runMockRouterT, runRouterT, useCurrentRoute, usePushRoute, useReplaceRoute)
import JellyDocs.Api.Doc (getDoc, getDocs, getSections)
import JellyDocs.Api.NotFound (getNotFoundMD)
import JellyDocs.Api.Top (getTopMD)
import JellyDocs.Capability.Api (class Api)
import JellyDocs.Capability.Nav (class Nav)
import JellyDocs.Data.Doc (Doc, DocListItem)
import JellyDocs.Data.Page (Page(..), pageToRoute, routeToPage)
import JellyDocs.Data.Section (Section)

type ApiFibers =
  { docsFibMaybeRef :: Ref (Maybe (Fiber (Either Error (Array DocListItem))))
  , docFibMapRef :: Ref (Map String (Fiber (Either Error Doc)))
  , sectionsFibMaybeRef :: Ref (Maybe (Fiber (Either Error (Array Section))))
  , notFoundFibMaybeRef :: Ref (Maybe (Fiber (Either Error String)))
  , topFibMaybeRef :: Ref (Maybe (Fiber (Either Error String)))
  }

type Global = { apiFibers :: ApiFibers, affjaxDriver :: AffjaxDriver }

newtype AppM a = AppM (ReaderT Global (RouterT Hooks) a)

derive newtype instance Functor AppM
derive newtype instance Apply AppM
derive newtype instance Applicative AppM
derive newtype instance Bind AppM
derive newtype instance Monad AppM
derive newtype instance MonadEffect AppM
derive newtype instance MonadHooks AppM
derive newtype instance Router AppM
derive newtype instance MonadAsk Global AppM
derive newtype instance MonadReader Global AppM
derive newtype instance MonadRec AppM

runAppMWeb :: forall m a. MonadEffect m => AppM a -> AffjaxDriver -> m (Tuple a (Effect Unit))
runAppMWeb (AppM m) affjaxDriver = runHooks do
  docsFibMaybeRef <- liftEffect $ new Nothing
  docFibMapRef <- liftEffect $ new empty
  sectionsFibMaybeRef <- liftEffect $ new Nothing
  notFoundFibMaybeRef <- liftEffect $ new Nothing
  topFibMaybeRef <- liftEffect $ new Nothing

  let
    apiFibers =
      { docsFibMaybeRef
      , docFibMapRef
      , sectionsFibMaybeRef
      , notFoundFibMaybeRef
      , topFibMaybeRef
      }
    global = { apiFibers, affjaxDriver }

  runRouterT $ runReaderT m global

runAppMNode :: forall m a. MonadAff m => AppM a -> AffjaxDriver -> Page -> m (Tuple a (Effect Unit))
runAppMNode (AppM m) affjaxDriver page = do
  docsFibMaybeRef <- liftEffect $ new Nothing
  docFibMapRef <- liftEffect $ new empty
  sectionsFibMaybeRef <- liftEffect $ new Nothing
  notFoundFibMaybeRef <- liftEffect $ new Nothing
  topFibMaybeRef <- liftEffect $ new Nothing

  case page of
    PageDoc id -> do
      docFib <- liftEffect $ launchAff $ getDoc affjaxDriver id
      liftEffect $ write (insert id docFib empty) docFibMapRef
      void $ liftAff $ joinFiber docFib
    _ -> pure unit

  let
    apiFibers =
      { docsFibMaybeRef
      , docFibMapRef
      , sectionsFibMaybeRef
      , notFoundFibMaybeRef
      , topFibMaybeRef
      }
    global = { apiFibers, affjaxDriver }

  runHooks $ runMockRouterT (runReaderT m global) (pageToRoute page)

instance Nav AppM where
  usePushPage = usePushRoute <<< pageToRoute
  useReplacePage = useReplaceRoute <<< pageToRoute
  useCurrentPage = map (map (fromMaybe PageNotFound <<< hush <<< routeToPage)) useCurrentRoute
  pageLink = routerLink <<< pageToRoute
  pageLink' = routerLink' <<< pageToRoute

instance Api AppM where
  useDocsApi = do
    { apiFibers: { docsFibMaybeRef }, affjaxDriver } <- ask
    docsFibMaybe <- liftEffect $ read docsFibMaybeRef
    pure case docsFibMaybe of
      Nothing -> do
        docsFib <- liftEffect $ launchAff $ getDocs affjaxDriver
        liftEffect $ write (Just docsFib) docsFibMaybeRef
        joinFiber docsFib
      Just docsFib -> joinFiber docsFib
  useDocApi = do
    { apiFibers: { docFibMapRef }, affjaxDriver } <- ask
    docFibMap <- liftEffect $ read docFibMapRef
    pure \id -> case lookup id docFibMap of
      Nothing -> do
        docFib <- liftEffect $ launchAff $ getDoc affjaxDriver id
        liftEffect $ write (insert id docFib docFibMap) docFibMapRef
        joinFiber docFib
      Just docFib -> joinFiber docFib
  useSectionsApi = do
    { apiFibers: { sectionsFibMaybeRef }, affjaxDriver } <- ask
    sectionsFibMaybe <- liftEffect $ read sectionsFibMaybeRef
    pure case sectionsFibMaybe of
      Nothing -> do
        sectionsFib <- liftEffect $ launchAff $ getSections affjaxDriver
        liftEffect $ write (Just sectionsFib) sectionsFibMaybeRef
        joinFiber sectionsFib
      Just sectionsFib -> joinFiber sectionsFib
  useNotFoundApi = do
    { apiFibers: { notFoundFibMaybeRef }, affjaxDriver } <- ask
    notFoundFibMaybe <- liftEffect $ read notFoundFibMaybeRef
    pure case notFoundFibMaybe of
      Nothing -> do
        notFoundFib <- liftEffect $ launchAff $ getNotFoundMD affjaxDriver
        liftEffect $ write (Just notFoundFib) notFoundFibMaybeRef
        joinFiber notFoundFib
      Just notFoundFib -> joinFiber notFoundFib
  useTopApi = do
    { apiFibers: { topFibMaybeRef }, affjaxDriver } <- ask
    topFibMaybe <- liftEffect $ read topFibMaybeRef
    pure case topFibMaybe of
      Nothing -> do
        topFib <- liftEffect $ launchAff $ getTopMD affjaxDriver
        liftEffect $ write (Just topFib) topFibMaybeRef
        joinFiber topFib
      Just topFib -> joinFiber topFib
