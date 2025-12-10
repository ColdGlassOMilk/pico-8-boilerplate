-- main

function _init()
  -- slot:init("pico8_bp", {"bgcol"})
  app:init({
    name = "pico8_bp",
    title = "Pico-8 Boilerplate",
    defaults = {
      bgcol = 8
    }
  })

  scene:register('title', title_scene)
  scene:register('game', game_scene)
  scene:switch('title')
end

function _update()
  input:update()
  scene:update()
end

function _draw()
  scene:draw()
end
