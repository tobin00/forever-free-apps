# Requirements — Forever Free: Flags of the World

> Status: APPROVED — implementation may begin.
> Last updated: 2026-04-05

---

## App Summary

**One-line description:** An offline quiz app that teaches users to recognize and name the flags of every country in the world.

**Target user:** Curious learners of any age — students, travelers, trivia enthusiasts — who want to memorize world flags at their own pace.

**Core value:** A clean, ad-free, fully offline flashcard and quiz experience for all ~195 world flags, with multiple quiz modes that adapt to what you struggle with.

---

## User Stories

### US-1: View the Main Menu

**As a** user, **I want to** see a clear main menu with all available modes **so that** I can quickly navigate to the part of the app I want.

**Acceptance criteria:**
- App opens directly to the Home screen (no splash screen)
- Home screen shows the app title/banner at the top
- Gear icon (settings) and info icon (About) visible in the top app bar
- Seven navigation options displayed as prominent buttons in this order:
  1. Flashcards
  2. Quiz — Multiple Choice
  3. Quiz — Mistakes
  4. Quiz — Tricky Flags
  5. Quiz — Typing
  6. Quiz — Custom
  7. List of All Flags
- "Quiz — Mistakes" button is visually greyed out and non-tappable when the mistakes list is empty
- All other buttons are always enabled

**Priority:** Must-have

---

### US-2: Browse the Reference List

**As a** user, **I want to** scroll through all country flags in one place **so that** I can study them before quizzing.

**Acceptance criteria:**
- Shows all ~195 sovereign nations in alphabetical order
- Each row displays the flag image and country name side by side
- List is smooth and performant (no jank while scrolling)
- Search bar at the top allows filtering by country name
- Works fully offline — no network requests
- Accessible from the main menu ("List of All Flags" button)

**Priority:** Must-have

---

### US-3: Study with Flashcards

**As a** user, **I want to** flip through flags at my own pace and reveal the country name when I'm ready **so that** I can study before taking a quiz.

**Acceptance criteria:**
- Cycles through all ~195 countries in random order
- Each card shows only the flag image initially
- "Reveal" button shows the country name below the flag
- "Next" button advances to the next flag without revealing (skipping is fine — no scoring)
- No score is tracked; no right/wrong feedback
- A simple progress indicator shows current position (e.g. "34 / 195") — no progress bar required
- When all flags have been shown, returns automatically to the main menu
- "X" quit button visible at all times; tapping returns to Home immediately (no confirmation dialog needed — no score to lose)

**Priority:** Must-have

---

### US-4: Take a Multiple Choice Quiz


**As a** user, **I want to** be quizzed on every country flag through a multiple choice format **so that** I can measure and improve my recognition.

**Acceptance criteria:**
- Quiz cycles through all ~195 countries exactly once per session, in random order
- Each question independently and randomly uses one of two modes — the mode is re-rolled every question, so the user gets unpredictable variety throughout the session:
  - **Flag mode:** Flag image displayed at top; 4 cards below with country name options
  - **Name mode:** Country name displayed at top; 4 cards below with flag image options
- Exactly one answer is correct per question; the other 3 are plausible distractors
- Answer cards are light blue (Surface/card color) before selection
- "Next" button at the bottom is greyed out and disabled until an answer is selected or a wrong answer is tapped
- **Correct answer behavior:** Selected card turns green immediately; quiz auto-advances after a short delay (or user taps "Next" which becomes enabled)
- **Wrong answer behavior:** Selected card turns red; correct answer card turns green; "Next" button turns amber/yellow and becomes tappable
- Progress bar at the top fills left to right as questions are completed
- "X" button on the left of the progress bar quits the quiz at any time (with a confirmation dialog)
- Below the progress bar: "Right: [N]  Wrong: [N]" — right count in green, wrong count in red
- On quiz completion: navigate to the Results screen
- Countries answered incorrectly are added to the persistent Mistakes list

**Priority:** Must-have

---

### US-5: View Quiz Results

**As a** user, **I want to** see my final score after completing any quiz **so that** I know how well I did.

**Acceptance criteria:**
- Results screen shows: final right count (green), final wrong count (red)
- "Return to Main Menu" button navigates back to Home
- Results are shown after every quiz mode (Multiple Choice, Mistakes, Tricky Flags, Typing, Custom)
- No score is saved permanently (each quiz is a fresh challenge)

**Priority:** Must-have

---

### US-6: Take a Mistakes Quiz

**As a** user, **I want to** quiz only on the flags I've gotten wrong **so that** I can focus on my weak spots until I master them.

**Acceptance criteria:**
- Uses the exact same UI and behavior as the Multiple Choice quiz (US-4)
- Always uses Multiple Choice format regardless of which quiz mode originally produced the mistake
- Question pool is the persistent Mistakes list only
- When a country is answered correctly, it is immediately removed from the Mistakes list
- When a country is answered incorrectly, it stays on the Mistakes list
- If the Mistakes list is empty, the "Quiz — Mistakes" button on Home is greyed out
- Session ends when all countries in the Mistakes list have been answered correctly (or user quits)
- Results screen shown on completion

**Priority:** Must-have

---

### US-7: Take a Tricky Flags Quiz

**As a** user, **I want to** be quizzed on groups of visually similar flags **so that** I can learn to tell them apart.

**Acceptance criteria:**
- Each question uses a "tricky group" — a curated set of countries with similar-looking flags
- Question randomly uses flag mode or name mode (same as Multiple Choice):
  - **Flag mode:** Show a flag from the group; the 4 answer options are all country names from the group
  - **Name mode:** Show a country name from the group; the 4 answer options are all flag images from that group
- Groups are defined in a Dart configuration file (`lib/data/tricky_flag_groups.dart`) that is easy to update
- Initial groups file ships with at least one group: Ethiopia, Ghana, Guinea, Cameroon
- Card answer behavior is identical to Multiple Choice (green/red/amber, progress bar, right/wrong counter)
- Cycles through all groups (one question per group member) before ending
- Results screen shown on completion

**Priority:** Must-have

---

### US-8: Take a Typing Quiz

**As a** user, **I want to** type country names in response to flag images **so that** I can test recall without hints.

**Acceptance criteria:**
- Shows a flag image; user types the country name using the system keyboard
- Progress bar, X quit button, and Right/Wrong counter at top (same as Multiple Choice)
- **Correct answer:** Text turns green briefly, "Correct!" label flashes on screen, auto-advances to next flag
- **"So Close!" mechanic:** If the answer is off by exactly one character (one insertion, deletion, or substitution — Levenshtein distance = 1), a "So Close! Try again" button appears instead of marking wrong. Tapping it clears the text field. The input box shakes with a brief animation when "So Close!" triggers.
- **Wrong answer:** Typed text turns red; correct country name shown above the input in green; a bottom sheet or card slides up with a "Next Flag" button
- Cycles through all ~195 countries in random order
- Results screen shown on completion
- Countries answered incorrectly are added to the persistent Mistakes list

**Priority:** Must-have

---

### US-9: Configure and Take a Custom Quiz

**As a** user, **I want to** set my own quiz options **so that** I can practice in the way that suits me best.

**Acceptance criteria:**
- Custom Config screen accessible from "Quiz — Custom" on Home
- Available options (v1 — can expand later):
  - **Loop forever:** Toggle — when on, quiz never ends (repeats randomly after cycling all countries)
  - **Quiz direction:** Toggle between "Flag → Name", "Name → Flag", or "Random" (default)
  - **Country count:** Slider or picker to choose how many countries to include (e.g. 10, 25, 50, 100, All)
  - **Region filter:** Picker to restrict the country pool to one region — Africa, Americas, Asia, Europe, Oceania, or All (default)
- "Start Quiz" button launches the quiz with selected options
- Custom quiz uses the Multiple Choice UI format
- If a specific region is chosen and count exceeds countries in that region, quiz uses all countries in the region
- Results screen shown on completion (unless Loop forever is on — show score summary on X quit)

**Priority:** Should-have

---

### US-10: Change App Appearance

**As a** user, **I want to** control whether the app uses light or dark mode **so that** it's comfortable in any lighting.

**Acceptance criteria:**
- Settings screen accessible via the gear icon on the Home screen
- Three options: Light, Dark, Auto (follow system) — default is Auto
- Selection is persisted across app restarts
- Theme changes apply immediately without restart
- Settings screen has a back button to return to Home

**Priority:** Must-have

---

### US-11: Use the App Offline

**As a** user, **I want** the app to work without internet **so that** I can use it anywhere — on a plane, in a remote area, or without data.

**Acceptance criteria:**
- App launches and functions fully with airplane mode enabled
- All flag images are bundled with the app (no remote loading)
- No network calls are made at any point
- No internet permission in AndroidManifest.xml
- No error messages or degraded experience offline

**Priority:** Must-have

---

### US-12: Use the App with Accessibility Features

**As a** user with a disability, **I want** the app to work with screen readers and large text **so that** I can use it like anyone else.

**Acceptance criteria:**
- All interactive elements have Semantics labels for TalkBack / VoiceOver
- App is fully usable with system font scaled to 200%
- All touch targets are at least 48×48dp
- Color is never the only way information is conveyed (correct/wrong answers also use icons or text labels, not just color)
- Animations respect `MediaQuery.disableAnimations`

**Priority:** Must-have

---

### US-13: View the About Page

**As a** user, **I want to** learn about the app and support its creator **so that** I understand the mission and can contribute if I choose.

**Acceptance criteria:**
- Info icon in the top app bar on every screen navigates to the About page
- About page uses the `shared_app_core` AboutPage widget
- Shows app icon, app name, version number
- Shows the shared mission statement
- Donation button opens Ko-fi in the system browser
- Back button returns to the previous screen

**Priority:** Must-have

---

## Screen Inventory

| Screen | Description |
|--------|-------------|
| **Home** | Main menu — app title, 7 mode buttons, settings + about icons |
| **Flashcards** | Show flag → Reveal country name → Next; progress counter; no scoring |
| **Reference List** | Alphabetical scrollable list of all ~195 flags with search |
| **Multiple Choice Quiz** | Flag-or-name multiple choice; progress bar; right/wrong counter |
| **Mistakes Quiz** | Same UI as Multiple Choice; filtered to persistent mistakes list |
| **Tricky Flags Quiz** | Same UI as Multiple Choice; questions from similar-flag groups |
| **Typing Quiz** | Flag image + text input; So Close mechanic; shake animation |
| **Custom Quiz Config** | Settings panel for custom quiz (loop, direction, count) |
| **Custom Quiz** | Multiple choice format with user-configured options |
| **Quiz Results** | Final right/wrong score + "Return to Main Menu" button |
| **Settings** | Light / Dark / Auto mode selector |
| **About** | Shared About page (mission, version, donation) |

---

## UX Flows

### Flow 1: Home → Flashcards

1. User opens app → **Home** screen
2. User taps "Flashcards"
3. **Flashcard** screen loads; first flag shown; "34 / 195" counter in top right; X button in top left
4. User studies the flag, then taps "Reveal" → country name appears below the flag
5. User taps "Next" → next flag shown (name hidden again); counter increments
6. User may also tap "Next" without revealing — that's fine, no penalty
7. After the last flag: returns automatically to **Home**
8. Tapping X at any point → returns to **Home** immediately (no confirmation)

### Flow 2: Home → Multiple Choice Quiz → Results

1. User opens app → **Home** screen
2. User taps "Quiz — Multiple Choice"
3. **Multiple Choice Quiz** screen loads; first question appears immediately
4. User taps an answer card → card turns green or red; correct card turns green
5. "Next" becomes enabled (or amber if wrong) → user taps → next question
6. Repeat for all ~195 countries
7. On last answer: **Quiz Results** screen slides in
8. User taps "Return to Main Menu" → back to **Home**

### Flow 3: Home → Mistakes Quiz (with mistakes present)

1. User opens app; mistakes list is non-empty → **Home**: "Quiz — Mistakes" button is active
2. User taps "Quiz — Mistakes"
3. Quiz plays exactly like Multiple Choice but only countries from the mistakes list
4. Each correct answer removes that country from the mistakes list in real time
5. Quiz ends when all mistakes are cleared (or user quits)
6. **Quiz Results** → user taps "Return to Main Menu"
7. If all mistakes were cleared: "Quiz — Mistakes" is now greyed out on Home

### Flow 4: Home → Tricky Flags Quiz

1. User taps "Quiz — Tricky Flags"
2. Quiz loads; questions are drawn from tricky groups only
3. For each group, each member country gets a question with the other group members as distractors
4. Behavior identical to Multiple Choice
5. **Quiz Results** → Return to Main Menu

### Flow 5: Home → Typing Quiz

1. User taps "Quiz — Typing"
2. Flag image shown; keyboard appears (or user taps the text field to open it)
3. User types an answer and submits
   - Exact match: "Correct!" flash → next flag
   - Off-by-one: text field shakes; "So Close! Try again" button appears; user clears and retypes
   - Wrong: input turns red; correct answer shown in green; "Next Flag" card slides up
4. Repeat for all ~195 countries
5. **Quiz Results** → Return to Main Menu

### Flow 6: Home → Custom Quiz Config → Custom Quiz

1. User taps "Quiz — Custom"
2. **Custom Quiz Config** screen: user sets loop/direction/count/region options
3. User taps "Start Quiz" → **Custom Quiz** runs with chosen options
4. If loop is off: **Quiz Results** on completion
5. If loop is on: user taps X to quit → **Quiz Results** shows accumulated score

### Flow 7: Home → Reference List

1. User taps "List of All Flags"
2. **Reference List** loads; alphabetical list of all ~195 flags visible
3. User scrolls, or types in search bar to filter
4. User taps back → returns to Home

### Flow 8: Home → Settings → Theme Change

1. User taps gear icon → **Settings** screen
2. User selects Light, Dark, or Auto
3. App theme changes immediately
4. User taps back → returns to Home

### Flow 9: Any Screen → About

1. User taps info icon in any screen's app bar
2. **About** screen appears (full-screen, outside bottom nav if applicable)
3. User taps donation button → Ko-fi opens in external browser
4. User taps back → returns to previous screen

### Flow 10: Quitting Mid-Quiz

1. User taps "X" button during any quiz
2. Confirmation dialog: "Quit this quiz? Your progress will be lost." with "Quit" and "Keep Going" buttons
3. "Quit" → returns to Home; partial progress discarded (mistakes recorded so far are still saved)
4. "Keep Going" → dismisses dialog; quiz resumes

---

## Test Cases

### Home Screen

| ID | Test | Expected Result |
|----|------|-----------------|
| T-H01 | Launch app with no mistakes saved | Home shows; "Quiz — Mistakes" button is greyed out |
| T-H02 | Launch app with mistakes saved | "Quiz — Mistakes" button is active and tappable |
| T-H03 | Tap each of the 6 mode buttons | Each navigates to the correct screen |
| T-H04 | Tap gear icon | Settings screen opens |
| T-H05 | Tap info icon | About page opens |
| T-H06 | Landscape orientation | Home layout remains usable; buttons not clipped |

### Multiple Choice Quiz

| ID | Test | Expected Result |
|----|------|-----------------|
| T-MC01 | Start quiz | First question loads; 4 answer cards shown; "Next" greyed out |
| T-MC02 | Tap correct answer | Card turns green; quiz advances (or "Next" activates) |
| T-MC03 | Tap wrong answer | Tapped card turns red; correct card turns green; "Next" turns amber |
| T-MC04 | Complete all ~195 questions | Results screen shown with correct right/wrong totals |
| T-MC05 | Progress bar at start | Bar is empty |
| T-MC06 | Progress bar midway (question 97/195) | Bar is approximately 50% filled |
| T-MC07 | Right/wrong counter | Updates correctly after each answer |
| T-MC08 | Tap X mid-quiz | Confirmation dialog appears |
| T-MC09 | Confirm quit | Returns to Home; mistakes saved so far are kept |
| T-MC10 | Wrong answers accumulate in mistakes list | After quiz, Mistakes button is active |
| T-MC11 | Both question modes appear | Over 20 questions, both flag-top and name-top modes appear |

### Flashcards

| ID | Test | Expected Result |
|----|------|-----------------|
| T-FC01 | Start Flashcards | First flag shown; country name hidden; progress shows "1 / 195" |
| T-FC02 | Tap Reveal | Country name appears below the flag |
| T-FC03 | Tap Next without revealing | Advances to next flag; no penalty |
| T-FC04 | Tap Next after revealing | Advances to next flag; name hidden again |
| T-FC05 | Progress counter | Increments correctly with each Next tap |
| T-FC06 | Tap X button | Returns to Home immediately; no confirmation dialog |
| T-FC07 | Complete all 195 flags | Returns automatically to Home screen |

### Mistakes Quiz

| ID | Test | Expected Result |
|----|------|-----------------|
| T-MQ01 | Start Mistakes quiz | Only countries from mistakes list appear |
| T-MQ02 | Get a question right | Country removed from mistakes list immediately |
| T-MQ03 | Get a question wrong | Country remains in mistakes list |
| T-MQ04 | Clear all mistakes | Quiz ends; Results shown; Mistakes button greyed out on Home |
| T-MQ05 | Tap Mistakes button when empty | Button is non-interactive (greyed out) |

### Tricky Flags Quiz

| ID | Test | Expected Result |
|----|------|-----------------|
| T-TF01 | Start Tricky Flags quiz | Questions appear using only countries from defined groups |
| T-TF02 | Answer options are same-group members | All 4 options belong to the same tricky group |
| T-TF03 | Add a new group to config file | New group appears in quiz without code changes |
| T-TF04 | Complete all group questions | Results screen shown |

### Typing Quiz

| ID | Test | Expected Result |
|----|------|-----------------|
| T-TY01 | Type exact country name | "Correct!" shown; advances to next flag |
| T-TY02 | Type name with one wrong letter | "So Close! Try again" button appears; input clears on tap |
| T-TY03 | Shake animation on "So Close!" | Input field visibly shakes |
| T-TY04 | Type completely wrong answer | Input turns red; correct answer shown in green; "Next Flag" appears |
| T-TY05 | Case sensitivity | "france" and "France" both accepted as correct |
| T-TY06 | Submit with empty field | No action taken (submit button disabled or ignored) |
| T-TY07 | Complete all ~195 questions | Results screen shown |

### Custom Quiz Config

| ID | Test | Expected Result |
|----|------|-----------------|
| T-CQ01 | Open Custom config | All options visible with defaults shown |
| T-CQ02 | Enable Loop forever | Start quiz; quiz wraps around and does not end |
| T-CQ03 | Set country count to 10 | Quiz ends after 10 questions |
| T-CQ04 | Set direction to "Flag → Name" | All questions show flag at top; name cards below |
| T-CQ05 | Select region "Europe" | Only European countries appear in quiz |
| T-CQ06 | Select region "Europe", count = 1000 | Quiz uses all European countries (doesn't crash on over-count) |

### Reference List

| ID | Test | Expected Result |
|----|------|-----------------|
| T-RL01 | Open Reference list | All ~195 countries shown in alphabetical order |
| T-RL02 | Type "Ger" in search bar | List filters to matching countries (Germany, etc.) |
| T-RL03 | Clear search | Full list returns |
| T-RL04 | Scroll to bottom | No jank; all items rendered |

### Settings

| ID | Test | Expected Result |
|----|------|-----------------|
| T-ST01 | Select Dark mode | App switches to dark theme immediately |
| T-ST02 | Select Light mode | App switches to light theme immediately |
| T-ST03 | Select Auto | App matches system theme |
| T-ST04 | Restart app after setting Dark | Dark theme persists |

### Accessibility

| ID | Test | Expected Result |
|----|------|-----------------|
| T-AC01 | TalkBack enabled — Home screen | All 7 buttons readable by TalkBack with meaningful labels |
| T-AC02 | TalkBack — answer card | TalkBack announces country name or "Flag of [Country]" |
| T-AC03 | Font scale 200% | No text clipped or overflowed on any screen |
| T-AC04 | All touch targets | Every tappable element is ≥ 48×48dp |
| T-AC05 | Color-only info | Correct/wrong cards show icon or text in addition to color |

### Offline

| ID | Test | Expected Result |
|----|------|-----------------|
| T-OF01 | Enable airplane mode; open app | App launches normally; all features work |
| T-OF02 | Take full quiz in airplane mode | No errors; all flags display correctly |

---

## Data Requirements

| Data | Source | Storage |
|------|--------|---------|
| Country list (~195 entries) | Bundled Dart constants (`lib/data/countries.dart`) | Compiled into app |
| Flag images | `country_flags` pub.dev package (SVG, offline) | Bundled with package |
| Tricky flag groups | Dart constants file (`lib/data/tricky_flag_groups.dart`) | Compiled into app |
| Mistakes list (country ISO codes) | Persisted between sessions; accumulates from **all** quiz modes (Multiple Choice, Tricky Flags, Typing, Custom) | `shared_preferences` |
| App theme setting (light/dark/auto) | Persisted between sessions | `shared_preferences` |

### Country Data Model

```dart
class Country {
  final String name;        // "France"
  final String isoCode;     // "FR"
  final String region;      // "Europe" — used by Custom Quiz region filter
}
```

**Regions used for filter:** Africa, Americas, Asia, Europe, Oceania

### Tricky Group Data Model

```dart
class TrickyFlagGroup {
  final String groupName;         // "Green/Yellow/Red Tricolors"
  final List<String> isoCodes;    // ["ET", "GH", "GN", "CM"]
}
```

### Flag Display
Use the `country_flags` package (SVG-based, offline, covers all UN member states). Flag widgets are rendered as `CountryFlag.fromCountryCode(isoCode)`.

### Initial Tricky Groups (v1)

| Group Name | Countries |
|------------|-----------|
| Green/Yellow/Red Tricolors | Ethiopia, Ghana, Guinea, Cameroon |

More groups to be added collaboratively with user before implementation.

---

## Out of Scope

- No internet connection required for any feature
- No user accounts or login
- No in-app purchases or ads
- No push notifications
- No leaderboards or social features
- No audio (text-to-speech for flag names) — potential future feature
- No iOS build in v1 (deferred to Phase 12)
- No automatic syncing of mistakes list across devices
- No timed/speed quiz mode in v1 (potential future feature in Custom)
- Capital cities not included in v1 (potential future expansion of Country data)
