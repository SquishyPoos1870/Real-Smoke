# Real Smoke

Grounded industrial smoke for Factorio 2.1. Real Smoke makes factories feel dirtier and more alive without burying the map in grey fog. Boilers churn, furnaces breathe, vehicles trail exhaust, and rockets and explosions throw up short smoke clouds.

The mod is visual only: it does not change recipes, pollution, machine performance, or game balance.

## Features

- Working boilers, stone furnaces, steel furnaces, and burner mining drills emit smoke.
- Idle, unfed, and paused machines stay clean.
- Moving locomotives, cars, and tanks produce exhaust trails.
- Rocket launches and destructive entity deaths create short blast-smoke bursts.
- Subtle, Balanced, Heavy, and Cinematic density presets.
- Performance, Smooth, 120 FPS Style, and Ultra Real cadence presets.
- Soft, Realistic, and Strong soot colour presets.
- Adjustable near-player scan radius and independent effect toggles.

## Recommended settings

For a natural look:

- Density: Balanced
- Smoothness: Ultra Real
- Black smoke strength: Realistic

Use Subtle density with Performance smoothness for very large factories or busy multiplayer servers. Use Cinematic density for screenshots and a heavier industrial atmosphere.

The 120 FPS Style and Ultra Real options are visual cadence presets. Factorio still runs at its normal simulation rate.

## Optional weather integration

Real Smoke works on its own. When Real Rain is installed, drizzle through monsoon stages progressively alter smoke density and drift. When Real Wind is installed, current wind speed and gusts add sideways movement and exhaust-trail variation.

Both integrations can be disabled independently in runtime settings.

## Performance

- Machine and vehicle scans only run near connected players.
- Emitters inside overlapping multiplayer scan areas are processed once per cycle.
- Explosion smoke is distance-gated, and small enemy deaths are sampled to prevent battle spam.
- Weather data is cached once per surface and tick.

Lower the scan radius or choose lighter presets if a very large save needs more UPS headroom.

## Command

```text
/real-smoke
```

Displays the number of completed smoke cycles and successfully spawned puffs.

## Compatibility

Built for Factorio 2.1 and Space Age saves. Runtime smoke creation and optional integrations are guarded so unavailable prototypes or companion interfaces do not crash the save.

Safe to add to or remove from an existing save.

## Licence

GNU General Public License v3.0. See the included `LICENSE` file.
