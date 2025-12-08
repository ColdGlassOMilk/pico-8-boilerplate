# Pico-8 Boilerplate

A minimal boilerplate for Pico-8 projects with input management, scene handling, and nested menus.

## Features

- **Input Management** – Bind buttons to actions with context switching
- **Scene Management** – Switch between game scenes with `switch()`, `push()`, and `pop()`
- **Message Bus** – Event system for decoupled communication
- **Menu System** – Nested menus with dynamic states and actions

## Quick Start

### Create a Scene

```lua
my_scene = {}

function my_scene:init()
  -- setup
end

function my_scene:update()
  -- game logic
end

function my_scene:draw()
  -- rendering
end

function my_scene:exit()
  -- cleanup
end
```

### Register & Switch Scenes

```lua
function _init()
  scene:register('game', my_scene)
  scene:switch('game')
end
```

### Create Menus

```lua
my_menu = menu:new({
  {label="start", action=function() scene:switch("game") end},
  {label="options", sub_menu=menu:new({
    {label="sound", action=function() sfx_on=true end}
  })},
  {label="quit", action=function() return true end}
}, x, y)
```

### Bind Input

If using the **state system**, define a `bindings` table in your state and it's automatically managed:

```lua
my_state = {
  bindings = {
    [input.button.x] = function() my_menu:show() end
  }
}
```

For **manual control** in scenes, use `input:bind()` in `init()` and `input:clr()` in `exit()`:

```lua
input:bind({
  [input.button.x] = function() my_menu:show() end,
  [input.button.o] = function() my_menu:hide() end,
  [input.button.hold.left] = function() player.x -= 1 end
})
```

Use `input.button.hold.*` for continuous input like movement. Regular buttons trigger on press.

Available buttons: `left`, `right`, `up`, `down`, `o`, `x`

### Use States Within Scenes

For complex scenes with multiple states (e.g., playing, paused, game over):

```lua
function my_scene:init()
  self.fsm = state:new({
    playing = playing_state,
    paused = paused_state
  }, 'playing')
end

function my_scene:update()
  self.fsm:update()
end
```

### Message Bus

Send and receive events across your game:

```lua
-- subscribe
message_bus:subscribe('player_died', function(data)
  lives = lives - 1
end)

-- emit
message_bus:emit('player_died', {reason='fell'})
```

### Cleanup on Exit

```lua
function my_scene:exit()
  if my_menu.active then
    my_menu:hide()
    my_menu:close_parents()
  end
  input:clr()
end
```

That's it! Check the source files for more details.
