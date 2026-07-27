local MACHINE_NAMES = {
  "boiler",
  "stone-furnace",
  "steel-furnace",
  "burner-mining-drill"
}

local VEHICLE_NAMES = {
  "locomotive",
  "car",
  "tank"
}

local DENSITY = {
  subtle = {
    interval = 150,
    machine_chance = 0.35,
    vehicle_chance = 0.28,
    puffs = 1,
    max_per_player = 24
  },
  balanced = {
    interval = 105,
    machine_chance = 0.55,
    vehicle_chance = 0.45,
    puffs = 1,
    max_per_player = 42
  },
  heavy = {
    interval = 85,
    machine_chance = 0.72,
    vehicle_chance = 0.60,
    puffs = 1,
    max_per_player = 64
  },
  cinematic = {
    interval = 55,
    machine_chance = 0.82,
    vehicle_chance = 0.76,
    puffs = 2,
    max_per_player = 90
  }
}

local SMOOTHNESS = {
  performance = {
    interval_multiplier = 1.20,
    chance_multiplier = 0.85,
    max_multiplier = 0.85,
    jitter_multiplier = 1.10,
    vehicle_trail = 0,
    event_multiplier = 0.85
  },
  smooth = {
    interval_multiplier = 0.70,
    chance_multiplier = 1.00,
    max_multiplier = 1.00,
    jitter_multiplier = 0.85,
    vehicle_trail = 1,
    event_multiplier = 1.00
  },
  ["120-style"] = {
    interval_multiplier = 0.38,
    chance_multiplier = 0.88,
    max_multiplier = 1.15,
    jitter_multiplier = 0.62,
    vehicle_trail = 2,
    event_multiplier = 1.15
  },
  ["ultra-real"] = {
    interval_multiplier = 0.30,
    chance_multiplier = 0.82,
    max_multiplier = 1.05,
    jitter_multiplier = 0.48,
    vehicle_trail = 3,
    event_multiplier = 1.05
  }
}

local BLACK_STRENGTH = {
  soft = {
    soot = "real-smoke-industrial",
    heavy = "real-smoke-soot",
    chance_multiplier = 0.78,
    puff_multiplier = 0.75
  },
  realistic = {
    soot = "real-smoke-soot",
    heavy = "real-smoke-heavy",
    chance_multiplier = 0.92,
    puff_multiplier = 0.90
  },
  strong = {
    soot = "real-smoke-heavy",
    heavy = "real-smoke-heavy",
    chance_multiplier = 1.00,
    puff_multiplier = 1.00
  }
}

local REAL_RAIN_STAGE_WEATHER = {
  drizzle = {is_raining = true, storm_factor = 0.65, wind_speed = 0.015, wind_bucket = "straight"},
  rain = {is_raining = true, storm_factor = 1.00, wind_speed = 0.030, wind_bucket = "straight"},
  heavy = {is_raining = true, storm_factor = 1.50, wind_speed = 0.055, wind_bucket = "straight"},
  storm = {is_raining = true, storm_factor = 2.20, wind_speed = 0.090, wind_bucket = "gust"},
  monsoon = {is_raining = true, storm_factor = 3.00, wind_speed = 0.120, wind_bucket = "gust"}
}

local MACHINE_PROFILE = {
  ["boiler"] = {
    smoke = "soot",
    offset = {x = 0.0, y = -0.7},
    jitter = 0.11,
    puff_scale = 0.70
  },
  ["stone-furnace"] = {
    smoke = "real-smoke-industrial",
    offset = {x = 0.0, y = -0.35},
    jitter = 0.14
  },
  ["steel-furnace"] = {
    smoke = "real-smoke-industrial",
    offset = {x = 0.0, y = -0.45},
    jitter = 0.15
  },
  ["burner-mining-drill"] = {
    smoke = "real-smoke-light",
    offset = {x = 0.0, y = -0.45},
    jitter = 0.22
  }
}

local VEHICLE_PROFILE = {
  ["locomotive"] = {
    smoke = "real-smoke-exhaust",
    jitter = 0.22,
    min_speed = 0.015
  },
  ["car"] = {
    smoke = "real-smoke-exhaust",
    jitter = 0.16,
    min_speed = 0.03
  },
  ["tank"] = {
    smoke = "soot",
    jitter = 0.12,
    min_speed = 0.02
  }
}

-- Trigger-created explosion entities. These only fire through
-- on_trigger_created_entity when an effect opts in with
-- trigger_created_entity = true, which is uncommon, so they are treated
-- as bonus coverage. Reliable rocket/explosion smoke is handled by the
-- on_rocket_launched and on_entity_died handlers below.
local EVENT_SMOKE = {
  ["explosion"] = {name = "real-smoke-blast", count = 4, radius = 0.8},
  ["big-explosion"] = {name = "real-smoke-blast", count = 9, radius = 1.5},
  ["massive-explosion"] = {name = "real-smoke-blast", count = 14, radius = 2.2},
  ["nuke-explosion"] = {name = "real-smoke-blast", count = 22, radius = 3.2},
  ["medium-explosion"] = {name = "real-smoke-industrial", count = 5, radius = 1.0}
}

-- Entity types that should never emit destruction smoke when they die
-- (foliage, decoratives, resources, and effect/smoke entities).
local DEATH_SKIP_TYPES = {
  ["tree"] = true,
  ["simple-entity"] = true,
  ["cliff"] = true,
  ["fish"] = true,
  ["resource"] = true,
  ["decorative"] = true,
  ["corpse"] = true,
  ["item-entity"] = true,
  ["particle-source"] = true,
  ["explosion"] = true,
  ["smoke"] = true,
  ["smoke-with-trigger"] = true,
  ["trivial-smoke"] = true,
  ["sticker"] = true,
  ["highlight-box"] = true,
  ["arrow"] = true,
  ["flying-text"] = true
}

local function ensure_storage()
  storage.real_smoke = storage.real_smoke or {}
  storage.real_smoke.spawned = storage.real_smoke.spawned or 0
  storage.real_smoke.cycles = storage.real_smoke.cycles or 0
end

local function setting(name)
  local value = settings.global[name]
  return value and value.value
end

local function rounded_tick_interval(value)
  local rounded = math.floor((value / 5) + 0.5) * 5
  if rounded < 10 then return 10 end
  return rounded
end

local function density_config()
  local density = DENSITY[setting("real-smoke-density") or "balanced"] or DENSITY.balanced
  local smoothness = SMOOTHNESS[setting("real-smoke-smoothness") or "smooth"] or SMOOTHNESS.smooth

  local black = BLACK_STRENGTH[setting("real-smoke-black-strength") or "realistic"] or BLACK_STRENGTH.realistic

  return {
    interval = rounded_tick_interval(density.interval * smoothness.interval_multiplier),
    machine_chance = math.min(1, density.machine_chance * smoothness.chance_multiplier * black.chance_multiplier),
    vehicle_chance = math.min(1, density.vehicle_chance * smoothness.chance_multiplier * black.chance_multiplier),
    puffs = density.puffs,
    max_per_player = math.floor(density.max_per_player * smoothness.max_multiplier + 0.5),
    jitter_multiplier = smoothness.jitter_multiplier,
    vehicle_trail = smoothness.vehicle_trail,
    event_multiplier = smoothness.event_multiplier,
    soot_smoke = black.soot,
    heavy_smoke = black.heavy,
    black_puff_multiplier = black.puff_multiplier
  }
end


local function copy_config(cfg)
  local out = {}
  for k, v in pairs(cfg) do out[k] = v end
  return out
end

local function clamp(value, min_value, max_value)
  if value < min_value then return min_value end
  if value > max_value then return max_value end
  return value
end

local function real_rain_weather(surface)
  if not setting("real-smoke-real-rain-integration") then return nil end
  if not (surface and surface.valid) then return nil end
  if not (remote and remote.interfaces and remote.interfaces["real-rain"]) then return nil end

  local iface = remote.interfaces["real-rain"]
  if iface["get_weather"] then
    local ok, weather = pcall(remote.call, "real-rain", "get_weather", surface.index)
    if ok and type(weather) == "table" then return weather end
  end

  if iface["is_raining"] then
    local ok, raining = pcall(remote.call, "real-rain", "is_raining", surface.index)
    if ok and raining then
      local stage = "rain"
      if iface["stage"] then
        local stage_ok, current_stage = pcall(remote.call, "real-rain", "stage", surface.index)
        if stage_ok and type(current_stage) == "string" then stage = current_stage end
      end
      return REAL_RAIN_STAGE_WEATHER[stage] or REAL_RAIN_STAGE_WEATHER.rain
    end
  end

  return nil
end

local function real_wind_data(surface)
  if not setting("real-smoke-real-wind-integration") then return nil end
  if not (surface and surface.valid) then return nil end
  if not (remote and remote.interfaces and remote.interfaces["real-wind"]) then return nil end
  if not remote.interfaces["real-wind"]["get_wind"] then return nil end

  local ok, wind = pcall(remote.call, "real-wind", "get_wind", surface.index)
  if ok and type(wind) == "table" then return wind end
  return nil
end

local EMPTY_WEATHER_CONTEXT = { weather = nil, wind = nil }
local WEATHER_CONTEXT_CACHE_TICK = nil
local WEATHER_CONTEXT_CACHE = {}

local function build_weather_context(surface)
  return {
    weather = real_rain_weather(surface),
    wind = real_wind_data(surface)
  }
end

local function weather_context(surface, tick)
  if not (surface and surface.valid) then
    return EMPTY_WEATHER_CONTEXT
  end

  tick = tick or game.tick
  if WEATHER_CONTEXT_CACHE_TICK ~= tick then
    WEATHER_CONTEXT_CACHE_TICK = tick
    WEATHER_CONTEXT_CACHE = {}
  end

  local surface_index = surface.index
  local cached = WEATHER_CONTEXT_CACHE[surface_index]
  if cached then
    return cached
  end

  local context = build_weather_context(surface)
  if not context.weather and not context.wind then
    context = EMPTY_WEATHER_CONTEXT
  end

  WEATHER_CONTEXT_CACHE[surface_index] = context
  return context
end

local function weather_adjusted_config(cfg, surface, tick)
  local context = weather_context(surface, tick)
  local weather = context.weather
  local wind = context.wind
  if not weather and not wind then return cfg end

  local adjusted = copy_config(cfg)
  local is_raining = weather and weather.is_raining
  local storm = clamp(tonumber(weather and weather.storm_factor) or tonumber(wind and wind.storm_factor) or 1, 0.5, 3.0)
  -- Real Wind is the authoritative wind source when both companion mods are active.
  -- Real Rain's stage-derived values remain a useful standalone fallback.
  local wind_bucket = (wind and wind.wind_bucket) or (weather and weather.wind_bucket) or "straight"
  local raw_wind_speed = tonumber(wind and wind.speed) or tonumber(weather and weather.wind_speed) or 0
  local wind_bonus = clamp(raw_wind_speed / 0.075, 0, 1.65)
  local gust_bonus = wind_bucket == "gust" and 0.65 or 0

  -- Rain washes the darkest smoke down a bit, while Real Wind / Real Rain
  -- gusts push wind-aware smoke harder. Each integration is optional, so this
  -- still works if only one of the weather mods is installed.
  if is_raining then
    adjusted.machine_chance = clamp(adjusted.machine_chance * (0.90 - 0.07 * storm), 0.25, 1)
    adjusted.vehicle_chance = clamp(adjusted.vehicle_chance * (0.96 - 0.03 * storm), 0.25, 1)
    adjusted.max_per_player = math.max(8, math.floor(adjusted.max_per_player * 0.92 + 0.5))
    adjusted.black_puff_multiplier = (adjusted.black_puff_multiplier or 1) * clamp(0.98 - 0.06 * storm, 0.72, 1)
  end

  if wind_bonus > 0.05 or gust_bonus > 0 then
    adjusted.jitter_multiplier = adjusted.jitter_multiplier * (1.0 + wind_bonus * 0.34 + gust_bonus + (is_raining and storm * 0.10 or 0))

    if (adjusted.vehicle_trail or 0) < 4 and (wind_bonus > 0.85 or wind_bucket == "gust") then
      adjusted.vehicle_trail = (adjusted.vehicle_trail or 0) + 1
    end
  elseif is_raining then
    adjusted.jitter_multiplier = adjusted.jitter_multiplier * (1.10 + 0.18 * storm)
  end

  return adjusted
end

local function rand_range(amount)
  return (math.random() * amount * 2) - amount
end

local function resolve_smoke_name(smoke_name, cfg)
  if smoke_name == "soot" then
    return cfg.soot_smoke or "real-smoke-soot"
  end
  if smoke_name == "heavy" then
    return cfg.heavy_smoke or "real-smoke-heavy"
  end
  return smoke_name
end

local function spawn_smoke(surface, smoke_name, position, jitter, count)
  if not (surface and surface.valid) or not smoke_name or not position then return 0 end

  local spawned = 0
  for _ = 1, count or 1 do
    local x = position.x + rand_range(jitter or 0)
    local y = position.y + rand_range(jitter or 0)

    -- 2.1-safe guard: a missing/renamed smoke prototype or invalid surface state
    -- should never hard-crash a save. If Factorio rejects the smoke spawn,
    -- skip that puff and keep the visual-only mod running.
    local ok = pcall(surface.create_trivial_smoke, {
      name = smoke_name,
      position = {x = x, y = y}
    })

    if ok then
      spawned = spawned + 1
    end
  end
  return spawned
end

local function entity_is_working(entity)
  if not (entity and entity.valid) then return false end

  -- Only emit smoke while the machine is actually working (burning fuel).
  -- entity.active is NOT a usable "on" signal: it stays true for any placed
  -- entity unless a script explicitly disables it, so an idle boiler with no
  -- demand still reads as active and would keep smoking. Gate strictly on the
  -- operating status so smoke stops the moment the machine stops burning.
  local ok_status, status = pcall(function() return entity.status end)
  if not ok_status or status == nil then return false end

  return status == defines.entity_status.working
end

local function vehicle_is_moving(entity, profile)
  if not (entity and entity.valid) then return false end

  local ok_speed, speed = pcall(function() return entity.speed end)
  if not ok_speed or not speed then return false end

  return math.abs(speed) >= (profile.min_speed or 0.02)
end

local function exhaust_position_and_vector(entity)
  local position = entity.position
  local speed = 0
  local orientation = nil

  local ok_speed, entity_speed = pcall(function() return entity.speed end)
  if ok_speed and entity_speed then speed = entity_speed end

  local ok_orientation, entity_orientation = pcall(function() return entity.orientation end)
  if ok_orientation and entity_orientation then orientation = entity_orientation end

  if not orientation then
    local ok_direction, direction = pcall(function() return entity.direction end)
    if ok_direction and direction then
      orientation = (direction / 16)
    end
  end

  if not orientation then
    return {x = position.x, y = position.y - 0.35}, {x = 0, y = -1}
  end

  local angle = orientation * math.pi * 2
  local sign = speed >= 0 and -1 or 1
  local back_x = math.sin(angle) * sign
  local back_y = -math.cos(angle) * sign

  return {
    x = position.x + back_x * 0.85,
    y = position.y + back_y * 0.85
  }, {x = back_x, y = back_y}
end

local function spawn_vehicle_smoke(entity, profile, cfg)
  local exhaust_pos, back = exhaust_position_and_vector(entity)
  local jitter = (profile.jitter or 0.15) * (cfg.jitter_multiplier or 1)
  local smoke_name = resolve_smoke_name(profile.smoke, cfg)
  local puff_count = math.max(1, math.floor((cfg.puffs or 1) * (cfg.black_puff_multiplier or 1) + 0.5))
  local spawned = spawn_smoke(entity.surface, smoke_name, exhaust_pos, jitter, puff_count)

  for i = 1, cfg.vehicle_trail or 0 do
    local trail_pos = {
      x = exhaust_pos.x + back.x * (i * 0.34),
      y = exhaust_pos.y + back.y * (i * 0.34)
    }
    spawned = spawned + spawn_smoke(entity.surface, smoke_name, trail_pos, jitter * 0.62, 1)
  end

  return spawned
end

local function entity_visit_key(entity)
  local unit_number = entity.unit_number
  if unit_number then return unit_number end
  local position = entity.position
  return entity.name .. "@" .. position.x .. "," .. position.y
end

local function is_first_visit(seen_entities, entity)
  local key = entity_visit_key(entity)
  if seen_entities[key] then return false end
  seen_entities[key] = true
  return true
end

local function scan_player_area(player, cfg, tick, seen_entities)
  if not (player and player.valid and player.connected and player.character) then return 0 end

  local surface = player.surface
  local radius = setting("real-smoke-scan-radius") or 96
  local pos = player.position
  local area = {{pos.x - radius, pos.y - radius}, {pos.x + radius, pos.y + radius}}
  local spawned = 0
  cfg = weather_adjusted_config(cfg, surface, tick)

  if setting("real-smoke-machines") then
    local machines = surface.find_entities_filtered({area = area, name = MACHINE_NAMES})

    for _, entity in pairs(machines) do
      if spawned >= cfg.max_per_player then break end
      local profile = MACHINE_PROFILE[entity.name]

      if profile and is_first_visit(seen_entities, entity) and entity_is_working(entity) and math.random() <= cfg.machine_chance then
        local emit_pos = {
          x = entity.position.x + (profile.offset.x or 0),
          y = entity.position.y + (profile.offset.y or 0)
        }
        local smoke_name = resolve_smoke_name(profile.smoke, cfg)
        local dark_multiplier = (profile.smoke == "soot" or profile.smoke == "heavy") and (cfg.black_puff_multiplier or 1) or 1
        local puff_count = math.max(1, math.floor((cfg.puffs or 1) * (profile.puff_scale or 1) * dark_multiplier + 0.5))
        spawned = spawned + spawn_smoke(surface, smoke_name, emit_pos, (profile.jitter or 0.15) * cfg.jitter_multiplier, puff_count)
      end
    end
  end

  if setting("real-smoke-vehicles") and spawned < cfg.max_per_player then
    local vehicles = surface.find_entities_filtered({area = area, name = VEHICLE_NAMES})

    for _, entity in pairs(vehicles) do
      if spawned >= cfg.max_per_player then break end
      local profile = VEHICLE_PROFILE[entity.name]

      if profile and is_first_visit(seen_entities, entity) and vehicle_is_moving(entity, profile) and math.random() <= cfg.vehicle_chance then
        spawned = spawned + spawn_vehicle_smoke(entity, profile, cfg)
      end
    end
  end

  return spawned
end

local function run_real_smoke(event)
  if not setting("real-smoke-enabled") then return end

  local cfg = density_config()
  if (event.tick % cfg.interval) ~= 0 then return end

  ensure_storage()

  local spawned_this_cycle = 0
  local seen_entities = {}
  for _, player in pairs(game.connected_players) do
    spawned_this_cycle = spawned_this_cycle + scan_player_area(player, cfg, event.tick, seen_entities)
  end

  storage.real_smoke.spawned = storage.real_smoke.spawned + spawned_this_cycle
  storage.real_smoke.cycles = storage.real_smoke.cycles + 1

  if setting("real-smoke-debug-stats") and spawned_this_cycle > 0 and (event.tick % 1800) == 0 then
    game.print({"real-smoke.debug", spawned_this_cycle, storage.real_smoke.spawned})
  end
end

local function on_trigger_created_entity(event)
  if not setting("real-smoke-enabled") or not setting("real-smoke-events") then return end
  if not event or not event.entity or not event.entity.valid then return end

  local spec = EVENT_SMOKE[event.entity.name]
  if not spec then return end

  local cfg = density_config()
  local count = math.max(1, math.floor(spec.count * (cfg.event_multiplier or 1) + 0.5))
  spawn_smoke(event.entity.surface, spec.name, event.entity.position, spec.radius, count)
end

local function near_any_player(surface, position, radius)
  local r2 = radius * radius
  for _, player in pairs(game.connected_players) do
    if player.valid and player.surface == surface then
      local p = player.position
      local dx = p.x - position.x
      local dy = p.y - position.y
      if (dx * dx + dy * dy) <= r2 then
        return true
      end
    end
  end
  return false
end

-- Picks a smoke profile for a destroyed entity based on its size, so a
-- worm or building produces a real blast while small wreckage stays light.
local function death_smoke_spec(entity, cfg)
  local max_health = 0
  local ok_proto, proto = pcall(function() return entity.prototype end)
  if ok_proto and proto then
    local ok_hp, hp = pcall(function() return proto.max_health end)
    if ok_hp and hp then max_health = hp end
  end

  if max_health < 40 then return nil end

  if max_health >= 600 then
    return {name = "real-smoke-blast", count = 9, radius = 1.4}
  elseif max_health >= 200 then
    return {name = "real-smoke-blast", count = 5, radius = 1.0}
  end

  return {name = resolve_smoke_name("soot", cfg), count = 3, radius = 0.8}
end

local function on_rocket_launched(event)
  if not setting("real-smoke-enabled") or not setting("real-smoke-events") then return end

  local silo = event.rocket_silo
  local rocket = event.rocket
  local source = (silo and silo.valid and silo) or (rocket and rocket.valid and rocket)
  if not source then return end

  ensure_storage()
  local cfg = density_config()
  local count = math.max(1, math.floor(16 * (cfg.event_multiplier or 1) + 0.5))
  local spawned = spawn_smoke(source.surface, "real-smoke-blast", source.position, 1.8, count)
  storage.real_smoke.spawned = storage.real_smoke.spawned + spawned
end

local function on_entity_died(event)
  if not setting("real-smoke-enabled") or not setting("real-smoke-events") then return end

  local entity = event.entity
  if not (entity and entity.valid) then return end

  local etype
  local ok_type, t = pcall(function() return entity.type end)
  if ok_type then etype = t end
  if not etype or DEATH_SKIP_TYPES[etype] then return end

  local surface = entity.surface
  local position = entity.position
  local radius = setting("real-smoke-scan-radius") or 96
  if not near_any_player(surface, position, radius * 1.5) then return end

  -- Keep large enemy waves from flooding the map with smoke.
  if etype == "unit" and math.random() > 0.18 then return end

  local cfg = density_config()
  local spec = death_smoke_spec(entity, cfg)
  if not spec then return end

  ensure_storage()
  local count = math.max(1, math.floor(spec.count * (cfg.event_multiplier or 1) + 0.5))
  local spawned = spawn_smoke(surface, spec.name, position, spec.radius, count)
  storage.real_smoke.spawned = storage.real_smoke.spawned + spawned
end

local function safe_on_event(event_id, handler)
  if event_id then
    script.on_event(event_id, handler)
  end
end

script.on_init(function()
  ensure_storage()
end)

script.on_configuration_changed(function()
  ensure_storage()
end)

script.on_nth_tick(5, run_real_smoke)
safe_on_event(defines.events.on_trigger_created_entity, on_trigger_created_entity)
safe_on_event(defines.events.on_rocket_launched, on_rocket_launched)
safe_on_event(defines.events.on_entity_died, on_entity_died)

commands.add_command("real-smoke", {"real-smoke.command-help"}, function(command)
  ensure_storage()
  local player = command.player_index and game.get_player(command.player_index)
  local message = {"real-smoke.command-stats", storage.real_smoke.cycles, storage.real_smoke.spawned}

  if player then
    player.print(message)
  else
    game.print(message)
  end
end)
