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
  <body></body>
</html>
```

Next, write the main script

`src/Main.purs`.

```haskell
module Main where

import Prelude

import Data.Foldable (traverse_)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Aff (awaitBody)
import Jelly.Data.Component (Component, el', text)
import Jelly.Mount (mount_)

type Context :: Row Type
type Context = ()

main :: Effect Unit
main = launchAff_ do
  appMaybe <- awaitBody
  liftEffect $ traverse_ (mount_ {} bodyComponent) appMaybe

bodyComponent :: Component Context
bodyComponent = do
  el' "h1" do
    text "Hello World!"
```

Finally, bundle the application.

```
spago bundle-app -t . /public/index.js
```

Now, when you open `public/index.html` in your browser, you will see a big Hello World!

## Explanation of Hello World

```haskell
type Context :: Row Type
type Context = ()
```

This is a Row representation of the context of the component. See [context](../context) for more information. You don't need to worry about it at this stage.

```haskell
main :: Effect Unit
main = launchAff_ do
  appMaybe <- awaitBody
  liftEffect $ traverse_ (mount_ {} bodyComponent) appMaybe
```

Get an body element and mount the `bodyComponent`.

```haskell
bodyComponent :: Component Context
bodyComponent = do
  el' "h1" do
    text $ pure "Hello World!"
```

The `Component` type represents a piece of HTML. The `el'` function creates an `h1` element, and the `text` function adds a string to it.

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
