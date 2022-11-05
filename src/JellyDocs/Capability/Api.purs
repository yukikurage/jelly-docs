module JellyDocs.Capability.Api where

import Prelude

import Affjax (Error)
import Data.Either (Either)
import Effect.Aff (Aff)
import JellyDocs.Data.Doc (Doc, DocListItem)
import JellyDocs.Data.Section (Section)

class Monad m <= Api m where
  useDocsApi :: m (Aff (Either Error (Array DocListItem)))
  useDocApi :: m (String -> Aff (Either Error Doc))
  useSectionsApi :: m (Aff (Either Error (Array Section)))
  useNotFoundApi :: m (Aff (Either Error String))
  useTopApi :: m (Aff (Either Error String))
