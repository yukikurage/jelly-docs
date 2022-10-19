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

import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Jelly.Data.Component (Component, el, text, textSig)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop (on)
import Jelly.Data.Signal (Atom, Signal, patch_, signal)
import Jelly.Hooks.UseContext (useContext)
import Jelly.Mount (mount_)
import Web.DOM (Node)
import Web.HTML.Event.EventTypes (click)

type Context = (countState :: Signal Int /\ Atom Int)

mountWithContext :: Node -> Effect Unit
mountWithContext node = do
  countState <- signal 0
  mount_ { countState } parentComponent node

parentComponent :: Component Context
parentComponent = hooks do
  { countState: _ /\ countAtom } <- useContext

  pure do
    el "button" [ on click \_ -> patch_ countAtom (add 1) ] $ text "Increment"
    childComponent

childComponent :: Component Context
childComponent = hooks do
  { countState: countSig /\ _ } <- useContext

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
```
