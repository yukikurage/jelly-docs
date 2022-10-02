# Hello World

First, create HTML to load JavaScript.

`public/index.html`

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Hello World</title>
    <script src="./index.js" defer=""></script>
  </head>
  <body>
    <div id="app"></div>
  </body>
</html>
```

Next, write the main script

`src/Main.purs`.

```haskell
module Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Core.Aff (awaitQuerySelector)
import Jelly.Core.Data.Component (Component, el_, text)
import Jelly.Core.Mount (mount_)
import Web.DOM.Element as Element
import Web.DOM.ParentNode (QuerySelector(..))

type Context = ()

main :: Effect Unit
main = launchAff_ do
  appMaybe <- awaitQuerySelector (QuerySelector "#app")
  case appMaybe of
    Nothing -> pure unit
    Just app -> liftEffect $ mount_ {} bodyComponent $ Element.toNode app

bodyComponent :: Component Context
bodyComponent = do
  el_ "h1" do
    text $ pure "Hello World!"

```

Finally, bundle the application.

```
spago bundle-app -t . /public/index.js
```

Now, when you open `public/index.html` in your browser, you will see a big Hello World!

## Explanation of Hello World

```haskell
type Context = ()
```

This is a Row representation of the context of the component. See [context](. /context) for more information. You don't need to worry about it at this stage.

```haskell
main :: Effect Unit
main = launchAff_ do
  appMaybe <- awaitQuerySelector (QuerySelector "#app")
  case appMaybe of
    Nothing -> pure unit
    Just app -> liftEffect $ mount_ {} bodyComponent $ Element.toNode app
```

It does a lot of things, but the short version is that I get an element with an id of `"app"` and mount the `bodyComponent`.

Since we don't know for sure if such an element exists, `appMaybe` is of type `Maybe Element`, and the `mount_` function takes the `Node` type, so we convert it with `Element.toNode`.

```haskell
bodyComponent :: Component Context
bodyComponent = do
  el_ "h1" do
    text $ pure "Hello World!"
```

The `Component` type represents a piece of HTML. The `el_` function creates an `h1` element, and the `text` function adds a string to it.

By mounting this `bodyComponent` in index.html, the final HTML is composed as follows.

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Hello World</title>
    <script src="./index.js" defer=""></script>
  </head>
  <body>
    <div id="app">
      <h1>Hello World!</h1>
    </div>
  </body>
</html>
```
