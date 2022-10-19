# Installation

NPM、purescript、spago がインストールされていることが前提です。

```bash
spago install jelly
```

## Temporary

Jelly 0.5.0 は現在、[purescript/registry](https://github.com/purescript/registry)に登録されていますが、[purescript/packages-sets](https://github.com/purescript/package-sets)にはありません。そのため、`packages.dhall`に以下を追加する必要があります。

```dhall
in  upstream
  with jelly =
    { dependencies =
      [ "aff"
      , "affjax"
      , "affjax-web"
      , "arrays"
      , "console"
      , "effect"
      , "either"
      , "exceptions"
      , "foreign"
      , "foreign-object"
      , "free"
      , "js-timers"
      , "maybe"
      , "newtype"
      , "node-buffer"
      , "node-child-process"
      , "node-fs"
      , "node-fs-aff"
      , "node-streams"
      , "parallel"
      , "posix-types"
      , "prelude"
      , "record"
      , "refs"
      , "simple-json"
      , "strings"
      , "tailrec"
      , "transformers"
      , "tuples"
      , "web-dom"
      , "web-events"
      , "web-html"
      , "web-uievents"
      ]
    , repo = "https://github.com/yukikurage/purescript-jelly.git"
    , version = "v0.5.0"
    }
```

この上で、 `spago install jelly` を実行してください。
