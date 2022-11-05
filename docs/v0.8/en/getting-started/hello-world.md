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

```purescript
module Example.HelloWorld where

import Prelude

import Data.Foldable (traverse_)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Aff (awaitBody)
import Jelly.Component (class Component, text)
import Jelly.Element as JE
import Jelly.Hydrate (mount)
import Signal.Hooks (runHooks_)

main :: Effect Unit
main = launchAff_ do
  appMaybe <- awaitBody
  liftEffect $ runHooks_ $ traverse_ (mount bodyComponent) appMaybe

bodyComponent :: forall m. Component m => m Unit
bodyComponent = do
  JE.h1' do
    text "Hello World!"

```

Finally, bundle the application.

```
spago bundle-app -t . /public/index.js
```

Now, when you open `public/index.html` in your browser, you will see a Hello World!

## Explanation of Hello World

```purescript
main :: Effect Unit
main = launchAff_ do
  appMaybe <- awaitBody
  liftEffect $ runHooks_ $ traverse_ (mount bodyComponent) appMaybe
```

Get an body element and mount the `bodyComponent`.

```purescript
bodyComponent :: forall m. Component m => m Unit
bodyComponent = do
  JE.h1' do
    text "Hello World!"
```

The `Component` type class represents a piece of HTML. The `el'` function creates an `h1` element, and the `text` function adds a string to it.

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
