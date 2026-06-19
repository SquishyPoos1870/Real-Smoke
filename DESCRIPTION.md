# Real Smoke

**Grounded, industrial smoke for Factorio 2.0.** Real Smoke makes your factory feel dirtier and more alive — boilers churn, furnaces breathe, vehicles trail exhaust, and rockets and explosions kick up real smoke — without burying the map in grey fog. Smoke rises, drifts, expands, and fades using lightweight trivial-smoke effects, and it is **purely visual**: no recipes, entities, pollution, or balance are touched.

Everything is tunable at runtime, and the whole system is built to stay UPS-friendly by only working near connected players.

---

## What it does

- **Machine smoke** — boilers, stone furnaces, steel furnaces, and burner mining drills emit smoke **only while they are actually working** (burning fuel). An idle, unfed, or paused machine stays clean.
- **Vehicle exhaust** — locomotives, cars, and tanks trail exhaust smoke while moving, with optional smoother multi-puff trails.
- **Rocket & explosion smoke** — rocket launches throw up a smoke burst, and destructive entity deaths (worms, spawners, turrets, buildings, large enemies) kick up blast smoke scaled to the size of what blew up.
- **Soot-style colouring** — smoke leans toward soft grey/soot instead of pure black, so it reads as industrial grime rather than a giant dark wall.

---

## Settings (all runtime, change them anytime)

- **Enable Real Smoke** — master switch for every effect.
- **Smoke density** — how much smoke appears near each player:
  - *Subtle* — very light; best for huge factories or weak servers.
  - *Balanced* — recommended default. Visible but not messy.
  - *Heavy* — thicker smoke for a stronger industrial feel.
  - *Cinematic* — maximum smoke for screenshots and high-end PCs.
- **Smoke smoothness** — how often smaller puffs are emitted:
  - *Performance* — lowest runtime cost, smoke emits less often.
  - *Smooth* — recommended; a natural cadence without being heavy.
  - *120 FPS Style* — smaller, more frequent puffs and softer trails (uses more UPS).
  - *Ultra Real* — smoothest preset, lighter layered smoke with tighter jitter.
- **Black smoke strength** — how dark soot smoke appears: *Soft / Realistic / Strong*.
- **Smoke scan radius** — how far around each player Real Smoke looks for active machines and vehicles (32–192, default 96). Lower is better for UPS.
- **Machine smoke / Vehicle smoke / Rocket and explosion smoke** — toggle each effect family independently.
- **Debug smoke stats** — prints periodic spawn counts for testing.

> **Note on the smoothness presets:** *120 FPS Style* and *Ultra Real* are **visual** smoothness presets. Factorio still simulates at its normal tick rate, so these change how fluid the smoke *looks*, not how often the game logic runs.

---

## Recommended setup

For the most true-to-life look:

- **Density:** Balanced
- **Smoothness:** Ultra Real
- **Black smoke strength:** Realistic

Other combinations:

- Want more fluid smoke? Use **120 FPS Style** smoothness.
- Taking screenshots or want a heavier industrial mood? Use **Cinematic** density.
- On a massive factory or a busy multiplayer server? Use **Subtle** density with **Performance** smoothness.
- Dark smoke still feels too heavy? Drop **Black smoke strength** to **Soft**.

---

## Performance

Real Smoke is built to be UPS-conscious:

- It only scans for active machines and vehicles **near connected players**, within your configured scan radius.
- Explosion/death smoke is also near-player gated, and enemy (unit) deaths only smoke occasionally, so a big biter wave will not flood the map with smoke.
- Lower the **scan radius** and use **Performance** smoothness + **Subtle** density if you need to claw back UPS on a large save.
- Optional Real Rain / Real Wind data is cached per surface/tick before smoke is adjusted, so weather integration stays lightweight on busy saves.

---

## Command

```
/real-smoke
```

Prints simple runtime smoke stats (cycles run and total puffs spawned).

---

## Compatibility

Built for **Factorio 2.0** and should work with **Space Age** saves — it only adds visual smoke to existing entities and events, and changes nothing about game balance, recipes, or pollution. Safe to add to or remove from an existing save.

---

## Author

**Squishy1870**

Found a bug or have a tuning suggestion? Feedback is welcome — especially around how often explosion/death smoke fires, which is the main thing worth eyeballing in your own game.


## Optional Real Rain / Real Wind integration

Real Smoke stays fully standalone, but when **Real Rain** or **Real Wind** are installed it can read their active weather state. Rain and storms slightly thin the darkest smoke, while stronger wind and gusts add more side movement and exhaust-trail variation. Disable the integration settings at runtime if you want Real Smoke to ignore weather or wind.

---

## License

GNU General Public License v3.0. See the included `LICENSE` file for the full license text.
