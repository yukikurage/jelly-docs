module JellyDocs.Pages.NotFound where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Core.Data.Component (Component, el)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=))
import Jelly.Core.Data.Signal (signal, writeAtom)
import Jelly.Core.Hooks.UseContext (useContext)
import Jelly.Generator.Data.StaticData (loadStaticData)
import JellyDocs.Components.Markdown (markdownComponent)
import JellyDocs.Context (Context)

notFoundPage :: Component Context
notFoundPage = hooks do
  { notFoundMD } <- useContext

  mdSig /\ mdAtom <- signal ""

  liftEffect $ launchAff_ do
    mdMaybe <- loadStaticData notFoundMD
    case mdMaybe of
      Just md -> writeAtom mdAtom md
      Nothing -> pure unit

  pure $ el "div" [ "class" := "p-10" ] $ markdownComponent mdSig
