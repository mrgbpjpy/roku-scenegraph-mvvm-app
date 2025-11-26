# Roku ESPN-Style Prototype App

### Built with Roku SceneGraph + BrightScript

This is a Roku client prototype demonstrating:

-   **SceneGraph UI architecture**
-   **MVVM-style ViewModel separation**
-   **Dynamic content loading**
-   **Home-screen style browsing using RowList**
-   **Custom component structure**
-   **Splash → MainScene → HomeScreen flow**

Built as part of preparation for the\
**Lead Roku Software Engineer -- ESPN / Disney Streaming** role.

------------------------------------------------------------------------

## 📺 Features Implemented

### ✔ Splash Screen

Loads automatically from the Roku manifest.

### ✔ MainScene (Shell Application Scene)

-   Root entry point for the UI\
-   Delegates control to HomeScreen\
-   Handles global "Back" behavior

### ✔ HomeScreen (Browse UI)

-   Title header\
-   Multi-row content carousels\
-   RowList with item navigation\
-   MVVM binding to HomeViewModel\
-   Remote controls: up/down/left/right/OK

### ✔ HomeViewModel (Task Component)

-   Loads JSON (`data/home_content.json`)\
-   Builds a ContentNode tree\
-   Exposes rows + items to RowList\
-   Demonstrates Roku MVVM pattern

------------------------------------------------------------------------

## 📂 Project Structure

    RokuESPNApp/
      manifest
      source/
      components/
        MainScene.xml
        MainScene.brs
        screens/
          HomeScreen.xml
          HomeScreen.brs
        viewmodels/
          HomeViewModel.xml
          HomeViewModel.brs
      data/
        home_content.json
      images/
        icon_focus_hd.png
        icon_side_hd.png
        splash_hd.png

------------------------------------------------------------------------

## 🚀 Running the App on a Roku Device

1.  Enable Roku Developer Mode\
2.  ZIP **contents** of project root (not the folder itself)\
3.  Upload ZIP via Dev Installer:\
    `http://<roku-ip>`\
4.  App launches immediately

------------------------------------------------------------------------

## 🎯 Next Steps (Future Enhancements)

-   Add DetailScreen
-   Add VideoPlayerScreen\
-   Add animations\
-   Add analytics\
-   Add CMS-driven content\
-   Add build pipeline (gulp/Node)

------------------------------------------------------------------------

## 🔗 License

MIT License.
