# Jelly Documents

Repository of https://jelly.yukikurage.net, A documentation for [purescript-jelly](https://github.com/yukikurage/purescript-jelly).

## How to build

```bash
npm run bundle
```

## How to add or edit documents

### Edit documents

Edit `docs/en/**/*.md` and push or create PR to `master` branch.

#### Embedding Examples

You can embed examples in documents.

Edit or add `example/Example/*.purs` and add `Node -> Effect Unit` function with key to `examples` in `example/Example.purs`

```purescript
examples :: HashMap String (Node -> Effect Unit)
examples = fromFoldable
  [ "counter" /\ mount_ {} counterExample
  , "hooks" /\ mount_ {} hooksExampleWrapper
  , "signalEq" /\ mount_ {} signalEqExample
  , "context" /\ mountWithContext
  , "appendContexts" /\ appendContextsMount
  , "signalC" /\ mount_ {} signalCExample
  ]
```

Finally, write code block which content is key with `preview` tag.

````markdown
```preview
counter
```
````

### Add documents

Add `docs/en/**/*.md`, and add document information to `sections` in `src/JellyDocs/Apis/Doc.purs`

```purescript
sections :: Array Section
sections =
  [ { id: "getting-started"
    , title: "🚀 Getting Started"
    , docs:
        [ { id: "installation"
          , title: "Installation"
          , section: "getting-started"
          }
        , { id: "hello-world"
          , title: "Hello World"
          , section: "getting-started"
          }
        ]
    }
  , { id: "core-concepts"
    , title: "🏗️ Core Concepts"
    , docs:
        [ { id: "static-html"
          , title: "Static HTML"
          , section: "core-concepts"
          }
        -- ...
        ]
    }
  -- ...
  ]
```
