module JellyDocs.Components.Markdown where

import Prelude

import Data.Foldable (for_, traverse_)
import Effect (Effect)
import Example (preview)
import Jelly (Component, hooks, onMount, rawC, signalC, (:=))
import Jelly.Data.Signal (Signal)
import Jelly.Element as JE
import JellyDocs.Twemoji (emojiProp)
import Web.DOM (Element)
import Web.DOM.Element (setAttribute)
import Web.DOM.Element as Element
import Web.DOM.NodeList as NodeList
import Web.DOM.ParentNode (QuerySelector(..), querySelectorAll)

foreign import parseMarkdown :: String -> String

addOpenNewTabAttrToAnchors :: Element -> Effect Unit
addOpenNewTabAttrToAnchors el = do
  anchors <- NodeList.toArray =<< querySelectorAll (QuerySelector "a") (Element.toParentNode el)
  for_ anchors \anchor -> do
    traverse_ (setAttribute "target" "_blank") $ Element.fromNode anchor
    traverse_ (setAttribute "rel" "noopener noreferrer") $ Element.fromNode anchor

markdownComponent :: forall context. Signal String -> Component context
markdownComponent markdownSig = hooks do
  let
    renderedSig = parseMarkdown <$> markdownSig

  pure $ signalC do
    rendered <- renderedSig
    pure
      $ JE.div
          [ "class" := "w-full h-full markdown", emojiProp, onMount preview, onMount addOpenNewTabAttrToAnchors ]
      $ rawC rendered
