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
- **Exception**: If the character bottom is covered by a full-width bottom textbox (like Part 1 and Part 2), they can be aligned relative to the active canvas bottom:
  ```dart
  bottom: offsetY + 59.0 * scale // Stands behind textbox (top: 261, height: 141)
  ```

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

---

## 3. Reusable Modular Components

We extracted the core layout boxes into standalone widgets under `lib/widgets/` to avoid boilerplate and maintain layout consistency. All dialogue components build on top of a common base dialogue widget.

### 1. DialogueTextBox (Base Widget)
Located at [dialogue_text_box.dart](file:///c:/Project/GKV-Girl-Rise/girls_rise/lib/widgets/dialogue_text_box.dart).
- **Purpose**: A generic base container that wraps the cream `form 3.svg` layout and handles its sizing, alignment, padding, and optional header tab SVG position.
- **Features**:
  - Handles the background framing offset math internally so the active content matches Figma design specs.
  - Places the dialogue header tab (`headerTabAsset`) on top with custom positioning.
  - Sizing is scaled dynamically by passing the `scale` value.

### 2. ChoiceTextBox
Located at [choice_text_box.dart](file:///c:/Project/GKV-Girl-Rise/girls_rise/lib/widgets/choice_text_box.dart).
- **Purpose**: Displays the outcome choice boxes in branching screens (e.g. Part 3).
- **Features**: 
  - Standardized height (`141.0 * scale`) and SVG border background (`form 3.svg`).
  - Automatically loads the header tab SVG (like `OUTCOME.svg`) on top.
  - Displays three interactive options inside `form 4.svg` box buttons arranged in a 2-row grid (Row 1: left & right options, Row 2: centered bottom option).
  - Handles scale-down hover/press animation on choice buttons.
  - Padding (horizontal `12.0 * scale`) and font size (`10.5 * scale`, Lora) are optimized to wrap long dialogue texts beautifully on two lines.

### 3. ReflectionTextBox
Located at [reflection_text_box.dart](file:///c:/Project/GKV-Girl-Rise/girls_rise/lib/widgets/reflection_text_box.dart).
- **Purpose**: Displays the selected choice quote box and reflection narrative text in Choose outcomes screens (Part 4).
- **Features**:
  - Standardized float width (`303.5 * scale`) and height (`225.9 * scale`).
  - Automatically loads the header tab SVG (like `REFLECTION.svg`) on top.
  - High-aligns the content (top padding: `22.0 * scale`) to keep the small `form 4.svg` quote box close to the header tab.
  - Color-themed dialogue text uses Lora (`fontSize: 13.5 * scale` for quote text, `14.5 * scale` for narrative reflection text).

---

## 4. Screen Layout & Map (Scenario 2 Case 1)

### 1. Intro Screen
- **Path**: [scenario_2_intro_screen.dart](file:///c:/Project/GKV-Girl-Rise/girls_rise/lib/scenario_2/intro/scenario_2_intro_screen.dart)
- **Characters**: Bapak & Ibu standing straight, grounded to screen bottom: `bottom: -50.0 * scale`. Cewe standing at `bottom: offsetY`.
- **Text Box**: Floating center-right cream textbox (`form 3.svg`).

### 2. Part 1 Screen
- **Path**: [part_1_screen.dart](file:///c:/Project/GKV-Girl-Rise/girls_rise/lib/scenario_2/case_1/part_1/part_1_screen.dart)
- **Characters**: Bapak & Ibu standing straight, bottom raised: `bottom: offsetY + 59.0 * scale`.
- **Text Box**: Full-width bottom textbox. `top: offsetY + 261.0 * scale`, `height: 141.0 * scale`. Tab `Obrolan tak terduga.svg` at `top: offsetY + 217.0 * scale`.

### 3. Part 2 Screen
- **Path**: [part_2_screen.dart](file:///c:/Project/GKV-Girl-Rise/girls_rise/lib/scenario_2/case_1/part_2/part_2_screen.dart)
- **Characters & TextBox**: Merged dialogue lines (both characters visible, dialogues displayed together). Positioned exactly matching Part 1.

### 4. Part 3 Screen (Choose Screen)
- **Path**: [part_3_screen.dart](file:///c:/Project/GKV-Girl-Rise/girls_rise/lib/scenario_2/case_1/part_3/part_3_screen.dart)
- **Characters**: Enlarged center image `extracted_intro3.png` (`width: 300.0 * scale`, `height: 350.0 * scale`, `bottom: offsetY + 50.0 * scale`).
- **TextBox**: Renders the modular `ChoiceTextBox` widget.

### 5. Part 4 Choose Outcomes (1, 2, 3)
- **Paths**: 
  - [part_4_choose_1_screen.dart](file:///c:/Project/GKV-Girl-Rise/girls_rise/lib/scenario_2/case_1/part_4_choose_1/part_4_choose_1_screen.dart)
  - [part_4_choose_2_screen.dart](file:///c:/Project/GKV-Girl-Rise/girls_rise/lib/scenario_2/case_1/part_4_choose_2/part_4_choose_2_screen.dart)
  - [part_4_choose_3_screen.dart](file:///c:/Project/GKV-Girl-Rise/girls_rise/lib/scenario_2/case_1/part_4_choose_3/part_4_choose_3_screen.dart)
- **Characters**: Enlarged composite characters (`ibu.bapak.marah.png` or `ibu.bapak.biasa.png`) on the right, grounded to screen bottom: `bottom: -70.0 * scale` (`width: 440.0 * scale`, `height: 440.0 * scale`).
- **TextBox**: Renders the modular `ReflectionTextBox` widget. Clicking anywhere on the screen displays the Scenario Completed dialog.
