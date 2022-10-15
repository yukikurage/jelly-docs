module JellyDocs.NodeMain where

import Prelude

import Control.Parallel (parTraverse_)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Data.Signal (get)
import Jelly.Render (render)
import Jelly.Router.Data.Path (makeRelativeFilePath)
import Jelly.Router.Data.Router (mockRouter, provideRouterContext)
import JellyDocs.Contexts.Apis (provideApisContext)
import JellyDocs.Contexts.Apis.Node (newNodeApis)
import JellyDocs.Data.Page (Page(..), pageToUrl)
import JellyDocs.RootComponent (rootComponent)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (mkdir', writeTextFile)
import Node.FS.Perms (all, mkPerms)

main :: Effect Unit
main = launchAff_ do
  apis <- newNodeApis

  -- generate HTML

  let
    pageToOutDir page = [ "public" ] <> (pageToUrl page).path
    genHTML page = do
      router <- liftEffect $ mockRouter $ pageToUrl page
      let
        context = provideRouterContext router $ provideApisContext apis {}
      rendered <- liftEffect $ render context rootComponent
      mkdir' (makeRelativeFilePath $ pageToOutDir page) { mode: mkPerms all all all, recursive: true }
      writeTextFile UTF8 (makeRelativeFilePath $ pageToOutDir page <> [ "index.html" ]) rendered

  -- Top
  genHTML PageTop

  -- Docs
  docsState <- get apis.docs.stateSig
  case docsState of
    Just (Right docs) -> flip parTraverse_ docs \{ id } -> genHTML $ PageDoc id
    _ -> pure unit
