module Example where

import Prelude

import Data.Foldable (for_)
import Data.HashMap (HashMap, fromFoldable, lookup)
import Data.Maybe (Maybe(..))
import Data.String (codePointFromChar, takeWhile)
import Data.Tuple.Nested ((/\))
import Effect.Class (liftEffect)
import Example.Context (mountWithContext)
import Example.Counter (counterExample)
import Example.HelloWorld (hello3Component, helloComponent)
import Example.Hooks (hookWrapper, hooksExampleWrapper)
import Example.Switching (switchingExample)
import Jelly.Hooks (class MonadHooks, Hooks, liftHooks)
import Jelly.Hydrate (mount)
import Web.DOM (Element, Node)
import Web.DOM.Element as Element
import Web.DOM.Node (textContent)
import Web.DOM.NodeList as NodeList
import Web.DOM.ParentNode (QuerySelector(..), querySelectorAll)

examples :: HashMap String (Node -> Hooks Unit)
examples = fromFoldable
  [ "counter" /\ mount counterExample
  , "hooks" /\ mount hooksExampleWrapper
  , "hook" /\ mount hookWrapper
  , "context" /\ mountWithContext
  , "switching" /\ mount switchingExample
  , "hello" /\ mount helloComponent
  , "hello3" /\ mount hello3Component
  ]

preview :: forall m. MonadHooks m => Element -> m Unit
preview element = do
  let
    pn = Element.toParentNode element
  previewPres <- liftEffect $ NodeList.toArray =<< querySelectorAll (QuerySelector "pre.preview") pn
  for_ previewPres \node -> do
    name <- liftEffect $ takeWhile (\cp -> cp /= codePointFromChar '\n') <$> textContent node
    case lookup name examples of
      Just example -> liftHooks $ example node
      Nothing -> pure unit
