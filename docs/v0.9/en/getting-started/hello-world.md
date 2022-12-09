# Hello World

Let's Create the first Jelly application!

---

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

`src/Main.purs`

```purescript
module Example.HelloWorld where

import Prelude

import Data.Foldable (traverse_)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Aff (awaitBody)
import Jelly.Component (Component, text)
import Jelly.Hooks (runHooks_)
import Jelly.Hydrate (mount)

main :: Effect Unit
main = launchAff_ do
  appMaybe <- awaitBody
  liftEffect $ runHooks_ $ traverse_ (mount component) appMaybe

component :: forall m. Component m
component = text "Hello World!"
```

Finally, bundle the application.

```
spago bundle-app -t ./public/index.js
```

Now, when you open `public/index.html` in your browser, you will see a Hello World!

## Explanation of Hello World

```purescript
main :: Effect Unit
main = launchAff_ do
  appMaybe <- awaitBody
  liftEffect $ runHooks_ $ traverse_ (mount component) appMaybe
```

Get an body element and mount the `component`.

```purescript
component :: forall m. Component m
component = text "Hello World!"

```

The `Component` type class represents a piece of HTML. the `text` function adds a string to it.

By mounting this `component` in index.html, the final HTML is composed as follows.

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Hello World</title>
    <script src="./index.js" defer=""></script>
  </head>
  <body>
    Hello World!
  </body>
</html>
```
