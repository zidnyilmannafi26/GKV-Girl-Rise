# Project Context: GKV-Girl-Rise

This document serves as the developer handbook and layout reference for the Flutter landscape game **GKV-Girl-Rise**. Refer to this context file in any new conversation to align immediately with the design system, scaling rules, and component architecture.

---

## 1. Project Specifications & Layout scaling

All layouts are designed against a target landscape canvas size of **`874 x 402`**. To maintain layout consistency across all physical device sizes, the game uses **Aspect-Ratio Locked Containment Scaling** combined with screen-filled background overlays.

### Penskalaan Koordinat (Scaling Blueprint)
Inside the `build` method of any screen, use the following scaling blueprint:
```dart
final double screenWidth = MediaQuery.of(context).size.width;
final double screenHeight = MediaQuery.of(context).size.height;

// Design canvas dimensions (Figma default)
const double designWidth = 874.0;
const double designHeight = 402.0;

// Containment scaling
final double scaleX = screenWidth / designWidth;
final double scaleY = screenHeight / designHeight;
final double scale = min(scaleX, scaleY);

// Active viewport offsets to center layouts
final double activeCanvasWidth = designWidth * scale;
final double activeCanvasHeight = designHeight * scale;
final double offsetX = (screenWidth - activeCanvasWidth) / 2;
final double offsetY = (screenHeight - activeCanvasHeight) / 2;
```

---

## 2. Layout Rules & Constraints

### 1. Grounding Cut-off Characters (No Floating waist/chest cut-offs)
- **Problem**: Cut-off characters (like Bapak and Ibu) positioned relative to the active canvas (`bottom: offsetY`) will float on screens with vertical letterboxing (e.g. tablet or standard 16:9 laptop screens).
- **Rule**: If the character bottom cut-off is exposed (i.e. not covered by a full-width bottom textbox), **always anchor them directly to the absolute bottom of the physical phone screen** (remove `offsetY`) and bleed them slightly off-screen:
  ```dart
  bottom: -70.0 * scale // Pushed below screen boundary (Part 4 Choose outcomes)
  bottom: -50.0 * scale // Pushed below screen boundary (Intro screen)
  ```
- **Rule for Centered Background Characters (Part 1, 2, 3)**: Center the character using `left: 0, right: 0`, lock the height to `380.0 * scale` to avoid clipping, and raise them slightly above the dialogue box base using `bottom: offsetY + 40.0 * scale`.
- **Rule for Right-Aligned Characters (Part 4)**: To avoid right-edge clipping (black lines), shift the character leftward slightly by anchoring `right: offsetX + 80.0 * scale` with `height: 440.0 * scale`.

### 2. Full Screen Background
- **Rule**: Always draw background images with `Positioned.fill` and `fit: BoxFit.cover` to fill the entire physical screen. This ensures no black bars are visible:
  ```dart
  Positioned.fill(
    child: Image.asset('assets/images/bg2.1.png', fit: BoxFit.cover),
  )
  ```

### 3. Stack Ordering for SVGs
- **Rule**: SVG header tabs (such as `OUTCOME.svg`, `REFLECTION.svg`, `Obrolan tak terduga.svg`) must be declared **after** the textbox containers in the Stack list. Otherwise, the textbox borders will overlap and cover them.

### 4. Header Tab ("Kepala") Selection Rule
- **Rule (CRITICAL FOR AI)**: Whenever creating or editing screens that use `DialogueTextBox` or its variants (`ChoiceTextBox`, `ReflectionTextBox`), the AI **MUST ALWAYS ASK the user** which header tab SVG (referred to as the "kepala" of the dialogue box, e.g., `STORY.svg`, `Obrolan tak terduga.svg`, `OUTCOME.svg`, `REFLECTION.svg`, custom titles, or none) should be used. Do not assume or pick one automatically.

### 5. Raster vs SVG for Complex Graphics
- **Rule**: Do not use `flutter_svg` for parsing SVGs exported from Figma that contain complex raster images (base64 embedded PNGs). `flutter_svg` fails to render these properly under masks. Always use high-quality `.png` format for scenario cards, characters, and backgrounds.

---

## 3. Reusable Modular Components

We extracted the core layout boxes into standalone widgets under `lib/widgets/` to avoid boilerplate and maintain layout consistency. All dialogue components build on top of a common base dialogue widget.

### 1. DialogueTextBox (Base Widget)
Located at `lib/widgets/dialogue_text_box.dart`.
- **Purpose**: A generic base container that wraps the cream `form 3.svg` layout and handles its sizing, alignment, padding, and optional header tab SVG position.
- **Features**:
  - Handles the background framing offset math internally so the active content matches Figma design specs.
  - Places the dialogue header tab (`headerTabAsset`) on top with custom positioning.
  - Dynamically calculates whether the text is scrollable. If so, it renders a bouncing `arrow_drop_down` indicator at the bottom right that disappears when the user reaches the end of the text.

### 2. ChoiceTextBox
Located at `lib/widgets/choice_text_box.dart`.
- **Purpose**: Displays the outcome choice boxes in branching screens (e.g. Part 3).
- **Features**: 
  - Standardized height (`141.0 * scale`) and SVG border background (`form 3.svg`).
  - Automatically loads the header tab SVG (like `OUTCOME.svg`) on top.
  - Displays three interactive options inside `form 4.svg` box buttons arranged in a 2-row grid (Row 1: left & right options, Row 2: centered bottom option).
  - Handles scale-down hover/press animation on choice buttons.
  - Padding (horizontal `12.0 * scale`) and font size (`10.5 * scale`, Lora) are optimized to wrap long dialogue texts beautifully on two lines.

### 3. ReflectionTextBox
Located at `lib/widgets/reflection_text_box.dart`.
- **Purpose**: Displays the selected choice quote box and reflection narrative text in Choose outcomes screens (Part 4).
- **Features**:
  - Standardized float width (`303.5 * scale`) and height (`225.9 * scale`).
  - Automatically loads the header tab SVG (like `REFLECTION.svg`) on top.
  - High-aligns the content (top padding: `22.0 * scale`) to keep the small `form 4.svg` quote box close to the header tab.
  - Color-themed dialogue text uses Lora (`fontSize: 13.5 * scale` for quote text, `14.5 * scale` for narrative reflection text).

---

## 4. Prompt Templating

To generate cases rapidly, we use a reusable prompt template (available in `reusable_prompt_template.md`). This ensures the AI instantly maps Part 1, Part 2, Part 3 (Choices), and Part 4 (Reflections) to the exact coordinate standards described above without repetitive back-and-forth communication.

When applying the template, the AI automatically wires up the cross-screen navigation flows so each part links correctly to the next, and Part 4 triggers either the completion dialogue or the next case's Part 1.
