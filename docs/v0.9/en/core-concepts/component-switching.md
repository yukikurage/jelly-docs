# Component switching

## `useHooks_` function

Component can be swapped with another component by using `switch` function. The type of `switch` is below:

```purescript
switch :: forall a. Signal (Component m) -> Component m
```

### Example

<pre class="preview">switching</pre>

<details class="preview">
<summary>Code</summary>
  
```purescript
module Example.Switching where

import Prelude

import Data.Tuple.Nested ((/\))
import Jelly.Component (Component, hooks, switch, text, textSig)
import Jelly.Element as JE
import Jelly.Hooks (class MonadHooks, useStateEq)
import Jelly.Prop (on)
import Jelly.Signal (modifyChannel\_)
import Web.HTML.Event.EventTypes (click)

switchingExample :: forall m. MonadHooks m => Component m
switchingExample = hooks do
componentNumSig /\ componentNumChannel <- useStateEq 1

pure do
JE.button [ on click \_ -> modifyChannel_ componentNumChannel (_ + 1) ] $ text "Increment"
JE.button [ on click \_ -> modifyChannel_ componentNumChannel (_ - 1) ] $ text "Decrement"
JE.div' do
textSig $ pure "Component number: " <> show <$> componentNumSig
JE.div' do
switch $ componentNumSig <#> case _ of
1 -> component1
2 -> component2
3 -> component3
_ -> text "No such component"

component1 :: forall m. Component m
component1 = text "This is component 1"

component2 :: forall m. Component m
component2 = text "This is component 2"

component3 :: forall m. Component m
component3 = text "This is component 3"

```

</details>

