module JellyDocs.Component.Markdown where

import Prelude

import Data.Foldable (for_, traverse_)
import Effect (Effect)
import Effect.Class (liftEffect)
import Example (preview)
import Jelly.Component (Component, raw, switch)
import Jelly.Element as JE
import Jelly.Hooks (class MonadHooks)
import Jelly.Prop (onMount, (:=))
import Jelly.Signal (Signal)
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

markdownComponent :: forall m. MonadHooks m => Signal String -> Component m
markdownComponent markdownSig =
  let
    renderedSig = parseMarkdown <$> markdownSig
  in
    switch do
      rendered <- renderedSig
      pure
        $ JE.div
            [ "class" := "w-full h-full markdown", emojiProp, onMount preview, onMount $ liftEffect <<< addOpenNewTabAttrToAnchors ]
        $ raw rendered
