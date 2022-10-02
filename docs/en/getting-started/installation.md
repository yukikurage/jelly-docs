# Installation

It is assumed that NPM, purescript and spago are installed.

```bash
spago install jelly
```

## Temporary

Jelly 0.5.0 is currently registered in [purescript/registry](https://github.com/purescript/registry) but not in [purescript/packages-sets](https://github.com/purescript/package-sets). So, you need to add the following to your `packages.dhall`:

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

and run `spago install jelly`.
