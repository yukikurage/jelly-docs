# Installation

It is assumed that NPM, purescript and spago are installed.

```bash
spago install jelly
```

## Temporary

Jelly 0.6.0 is currently registered in [purescript/registry](https://github.com/purescript/registry) but not in [purescript/packages-sets](https://github.com/purescript/package-sets). So, you need to add the following to your `packages.dhall`:

```dhall
in  upstream
  with jelly =
    { dependencies =
      [ "aff"
      , "arrays"
      , "console"
      , "effect"
      , "either"
      , "foreign"
      , "free"
      , "js-timers"
      , "maybe"
      , "newtype"
      , "prelude"
      , "record"
      , "refs"
      , "strings"
      , "tailrec"
      , "transformers"
      , "tuples"
      , "unordered-collections"
      , "web-dom"
      , "web-events"
      , "web-html"
      ]
    , repo = "https://github.com/yukikurage/purescript-jelly.git"
    , version = "v0.6.0"
    }
```

and run `spago install jelly`.
