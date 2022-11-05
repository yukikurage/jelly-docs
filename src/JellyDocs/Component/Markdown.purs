module JellyDocs.Component.Markdown where

import Prelude

import Data.Foldable (for_, traverse_)
import Effect (Effect)
import Effect.Class (liftEffect)
import Example (preview)
import Jelly.Component (class Component, raw)
import Jelly.Element as JE
import Jelly.Prop (onMount, (:=))
import JellyDocs.Twemoji (emojiProp)
import Signal (Signal)
import Signal.Hooks (useHooks_)
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

markdownComponent :: forall m. Component m => Signal String -> m Unit
markdownComponent markdownSig = do
  let
    renderedSig = parseMarkdown <$> markdownSig

  useHooks_ do
    rendered <- renderedSig
    pure
      $ JE.div
          [ "class" := "w-full h-full markdown", emojiProp, onMount preview, onMount $ liftEffect <<< addOpenNewTabAttrToAnchors ]
      $ raw rendered
