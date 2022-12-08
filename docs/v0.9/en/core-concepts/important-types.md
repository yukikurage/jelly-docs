# Important Types

Jelly has several basic types.

## Component

`Component` represents a piece of HTML. By creating a `Component` for each part of the application, you can reuse it and avoid definition bloat.

[→ Component](./component.md)

## Hooks

`Hooks` is an Effective monad that basically does the same thing as `Effect`, but allows you to write "cleanup" effects such as unsubscribing from events, stopping timers, etc.

```purescript
useCleaner :: Effect Unit -> Hooks Unit
```

When the "cleanup" effect is fired is controlled by the `Signal`.

```purescript
useHooks :: forall a. Signal (Hooks a) -> Hooks (Signal a)
```

[→ Hooks](./hooks.md)

### MonadHooks

Hooks are abstracted by typeclasses. This is useful for introducing self-defined monads.

```purescript
useCleaner :: forall m. MonadHooks m => Effect Unit -> m Unit
useHooks :: forall m a. MonadHooks m => Signal (m a) -> m (Signal a)
```

[→ Custom Monad](./custom-monad.md)

## Signal

`Signal` is a type that represents a changing value. Component states and global states are represented by `Signal`.

[→ Signal](./signal.md)

### Channel

`Channel` is an object to update the value of `Signal`.
Since `Signal` is read-only, pass a value to `Channel`, update the value, and create a `Signal` from that `Channel` with the `subscribe` function.
