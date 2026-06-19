# Real Smoke

**Real Smoke** adds grounded, industrial smoke effects to Factorio 2.0.

The mod is designed to make factories feel dirtier and more alive without turning the whole map into grey fog. Smoke rises, drifts, expands, and fades using lightweight trivial smoke effects.

## Features

- Dark boiler smoke
- Furnace smoke
- Burner mining drill smoke
- Locomotive exhaust
- Car and tank exhaust
- Rocket and explosion smoke bursts
- Runtime smoke density setting:
  - Subtle
  - Balanced
  - Heavy
  - Cinematic
- Runtime smoke smoothness setting:
  - Performance
  - Smooth
  - 120 FPS Style
  - Ultra Real
- Smoother exhaust trails for vehicles and locomotives
- Black smoke strength setting: Soft / Realistic / Strong
- UPS-conscious near-player scanning
- Adjustable scan radius
- Visual-only; does not change recipes, entities, pollution, or balance

## Recommended Setting

Use **Balanced** density with **Ultra Real** smoothness and **Realistic** black smoke strength for the best real-life look.

Use **120 FPS Style** smoothness if you want smoke to look more fluid. Factorio still simulates at its normal tick rate, so this is a visual smoothness preset rather than true 120 UPS logic.

Use **Cinematic** density for screenshots or a stronger industrial look.

Use **Subtle** density with **Performance** smoothness on very large factories or multiplayer servers.

## Command

`/real-smoke`

Shows simple runtime smoke stats.

## Compatibility

Built for Factorio 2.0 and should work with Space Age saves because it only adds visual smoke effects to existing entities/events.

## Author

Squishy1870


## Optional Weather/Wind Integration

Real Smoke can read Real Rain and Real Wind when they are installed. Rain slightly thins heavy smoke, storms make smoke drift harder, and Real Wind gusts add more natural side movement and exhaust-trail variation. Each integration is optional and can be disabled in runtime settings.

## License

GNU General Public License v3.0. See `LICENSE` for the full license text.
