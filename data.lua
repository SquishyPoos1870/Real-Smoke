---------------------------------------------------------------------------------------------------
Version: 1.0.3
Date: 2026-06-15
  Features:
    - Added Ultra Real smoothness mode for the smoothest high-FPS-style smoke look.
    - Added Black smoke strength setting with Soft, Realistic, and Strong options.
  Changes:
    - Rebalanced smoke colours toward softer grey/soot instead of pure black.
    - Reduced large dark blob formation with smaller scales, shorter duration, and lower opacity.
    - Improved smoke drift feel with softer wind movement and slower animation cycling.
    - Tuned vehicle and tank exhaust to look smoother and less chunky.

---------------------------------------------------------------------------------------------------
Version: 1.0.2
Date: 2026-06-15
  Changes:
    - Toned down overly dense black smoke for a more realistic look.
    - Boilers now use a soot-style smoke profile instead of the older dense heavy-black profile.
    - Reduced boiler smoke jitter and per-emission puff count so smoke no longer forms a giant dark wall as easily.
    - Reduced Heavy and Cinematic density caps slightly to keep darker smoke readable around machines.
    - Tanks now use soot-style exhaust to better match the rest of the mod.

---------------------------------------------------------------------------------------------------
Version: 1.0.1
Date: 2026-06-15
  Features:
    - Added a Smoke smoothness setting with Performance, Smooth, and 120 FPS Style options.
    - Added smoother vehicle and locomotive exhaust trails.
  Changes:
    - Smoke emission can now run in smaller, more frequent visual pulses while keeping near-player caps.
    - Smoke animation now cycles for the configured duration instead of ending early when the copied base animation finishes.
    - Updated README and locale text for the new smoothness setting.

---------------------------------------------------------------------------------------------------
Version: 1.0.0
Date: 2026-06-15
  Features:
    - Initial release of Real Smoke.
    - Adds grounded industrial smoke to boilers, stone furnaces, steel furnaces, burner mining drills, locomotives, cars, tanks, rockets, and explosions.
    - Adds runtime settings for density, scan radius, machine smoke, vehicle smoke, event smoke, and debug stats.
    - Uses lightweight trivial smoke prototypes with wind movement, expansion, and fade-out.
    - Designed as a visual-only, UPS-conscious mod.
