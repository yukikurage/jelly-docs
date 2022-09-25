module JellyDocs.Pages.Top where

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

topPage :: Component Context
topPage = hooks do
  { topMD } <- useContext

  mdSig /\ mdAtom <- signal ""

  liftEffect $ launchAff_ do
    mdMaybe <- loadStaticData topMD
    case mdMaybe of
      Just md -> writeAtom mdAtom md
      Nothing -> pure unit

  pure $ el "div" [ "class" := "p-10" ] $ markdownComponent mdSig
