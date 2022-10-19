module JellyDocs.NodeMain where

import Prelude

import Affjax.Node (driver)
import Control.Parallel (parSequence_, parTraverse_)
import Data.Either (Either(..))
import Data.Functor (mapFlipped)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Render (render)
import Jelly.Router.Data.Path (makeRelativeFilePath)
import Jelly.Router.Data.Router (newMockRouter)
import JellyDocs.Context (Context(..))
import JellyDocs.Contexts.Apis (newApis)
import JellyDocs.Data.Page (Page(..), pageToUrl)
import JellyDocs.RootComponent (rootComponent)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (mkdir', writeTextFile)
import Node.FS.Perms (all, mkPerms)

main :: Effect Unit
main = launchAff_ do
  -- Make Apis Store
  apis <- liftEffect $ newApis driver

  -- Fetch and store docs
  docsStates <- apis.docs.initialize
  let
    docIds = case docsStates of
      Right docListItems -> mapFlipped docListItems \{ id } -> id
      Left _ -> []

  -- Prefetch all store
  -- This eliminates data load time and allows the data contents to be used when rendering.
  parSequence_ $
    map (void <<< apis.doc.initialize) docIds <>
      [ void $ apis.sections.initialize
      , void $ apis.notFound.initialize
      , void $ apis.top.initialize
      ]

  -- generate HTML
  let
    pageToOutDir page = [ "public" ] <> (pageToUrl page).path
    genHTML page dirname filename = do
      router <- liftEffect $ newMockRouter $ pageToUrl page
      let
        context = Context { router, apis }
      rendered <- liftEffect $ render context rootComponent
      mkdir' (makeRelativeFilePath $ dirname) { mode: mkPerms all all all, recursive: true }
      writeTextFile UTF8 (makeRelativeFilePath $ dirname <> [ filename ]) rendered

  -- Top
  genHTML PageTop (pageToOutDir PageTop) "index.html"

  -- Docs
  case docsStates of
    Right docs -> flip parTraverse_ docs \{ id } -> genHTML (PageDoc id) (pageToOutDir $ PageDoc id) "index.html"
    _ -> pure unit

  -- NotFound
  -- Cloudflare pages requires a 404.html
  genHTML PageNotFound [ "public" ] "404.html"
