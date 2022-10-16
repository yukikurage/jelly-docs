# Static HTML

## Component

`el` and `el'` are functions to create a single element Component. `el` can take props, whereas `el'` cannot. `text` is a function to creates a text node Component.

Props represent attributes and event handlers. You can define attributes using the `:=` operator.

### Example

```purescript
component = el "h1" [ "class" := "title" ] do
  text "Hello, Jelly!"
```

↓

```html
<h1 class="title">Hello, Jelly!</h1>
```

## Component Concatenation

Component is a monad and multiple child elements can be created using `do` notation.

### Example

```purescript
component = el' "div" do
  el' "h1" do
    text "Hello, Jelly!"
  el' "p" do
    text "This is a Jelly example."
    el' "div" do
      text "This is a nested element."
```
