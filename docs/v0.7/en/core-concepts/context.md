# Context

## Context's role

The context is a global record that is passed to all components. You can provide context by passing it to `_mount` function, and get the context by using the `useContext` function. Type of a component that uses the context is `Component context`.

State can be shared among components by managing `Signal` values in context.

### Example

```preview
context
```

```purescript
module Example.Context where

import Prelude

import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Jelly (Component, hooks, mount_, on, text, textSig)
import Jelly.Data.Signal (Atom, Signal, modifyAtom_, newStateEq)
import Jelly.Element as JE
import Jelly.Hooks (useContext)
import Web.DOM (Node)
import Web.HTML.Event.EventTypes (click)

type Context = (countSig :: Signal Int, countAtom :: Atom Int)

mountWithContext :: Node -> Effect Unit
mountWithContext node = do
  countSig /\ countAtom <- newStateEq 0
  mount_ { countSig, countAtom } parentComponent node

parentComponent :: Component Context
parentComponent = hooks do
  { countAtom } <- useContext

  pure do
    JE.button [ on click \_ -> modifyAtom_ countAtom (add 1) ] $ text "Increment"
    childComponent

childComponent :: Component Context
childComponent = hooks do
  { countSig } <- useContext

  pure do
    textSig $ show <$> countSig

```

## Append contexts

Context is defined as a record, so you can append contexts.

### Example

```preview
appendContexts
```

```purescript
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
  { fizz, buzz } <- useContext

  pure do
    text fizz
    text buzz

```
