{-
Welcome to a Spago project!
You can edit this file as you like.

Need help? See the following resources:
- Spago documentation: https://github.com/purescript/spago
- Dhall language tour: https://docs.dhall-lang.org/tutorials/Language-Tour.html

When creating a new Spago project, you can use
`spago init --no-comments` or `spago init -C`
to generate this file without the comments in this block.
-}
{ name = "jelly-docs"
, dependencies =
  [ "aff"
  , "affjax"
  , "affjax-node"
  , "affjax-web"
  , "arrays"
  , "console"
  , "effect"
  , "either"
  , "foldable-traversable"
  , "jelly"
  , "jelly-hooks"
  , "jelly-router"
  , "jelly-signal"
  , "maybe"
  , "node-buffer"
  , "node-fs"
  , "node-fs-aff"
  , "ordered-collections"
  , "parallel"
  , "partial"
  , "prelude"
  , "refs"
  , "routing-duplex"
  , "strings"
  , "tailrec"
  , "transformers"
  , "tuples"
  , "unordered-collections"
  , "web-dom"
  , "web-events"
  , "web-html"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs", "example/**/*.purs" ]
}
