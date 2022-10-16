# Hooks

Hooks is a way to execute effects in a component's life cycle (on mount & unmount).

Using `useUnmountEffect` function in `Hooks` Monad and converting it to `Component` by `hooks` function, you can attach effects to a component.

`hooks` has following type:

```purescript
hooks :: forall context. Hooks context (Component context) -> Component context
```

## Example

Open devtools and see the console.

```purescript
hooksExample :: forall context. Component context
hooksExample = hooks do
  log "Mounted"

  useUnmountEffect do
    log "Unmounted"

  pure do
    text "This is Hooks"
```

```preview
hooks
```
