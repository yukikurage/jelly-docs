# Component

`Component` represents a piece of HTML. By creating a `Component` for each part of the application, you can reuse it and avoid definition bloat.

## Element

`Jelly.Element` provides function for each HTML tag: `div`, `p`, `button`,...
They have the following types.

```purescript
div :: forall m. Array (Prop m) -> Component m -> Component m
```

It takes an array of properties and child components as arguments and generates components.

### Example

<pre class="preview">hello</pre>

```purescript
component :: forall m. Component m
component = do
  JE.div [] do
    text "Hello World!"
    text "this is component"
```

## Element with no propaties

When the property is an empty array, as in the `div` example above, you can use functions with dash instead: `div'`, `p'`, `button'` ...

```purescript
div' :: forall m. Component m -> Component m
```

The above example could be rewritten as follows

```purescript
component :: forall m. Component m
component = do
  JE.div' do
    text "Hello World!"
    text "this is component"
```

## Component separation

Components can be easily separated and reused.

```purescript
helloWorld :: forall m. Component m
helloWorld = do
  JE.div' do
    text "Hello World!"
    text "this is component"

component :: forall m. Component m
component = do
  helloWorld
  helloWorld
  helloWorld
```

<pre class="preview">hello3</pre>