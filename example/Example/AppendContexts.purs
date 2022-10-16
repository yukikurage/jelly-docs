module Example.AppendContexts where

import Prelude

import Effect (Effect)
import Jelly.Data.Component (Component, text)
import Jelly.Data.Hooks (hooks)
import Jelly.Hooks.UseContext (useContext)
import Jelly.Mount (mount_)
import Record (union)
import Web.DOM (Node)

type Fizz r = (fizz :: String | r)
type Buzz r = (buzz :: String | r)

-- | Append two contexts
type Context = Fizz (Buzz ())

appendContextsMount :: Node -> Effect Unit
appendContextsMount node = do
  let
    fizzContext = { fizz: "fizz" }
    buzzContext = { buzz: "buzz" }
    context = union fizzContext buzzContext
  mount_ context component node

component :: Component Context
component = hooks do
  { fizz, buzz } <- useContext

  pure do
    text fizz
    text buzz
