# Static HTML

## `el`, `el'`, and `text`

`el` and `el'` are functions that create HTML elements.

`el` can take props, whereas `el'` cannot.

and `text` is a function that creates text nodes.

```purescript
component = el "h1" [ "class" := "title" ] do
  text $ pure "Hello, Jelly!"
```

↓

```html
<h1 class="title">Hello, Jelly!</h1>
```

Component is a monad and multiple child elements can be created using `do` notation.

```purescript
component = el "div" do
  el' "h1" do
    text $ pure "Hello, Jelly!"
  el' "p" do
    text $ pure "This is a Jelly example."
    el' "div" do
      text $ pure "This is a nested element."
```

## Props

Props represent attributes and event handlers.

In Jelly, you can define attributes using the `:=` operator and handlers using the `on` function.

```purescript
component = el "button" [ "class" := "btn", on "click" \_ -> log "Clicked!" ] do
  text $ pure "Click Me!"
```
