
# ESPN-Style Roku SceneGraph App (MVVM Architecture)

## Overview

This project is a Roku SceneGraph application inspired by ESPN-style navigation and UX patterns.
It implements a persistent NavBar, multiple content screens (Featured, Home, Live, Sports, Developer),
background video playback, and deterministic focus management using BrightScript.

---

## Key Architecture Decisions

- Persistent NavBar always present
- Screens manage their own focus
- MainScene coordinates state, not focus
- BACK handled at screen level
- HOME key never intercepted

---

## Lessons Learned

### 1. `observeField("selectedId")` Is Not Reliable

Observers only fire on value change. Re-selecting the same tab does nothing.

**Fix:** Introduced `navPulse` to signal intent.

---

### 2. Focus ≠ Intent

A screen may already be focused, but the user still intends to re-enter it.

**Fix:** Separate intent (`navPulse`) from focus state.

---

### 3. `hasMethod()` Is Not a Focus Strategy

Runtime reflection caused inconsistent behavior.

**Fix:** All screens safely expose `enterMenu()`.

---

### 4. BACK Must Be Screen-Local

Unconsumed BACK exits the app.

**Fix:** Every screen consumes BACK and returns focus to NavBar.

---

## Final Solution: `navPulse`

```brightscript
m.top.navPulse = m.top.navPulse + 1
```

Observed in MainScene to reliably handle:
- OK
- DOWN
- Re-entry of same tab

---

## Result

✔ Stable navigation  
✔ Deterministic focus  
✔ No accidental exits  
✔ Production-grade UX  

---

## Author

Erick Esquilin
