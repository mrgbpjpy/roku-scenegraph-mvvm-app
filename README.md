# 📺 Roku ESPN-Style Prototype (Advanced Version)

A fully engineered Roku SceneGraph application that recreates an **ESPN-style streaming experience**, including:

- Custom ESPN-like top navigation bar  
- Multi-screen architecture (Feature, Home, Live, Sports, Settings)  
- Auto-playing intro splash screen with fade-out  
- Auto-playing FeatureScreen promo (plays once, then returns to Home)  
- Full modal **DetailScreen** system  
- Clean SceneGraph communication patterns  
- Roku-safe focus, navigation, and screen-stack control  

This project follows **real production Roku engineering standards**, demonstrating best practices in:

- Component-based UI architecture  
- Logical focus management  
- Modal overlay control  
- Node → Scene → Modal event communication  
- Performance-safe rendering techniques  

---

# 🚀 Current Features (Fully Operational)

## ✅ **1. ESPN-Style Navigation Bar**

A custom-built NavBar that supports:

- Smooth left/right navigation  
- Centered underline highlight  
- Logical focus management  
- Emits `selectedId` so MainScene can switch screens  
- Receives initial focus after the intro splash finishes  

### 🔍 Highlight Centering Logic

```brightscript
rect = currentTab.boundingRect()
underlineWidth = m.focusUnderline.width
groupPos = m.menuGroup.translation

x = groupPos[0] + rect.x + (rect.width - underlineWidth) / 2
y = groupPos[1] + rect.y + rect.height + 6
```

Works on every label regardless of size.

---

## ✅ **2. Multi-Screen Architecture**

Tabs load the following screens dynamically:

```
FeatureScreen
HomeScreen
LiveScreen
SportsScreen
SettingsScreen
```

Each screen is isolated and safe to load/unload:

```brightscript
screen = CreateObject("roSGNode", "HomeScreen")
ShowScreenInLayer(screen, m.screenLayer)
```

Only one active screen is shown at a time.

---

## 🎬 **3. Intro Splash Video (Auto-play + Fade-Out)**

- Plays automatically on app launch  
- Runs at the top UI layer  
- Fades out smoothly  
- UI becomes interactive afterward  

### Animation logic (MainScene):

```xml
<FloatFieldInterpolator
    fieldToInterp="introLayer.opacity"
    key="[0.0, 1.0]"
    keyValue="[1.0, 0.0]"
/>
```

Clean fade transition into the app.

---

## 🎥 **4. FeatureScreen Auto-Playing Promo Video**

- Auto-plays promo video when Feature tab is selected  
- Does **not loop**  
- When the video finishes, the app automatically:

  ✔ switches NavBar to **Home**  
  ✔ transfers focus to NavBar  

- WATCH NOW button opens the DetailScreen modal  

True ESPN-style behavior.

---

## 🗂 **5. DetailScreen Modal (Fully Functional)**

Pressing **OK** on any poster or featured item opens a modal overlay.

Features:

- Dynamic title and metadata  
- Play / info / action buttons  
- Clean closing behavior  
- Proper focus restoration  

### Data flow:

**Screen → MainScene**

```brightscript
scene.callFunc("ShowDetail", data)
```

**MainScene → DetailScreen**

```brightscript
m.detailScreen.itemData = data
m.detailLayer.visible = true
```

**DetailScreen → MainScene**

```brightscript
scene.callFunc("HideDetail")
```

---

# 🧠 SceneGraph Architecture Summary

| Component | Responsibilities |
|----------|------------------|
| **IntroVideoScreen** | App intro animation + fade-out |
| **FeatureScreen** | Auto-play promo + watch button |
| **NavBar** | Tab navigation + focus underline |
| **MainScene** | Central router, modal owner, screen loader |
| **HomeScreen / Live / Sports / Settings** | Independent content screens |
| **DetailScreen** | Overlay modal |
| **ScreenStackLogic** | Efficient screen loading/unloading |

This structure mirrors **real Roku production apps** like Disney+, ESPN, NFL, and Hulu.

---

# 🧱 Project Structure

```
components/
    NavBar.xml / .brs
    FeatureScreen.xml / .brs
    HomeScreen.xml / .brs
    LiveScreen.xml / .brs
    SportsScreen.xml / .brs
    SettingsScreen.xml / .brs
    DetailScreen.xml / .brs
    IntroVideoScreen.xml / .brs
    MainScene.xml / .brs
    UILogic/
        ScreenStackLogic.brs

source/
    main.brs
   

videos/
images/
manifest
```

---

# 🔧 Installation (Side-Loading onto Roku)

### 1️⃣ Zip your project
```bash
zip -r espn-prototype.zip *
```

### 2️⃣ Open the Roku Developer Installer
```
http://<ROKU_IP>
```

### 3️⃣ Upload ZIP → Install Channel

### 4️⃣ View Logs (Remote in Terminal)
```bash
telnet <ROKU_IP> 8085
```
---
# 🎬 Roku Video Codec Compatibility Guide (Add-On for README.md)

Some Roku TV models use different hardware decoders or stricter firmware rules, which means **MP4 videos may play on one Roku device but not another** unless they are encoded using Roku’s universal compatibility profile.

Roku recommends using **H.264 / AVC, High Profile, Level 4.0**, with 8-bit video and AAC audio.

---

## ✔ Recommended Video Settings (Universal Roku Compatibility)

```
Codec:        H.264 / AVC
Profile:      High
Level:        4.0 (or 4.1)
Pixel Format: yuv420p (8-bit only)
Bitrate:      6–12 Mbps
Audio:        AAC-LC, Stereo, 48 kHz
Container:    MP4
```

Some export tools (including Adobe Premiere Pro) may still output variations that not all Roku TVs support, such as:

- H.264 Level **5.0 or higher**
- **10-bit video** instead of 8-bit
- **Too many reference frames**
- Variable frame rate (VFR)
- Non-standard pixel formats

These differences may cause videos to **fail playback** on certain Roku models even though they work on others.

---

## ✔ Guaranteed Fix: Post-Export Transcoding (FFmpeg)

To ensure playback across **all Roku TVs**, use FFmpeg to force Roku-safe parameters:

```bash
ffmpeg -i input.mp4   -c:v libx264   -profile:v high   -level 4.0   -pix_fmt yuv420p   -x264-params ref=3   -b:v 8000k   -maxrate 9000k   -bufsize 12000k   -c:a aac -b:a 128k   -movflags +faststart   output_roku_safe.mp4
```

This ensures:
- 8-bit video  
- yuv420 pixel format  
- Reference frames set to 3  
- Safe H.264 Level 4.0  
- Universal Roku compatibility (2014–2025)

---

## ✔ Why This Matters for Reviewers

If a reviewer or hiring manager sideloads your Roku app and the videos **do not play** on their specific Roku TV, this is almost always due to **model-specific codec support differences**, not the SceneGraph project itself.

The UI, navigation logic, screen architecture, and component interactions work identically across Roku OS versions.

---

## 📎 File Purpose

This `readme_codec_addon.md` is designed to be merged into your existing README to document Roku video compatibility.

---

# 🛣 Roadmap (Planned Enhancements)

### 🎥 **Full Video Player Screen**
- HLS playback  
- Scrub bar  
- Thumbnails  
- Pause/Play UI  
- Auto-play from DetailScreen  

### 📡 **Live Content API**
- Sports feed ingestion  
- Dynamic category rows  
- Weekly matchup schedule builder  

### ✨ **Advanced UI / UX**
- RowList + markupGrid carousels  
- Hero banners  
- Animated poster hover states  
- Spring physics underline animation  

### 💰 **Advertising Support**
- Pre-roll video ads (RAF)  
- VAST / VMAP loaders  
- Failover logic + metrics tracking  

---

# 👤 **Author — Erick Esquilin**

Full-Stack Developer | Roku Engineer | M.S. in Computer Science  

Technologies: Roku SceneGraph, BrightScript, React, .NET, Azure, Power Platform, FFmpeg, HLS Streaming.

This project demonstrates skills aligned with **professional Roku engineering roles** at ESPN, Disney+, Hulu, NFL, Warner Bros Discovery, Paramount+, and more.

If you want to extend this prototype into a full production-ready Roku app, I can help you implement:

- End-to-end video playback pipeline  
- Live content feeds  
- RowLists + dynamic categories  
- Roku UX polish  
