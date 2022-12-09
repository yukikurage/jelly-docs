# Hooks

Hooks represent effects and have the feature that a cleanup effect can be written.

---

## Use Cleaner

A cleanup effect is a process, for example, to unsubscribe from an event or to stop a timer. Cleanup effects can be added using the `useCleaner` function.

```purescript
useCleaner :: forall m a. MonadHooks m => Effect Unit -> m a
```

`MonadHooks` is a typeclass for generalizing monads with the same functionality as `Hooks`. Usually `m` is `Hooks`. See [→ Custom Monad](./custom-monad) for more information.

##### 🚩 Example

Open devtools and see the console. Each time the button is pressed, the Hook is executed, but before the second execution, a cleanup effect is performed.

<pre class="preview">hook</pre>

```purescript
hook :: forall m. MonadHooks m => m Unit
hook = do
  log "Running"

  useCleaner do
    log "Cleaning"
```

---

## As event listener

Let's connect the created Hook to the component. You can create an event listener of type `Prop` with the `on` function.

```purescript
on :: forall m. EventType -> (Event -> m Unit) -> Prop m
```

`EventType` is a type defined in the <a href="https://pursuit.purescript.org/packages/purescript-web-events" target="_blank">purescript-web-events</a> package and represents the type of event, such as `click`, `change` or etc. This time, we will use the `click` event defined in <a href=https://pursuit.purescript.org/packages/purescript-web-html/docs/Web.HTML.Event.EventTypes target="_blank">Web.HTML.Event</a>

```purescript
on click \_ -> hook
```

Passing this as a Prop for the button will cause a `hook` to be executed when clicked.

```purescript
component = JE.button [ on click \_ -> hook ] $ text "Run"
```

---

## As component lifecycle

Hooks can be used as component lifecycle events. That is, it runs when the component is initialized and sets up a cleanup effect for when the component is unmounted. To do this, you need to use the `hooks` function.

```purescript
hooks :: forall m. m (Component m) -> Component m
```

It is used as follows.

```purescript
component :: forall m. MonadHooks m => Component m
component = hooks do
  -- Some hooks here
  pure do
    -- Component here
```

##### 🚩 Example

Mount/unmount the component using the buttons and check the output on the console. Now, how to perform component mounting/unmounting, please refer to the [next section](./signal).

<pre class="preview">hooks</pre>

```purescript
component :: forall m. MonadHooks m => Component m
component = hooks do
  hook
  pure do
    text "This is Hooks"
```
