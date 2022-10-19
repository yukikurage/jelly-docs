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
import Jelly.Data.Signal (Signal, modifyAtom_, newState, readSignal, writeAtom)
import Jelly.Hooks.UseContext (useContext)
import JellyDocs.Apis.Doc (getDoc, getDocs, getSections)
import JellyDocs.Apis.NotFound (getNotFoundMD)
import JellyDocs.Apis.Top (getTopMD)
import JellyDocs.Data.Doc (Doc, DocListItem)
import JellyDocs.Data.Section (Section)

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

class ApisContext context where
  getApis :: context -> Apis

useApis :: forall context. ApisContext context => Hooks context Apis
useApis = getApis <$> useContext

newApis :: AffjaxDriver -> Effect Apis
newApis driver = do
  let
    monoDataApi :: forall a. Aff (AffjaxResponse a) -> Effect (Api a)
    monoDataApi affjax = do
      stateSig /\ stateAtom <- newState Nothing
      let
        refetch = do
          response <- affjax
          writeAtom stateAtom $ Just response
          pure response
        initialize = do
          state <- readSignal stateSig
          case state of
            Just response -> pure response
            Nothing -> refetch
      pure { stateSig, refetch, initialize }

    multipleDataApi :: forall a. (String -> Aff (AffjaxResponse a)) -> Effect (MultipleApi a)
    multipleDataApi affjax = do
      statesSig /\ statesAtom <- newState empty
      let
        refetch key = do
          response <- affjax key
          modifyAtom_ statesAtom \states -> insert key response states
          pure response
        initialize key = do
          states <- readSignal statesSig
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
