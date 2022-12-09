# Hooks

Hooks represent side effects and have the feature that a cleanup effect can be written.

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
prop :: forall m. MonadHooks m => Prop m
prop = on click \_ -> hook
```

Passing this as a Prop for the button will cause a `hook` to be executed when clicked.

```purescript
component = JE.button [ on click \_ -> hook ] $ text "Run"
```

---

## As component lifecycle
