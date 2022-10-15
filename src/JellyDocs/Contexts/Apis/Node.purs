module JellyDocs.Contexts.Apis.Node where

import Prelude

import Affjax.Node (driver)
import Control.Parallel (parSequence_)
import Data.Either (Either(..))
import Data.Functor (mapFlipped)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import JellyDocs.Contexts.Apis (Apis, newApis)

newNodeApis :: Aff Apis
newNodeApis = do
  apis <- liftEffect $ newApis driver
  response <- apis.docs.refetch
  let
    docIds = case response of
      Right docListItems -> mapFlipped docListItems \{ id } -> id
      Left _ -> []
  parSequence_ $
    map (\docId -> void $ apis.doc.refetch docId) docIds <>
      [ void $ apis.sections.refetch
      , void $ apis.notFound.refetch
      , void $ apis.top.refetch
      ]
  pure apis
