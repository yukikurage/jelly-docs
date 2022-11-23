# Static HTML

## Component

`Jelly.Element` provides `{tag}` & `{tag}'` function for each HTML tag.

`{tag}` and `{tag}'` are functions to create a single element Component. `{tag}` can take props, whereas `{tag}'` cannot. `text` is a function to creates a text node Component.

Props represent attributes and event handlers. You can define attributes using the `:=` operator.

### Example

```purescript
component = JE.h1 [ "class" := "title" ] do
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
component = do
  JE.div' do
    JE.h1' do
      text "Hello, Jelly!"
    JE.p' do
      text "This is a Jelly example."
      JE.div' do
        text "This is a nested element."
```
