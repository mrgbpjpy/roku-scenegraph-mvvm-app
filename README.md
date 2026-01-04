# ESPN-Style Roku SceneGraph Application

## Overview
This project is a production-style ESPN-inspired Roku TV application built using **Roku SceneGraph** and **BrightScript**.  
It demonstrates real-world TV navigation patterns, focus management, modal handling, video playback, and deterministic input contracts suitable for large-screen, remote-driven UIs.

The app was developed incrementally from **early November through late December**, with a strong emphasis on correctness, debuggability, and portfolio readiness for Roku / streaming-platform engineering roles.

In addition to UI architecture, this project also implements a **real streaming backend** using **Cloudflare R2 object storage** and a **custom domain** to serve video assets over the internet—mirroring how production OTT apps deliver media at scale.

---

## Key Features
- Persistent top navigation bar (NavBar) with ESPN-style underline cursor
- Featured screen with autoplay background video
- Home, Live, Sports, and Developer Info screens
- Detail modal with safe focus isolation and video playback
- Deterministic navigation using action contracts instead of focus guessing
- Robust BACK-key handling across all screens
- Zero focus traps or accidental app exits
- **Cloud-hosted video streaming via custom domain (Cloudflare R2)**

---

## Streaming & Media Delivery Architecture

### Cloudflare R2 Video Hosting
All video content used by the application is hosted externally using **Cloudflare R2 object storage**, making this a true **network-streamed Roku application**, not a local-asset demo.

**Key details:**
- Videos are stored in **Cloudflare R2**
- A **custom domain** was purchased and configured
- A **CNAME record** points the domain to the R2 bucket endpoint
- Videos are streamed over HTTPS directly into the Roku app
- No local packaging of video assets is required

This mirrors real-world OTT architectures where:
- Video assets are CDN-backed
- Applications consume remote streams
- UI and media delivery are cleanly decoupled

This design allows:
- Easy content updates without app redeploys
- Scalable media delivery
- Realistic production constraints for Roku engineering

---

## Architecture
- **MainScene**
  - Owns screen visibility, modal state, and playback state
  - Acts as the single navigation authority
- **NavBar**
  - Stateless UI component
  - Emits navigation intent via action contracts
- **Screens**
  - Own their internal navigation
  - Yield focus cleanly back to NavBar
- **DetailScreen**
  - Modal-only focus ownership
  - Clean lifecycle enter / exit behavior
- **Streaming Layer**
  - External Cloudflare R2-hosted video assets
  - Accessed via custom domain URLs

---

## Navigation Model
Instead of relying on implicit focus behavior, the app uses an explicit **navigation contract**:

- `selectedId` → *what* tab is targeted
- `navAction` → *why* navigation occurred (`select` vs `enter`)
- `navPulse` → guarantees delivery of repeated actions

This ensures navigation works even when:
- The same tab is re-selected
- Focus visually moves but intent does not
- Roku swallows repeated field assignments

---

## Development Timeline

### November
- Initial SceneGraph layout
- Basic NavBar and screen switching
- Early focus bugs identified

### Early December
- Added Featured autoplay video
- Introduced Detail modal
- Integrated external video streaming via Cloudflare R2
- Encountered non-deterministic focus issues

### Mid December
- Deep debugging with Roku debugger logs
- Discovered focus ≠ intent problem
- Multiple failed approaches using observers and `.hasMethod()`

### Late December
- Introduced **navPulse**
- Refactored navigation to action-based contract
- Stabilized BACK behavior across all screens
- Finalized streaming architecture and documentation

---

## Lessons Learned

### 1. Focus Does NOT Equal Intent on Roku
**Problem:**  
Changing focus visually does not mean the system understands user intent.

**Solution:**  
Explicitly model intent using action fields (`select`, `enter`) instead of relying on focus state.

---

### 2. Re-selecting the Same Value Does Not Fire Observers
**Problem:**  
Setting `selectedId = "HOME"` repeatedly does nothing if the value hasn’t changed.

**Solution:**  
Introduce a monotonically increasing `navPulse` field to guarantee delivery of repeated actions.

---

### 3. `.hasMethod()` Is Fragile in Production
**Problem:**  
Runtime checks caused inconsistent behavior and crashes.

**Solution:**  
Adopt a **screen contract**: every NavBar-driven screen implements `enterMenu()` consistently.

---

### 4. BACK Must Be Handled Per Screen
**Problem:**  
Letting BACK bubble caused accidental app exits.

**Solution:**  
Each screen intercepts BACK and explicitly returns focus to NavBar.  
Only HOME button exits the app.

---

### 5. NavBar Must Be Stateless
**Problem:**  
Letting NavBar manage app state caused race conditions.

**Solution:**  
NavBar only emits intent. MainScene decides everything.

---

### 6. Determinism Beats Cleverness
**Problem:**  
Frame-based tricks and focus hacks were unreliable.

**Solution:**  
Use deterministic signals (`navPulse`) over timing assumptions.

---

## Why This Matters
This project demonstrates:
- Platform-level debugging skill
- Understanding of TV UX constraints
- Production-safe SceneGraph architecture
- Real-world video streaming via Cloudflare R2
- CDN-backed media delivery using custom domains
- Persistence through non-obvious system behavior

---

## Author
**Erick Esquilin**  
Software Engineer – Streaming UI / Systems  
Portfolio-ready Roku SceneGraph application
