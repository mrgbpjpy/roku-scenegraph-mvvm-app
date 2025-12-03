# 📺 Roku ESPN-Style Prototype

A fully custom Roku SceneGraph application that replicates an ESPN-style streaming UI:  
top navigation bar, multi-screen layout, hero banners, dynamic cursor control, and  
native Roku remote navigation.

This project demonstrates Roku engineering patterns including component-based  
architecture, focus delegation, custom highlight systems, ContentNode usage,  
and performance-safe SceneGraph rendering.


---

## 🚀 Features Implemented

### ✅ 1. Top Navigation Bar (NavBar)
- ESPN-style icon strip
- Smooth LEFT/RIGHT remote navigation
- Clear visual focus indicator
- Controls which screen is displayed (Home, Live, Sports, Search, Profile, Settings)

### ✅ 2. Multi-Screen Architecture
Each screen is a separate SceneGraph component:

- HomeScreen
- LiveScreen
- SportsScreen
- SearchScreen
- ProfileScreen
- SettingsScreen

### ✅ 3. LiveScreen Custom Highlight Cursor (Latest Update)
- Cursor moves without list shifting
- Cursor visible only when LiveScreen has focus
- Automatically hides when NavBar regains focus
- Item text color highlights correctly

---

## 🧱 Project Structure

/components  
/images  
/source  
manifest

---

## 🔧 Installation

1. Zip project:
zip -r roku-espn-prototype.zip *

2. Install via Roku Development Installer

---

## 📌 Roadmap

- Hero banner animations
- Content rows (RowList/MarkupList)
- Details + Video screens
- HLS playback integration
- Focus animations
- JSON content simulation
- Splash animations

---

## 👤 Author

Erick Esquilin  
Full-stack Developer & Roku Engineer  
