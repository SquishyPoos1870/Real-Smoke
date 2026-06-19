local base_smoke = data.raw["trivial-smoke"] and (data.raw["trivial-smoke"]["smoke"] or data.raw["trivial-smoke"]["smoke-fast"])

if base_smoke then
  local function make_smoke(name, color, start_scale, end_scale, duration, fade_in, spread, fade_away, slowdown)
    local smoke = table.deepcopy(base_smoke)
    smoke.name = name
    smoke.color = color
    smoke.start_scale = start_scale
    smoke.end_scale = end_scale
    smoke.duration = duration
    smoke.fade_in_duration = fade_in
    smoke.spread_duration = spread
    smoke.fade_away_duration = fade_away
    smoke.movement_slow_down_factor = slowdown
    smoke.affected_by_wind = true
    smoke.show_when_smoke_off = true
    smoke.render_layer = "smoke"
    smoke.cyclic = true
    if smoke.animation then
      smoke.animation = table.deepcopy(smoke.animation)
      smoke.animation.animation_speed = 0.32
    end
    smoke.localised_name = {"entity-name." .. name}
    smoke.localised_description = {"entity-description." .. name}
    return smoke
  end

  data:extend({
    make_smoke(
      "real-smoke-light",
      {r = 0.40, g = 0.40, b = 0.37, a = 0.24},
      0.22,
      1.05,
      180,
      18,
      70,
      95,
      0.985
    ),
    make_smoke(
      "real-smoke-industrial",
      {r = 0.31, g = 0.30, b = 0.275, a = 0.31},
      0.30,
      1.45,
      250,
      22,
      105,
      125,
      0.988
    ),
    make_smoke(
      "real-smoke-soot",
      {r = 0.22, g = 0.215, b = 0.20, a = 0.28},
      0.28,
      1.35,
      230,
      20,
      95,
      115,
      0.988
    ),
    make_smoke(
      "real-smoke-heavy",
      {r = 0.16, g = 0.15, b = 0.135, a = 0.34},
      0.34,
      1.70,
      285,
      24,
      115,
      135,
      0.989
    ),
    make_smoke(
      "real-smoke-exhaust",
      {r = 0.25, g = 0.245, b = 0.23, a = 0.26},
      0.22,
      1.20,
      210,
      16,
      85,
      105,
      0.987
    ),
    make_smoke(
      "real-smoke-blast",
      {r = 0.07, g = 0.065, b = 0.055, a = 0.62},
      0.85,
      3.20,
      360,
      12,
      140,
      210,
      0.992
    )
  })
end
