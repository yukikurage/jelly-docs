module Example.AppendContexts where

import Prelude

import Effect (Effect)
import Jelly (type (+), Component, hooks, mount_, text)
import Jelly.Hooks (useContext)
import Web.DOM (Node)

type FizzContext context = (fizz :: String | context)

type BuzzContext context = (buzz :: String | context)

-- | Append two contexts
type Context = FizzContext + BuzzContext + ()

appendContextsMount :: Node -> Effect Unit
appendContextsMount node = do
  mount_ { fizz: "Fizz", buzz: "Buzz" } component node

component :: Component Context
component = hooks do
  {fizz, buzz} <- useContext

  pure do
    text fizz
    text buzz
