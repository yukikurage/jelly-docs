module JellyDocs.NodeMain where

import Prelude

import Affjax.Node (driver)
import Control.Parallel (parTraverse_)
import Data.Array (last)
import Data.Either (Either(..))
import Data.Maybe (fromMaybe)
import Data.String (Pattern(..), length, split, take)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Render (render)
import Jelly.Signal (readSignal)
import JellyDocs.Api.Doc (getDocs)
import JellyDocs.AppM (runAppMNode)
import JellyDocs.Data.Page (Page(..), pageToRoute)
import JellyDocs.RootComponent (rootComponent)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (mkdir', writeTextFile)
import Node.FS.Perms (all, mkPerms)

main :: Effect Unit
main = launchAff_ do
  docsStates <- getDocs driver

  -- generate HTML
  let
    pageToOutFile page = "public/" <> pageToRoute page <> ".html"
    genHTML page filename = do
      rendered /\ stop <- liftEffect $ runAppMNode (render rootComponent) driver page
      let
        dirname = take (length filename - length (fromMaybe "" $ last $ split (Pattern "/") filename)) filename
      mkdir' dirname { mode: mkPerms all all all, recursive: true }
      writeTextFile UTF8 (filename) =<< readSignal rendered
      liftEffect stop

  -- Top
  genHTML PageTop "public/index.html"

  -- Docs
  case docsStates of
    Right docs -> flip parTraverse_ docs \{ id } -> genHTML (PageDoc id) (pageToOutFile $ PageDoc id)
    _ -> pure unit

  -- NotFound
  -- Cloudflare pages requires a 404.html
  genHTML PageNotFound "public/404.html"
