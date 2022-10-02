# Hello World

まず、JavaScript を読み込むための HTML を作成します。

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

次に、メインスクリプトを書きます

`src/Main.purs`

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

最後に、アプリケーションをバンドルします。

```
spago bundle-app -t ./public/index.js
```

これで、`public/index.html` をブラウザで開くと、Hello World! と大きく表示されます。

## Hello World の解説

```haskell
type Context = ()
```

これは、コンポーネントのコンテキストを Row で表したものです。詳しい事は [context](../context) を参照してください。現段階では気にする必要はありません。

```haskell
main :: Effect Unit
main = launchAff_ do
  appMaybe <- awaitQuerySelector (QuerySelector "#app")
  case appMaybe of
    Nothing -> pure unit
    Just app -> liftEffect $ mount_ {} bodyComponent $ Element.toNode app
```

色々やっていますが、簡単に説明すると、`"app"` という id を持つ要素を取得し、`bodyComponent` をマウントしています。

そのような要素が確実に存在するのか分からないため、`appMaybe` は `Maybe Element` 型になっていて、また `mount_` 関数は `Node` 型をとるため `Element.toNode` で変換しています。

```haskell
bodyComponent :: Component Context
bodyComponent = do
  el_ "h1" do
    text $ pure "Hello World!"
```

`Component` 型は、HTML の一部を表します。`el_`　関数によって `h1` 要素を作成し、その中に `text` 関数で文字列を追加しています。

この `bodyComponent` を index.html にマウントすることで、最終的には次のような HTML が構成されます。

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
