module JellyDocs.Contexts.Apis where

import Prelude

import Affjax (AffjaxDriver, Error)
import Data.Either (Either)
import Data.HashMap (HashMap, empty, insert, lookup)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff)
import Jelly.Data.Hooks (Hooks)
import Jelly.Data.Signal (Signal, get, patch_, send, signal)
import Jelly.Hooks.UseContext (useContext)
import JellyDocs.Apis.Doc (getDoc, getDocs, getSections)
import JellyDocs.Apis.NotFound (getNotFoundMD)
import JellyDocs.Apis.Top (getTopMD)
import JellyDocs.Data.Doc (Doc, DocListItem)
import JellyDocs.Data.Section (Section)
import Record (union)

type AffjaxResponse a = Either Error a

type Api a =
  { stateSig :: Signal (Maybe (AffjaxResponse a))
  , initialize :: Aff (AffjaxResponse a)
  , refetch :: Aff (AffjaxResponse a)
  }

type MultipleApi a =
  { statesSig :: Signal (HashMap String (AffjaxResponse a))
  , initialize :: String -> Aff (AffjaxResponse a)
  , refetch :: String -> Aff (AffjaxResponse a)
  }

type Apis =
  { docs :: Api (Array DocListItem)
  , doc :: MultipleApi Doc
  , sections :: Api (Array Section)
  , notFound :: Api String
  , top :: Api String
  }

type ApisContext r = (apis :: Apis | r)

useApis :: forall r. Hooks (ApisContext r) Apis
useApis = useContext <#> (_.apis)

provideApisContext :: forall r. Apis -> Record r -> Record (ApisContext r)
provideApisContext apis context = union { apis } context

newApis :: AffjaxDriver -> Effect Apis
newApis driver = do
  let
    monoDataApi :: forall a. Aff (AffjaxResponse a) -> Effect (Api a)
    monoDataApi affjax = do
      stateSig /\ stateAtom <- signal Nothing
      let
        refetch = do
          response <- affjax
          send stateAtom $ Just response
          pure response
        initialize = do
          state <- get stateSig
          case state of
            Just response -> pure response
            Nothing -> refetch
      pure { stateSig, refetch, initialize }

    multipleDataApi :: forall a. (String -> Aff (AffjaxResponse a)) -> Effect (MultipleApi a)
    multipleDataApi affjax = do
      statesSig /\ statesAtom <- signal empty
      let
        refetch key = do
          response <- affjax key
          patch_ statesAtom \states -> insert key response states
          pure response
        initialize key = do
          states <- get statesSig
          case lookup key states of
            Just response -> do
              pure response
            Nothing -> refetch key
      pure { statesSig, refetch, initialize }

  docs <- monoDataApi $ getDocs driver
  doc <- multipleDataApi $ getDoc driver
  sections <- monoDataApi $ getSections driver
  notFound <- monoDataApi $ getNotFoundMD driver
  top <- monoDataApi $ getTopMD driver
  pure { docs, doc, sections, notFound, top }
