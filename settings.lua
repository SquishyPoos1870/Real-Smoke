data:extend({
  {
    type = "bool-setting",
    name = "real-smoke-enabled",
    setting_type = "runtime-global",
    default_value = true,
    order = "a"
  },
  {
    type = "bool-setting",
    name = "real-smoke-real-rain-integration",
    setting_type = "runtime-global",
    default_value = true,
    order = "aa"
  },
  {
    type = "bool-setting",
    name = "real-smoke-real-wind-integration",
    setting_type = "runtime-global",
    default_value = true,
    order = "ab"
  },
  {
    type = "string-setting",
    name = "real-smoke-density",
    setting_type = "runtime-global",
    default_value = "balanced",
    allowed_values = {"subtle", "balanced", "heavy", "cinematic"},
    order = "b"
  },
  {
    type = "string-setting",
    name = "real-smoke-smoothness",
    setting_type = "runtime-global",
    default_value = "smooth",
    allowed_values = {"performance", "smooth", "120-style", "ultra-real"},
    order = "bb"
  },
  {
    type = "string-setting",
    name = "real-smoke-black-strength",
    setting_type = "runtime-global",
    default_value = "realistic",
    allowed_values = {"soft", "realistic", "strong"},
    order = "bc"
  },
  {
    type = "int-setting",
    name = "real-smoke-scan-radius",
    setting_type = "runtime-global",
    default_value = 96,
    minimum_value = 32,
    maximum_value = 192,
    order = "c"
  },
  {
    type = "bool-setting",
    name = "real-smoke-machines",
    setting_type = "runtime-global",
    default_value = true,
    order = "d"
  },
  {
    type = "bool-setting",
    name = "real-smoke-vehicles",
    setting_type = "runtime-global",
    default_value = true,
    order = "e"
  },
  {
    type = "bool-setting",
    name = "real-smoke-events",
    setting_type = "runtime-global",
    default_value = true,
    order = "f"
  },
  {
    type = "bool-setting",
    name = "real-smoke-debug-stats",
    setting_type = "runtime-global",
    default_value = false,
    order = "z"
  }
})
