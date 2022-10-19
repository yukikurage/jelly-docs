module Example.AppendContexts where

import Prelude

import Effect (Effect)
import Jelly.Data.Component (Component, text)
import Jelly.Data.Hooks (hooks)
import Jelly.Hooks.UseContext (useContext)
import Jelly.Mount (mount_)
import Web.DOM (Node)

class FizzContext context where
  getFizz :: context -> String

class BuzzContext context where
  getBuzz :: context -> String

-- | Append two contexts
data Context = Context String String

instance FizzContext Context where
  getFizz (Context fizz _) = fizz

instance BuzzContext Context where
  getBuzz (Context _ buzz) = buzz

appendContextsMount :: Node -> Effect Unit
appendContextsMount node = do
  let
    context = Context "Fizz" "Buzz"
  mount_ context component node

component :: Component Context
component = hooks do
  context <- useContext

  pure do
    text $ getFizz context
    text $ getBuzz context
