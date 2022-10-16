module Example where

import Prelude

import Data.Foldable (for_)
import Data.HashMap (HashMap, fromFoldable, lookup)
import Data.Maybe (Maybe(..))
import Data.String (codePointFromChar, takeWhile)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Example.Counter (counterExample)
import Example.Hooks (hooksExampleWrapper)
import Jelly.Mount (mount_)
import Web.DOM (Element, Node)
import Web.DOM.Element as Element
import Web.DOM.Node (textContent)
import Web.DOM.NodeList as NodeList
import Web.DOM.ParentNode (QuerySelector(..), querySelectorAll)

examples :: HashMap String (Node -> Effect Unit)
examples = fromFoldable
  [ "counter" /\ mount_ {} counterExample
  , "hooks" /\ mount_ {} hooksExampleWrapper
  ]

preview :: Element -> Effect Unit
preview element = do
  let
    pn = Element.toParentNode element
  previewNodes <- NodeList.toArray =<< querySelectorAll (QuerySelector "pre code.preview") pn
  for_ previewNodes \node -> do
    name <- takeWhile (\cp -> cp /= codePointFromChar '\n') <$> textContent node
    case lookup name examples of
      Just example -> example node
      Nothing -> pure unit
