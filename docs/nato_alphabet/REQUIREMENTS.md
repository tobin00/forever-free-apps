# Requirements — NATO Alphabet Trainer

---

## App Summary

**One-line description:** A free, ad-free app to learn and practice the NATO phonetic alphabet.

**Target user:** Anyone who needs to spell things clearly over the phone — customer service, military, aviation, ham radio, or just curious learners.

**Core value:** Learn the NATO alphabet quickly through reference and self-quizzing, without ads or distractions.

---

## User Stories

### US-1: View the NATO Alphabet Reference
**As a** learner, **I want to** see all 26 letters with their NATO words **so that** I can study and memorize them.

**Acceptance criteria:**
- All 26 letters are displayed (A-Z)
- Each letter shows its NATO word (A = Alpha, B = Bravo, etc.)
- The list is scrollable
- Letters are large and easy to read
- Works in both portrait and landscape orientation

**Priority:** Must-have

---

### US-2: Take a Letter Flashcard Quiz
**As a** learner, **I want to** be shown random letters one at a time **so that** I can test whether I know the NATO word.

**Acceptance criteria:**
- A single random letter is displayed prominently on screen
- Both "Reveal" and "Next" buttons are always visible simultaneously
- User can tap "Reveal" to check — NATO word appears below the letter
- User can tap "Next" at any time (before or after revealing) to advance
- Letters should not repeat until all 26 have been shown (full cycle)
- User can see progress (e.g., "14 of 26")
- User can restart the quiz at any time

**Priority:** Must-have

---

### US-3: Take a Word Spelling Quiz
**As a** learner, **I want to** see a random English word and spell it using NATO alphabet names **so that** I can practice in a realistic scenario.

**Acceptance criteria:**
- A random word from the 1000 most common English words is shown
- User attempts to say the NATO letters out loud (honor system)
- Both "Show Me" and "Next" buttons are always visible simultaneously
- User can tap "Show Me" to reveal the answer
- Reveal animation: letters appear vertically, one by one, with a smooth staggered animation
- Each line shows the letter and its NATO word (e.g., "H — Hotel")
- User can tap "Next" at any time (before or after revealing) to get a new word
- Tapping "Next" clears any revealed answer and shows a fresh word

**Priority:** Must-have

---

### US-4: View the About Page
**As a** user, **I want to** learn about the app and its creator **so that** I understand the mission and can support it.

**Acceptance criteria:**
- Accessible from every screen (info icon in top app bar)
- Shows shared mission statement, donation link, and app version
- Donation link opens in external browser
- Brief, friendly, human tone

**Priority:** Must-have

---

### US-5: Navigate Between Sections Easily
**As a** user, **I want to** move between Reference, Letter Quiz, and Word Quiz **so that** I can use the app fluidly.

**Acceptance criteria:**
- Bottom navigation bar with clear icons and labels
- Three items: Reference, Letter Quiz, Word Quiz
- Current section is visually highlighted
- Navigation is instant (no loading screens)
- Back button exits app from any main tab
- State is preserved when switching tabs (quiz progress isn't lost)

**Priority:** Must-have

---

### US-6: Use the App Offline
**As a** user, **I want** the app to work without internet **so that** I can use it anywhere.

**Acceptance criteria:**
- App launches and functions fully with airplane mode enabled
- No network calls are made at any point
- No error messages or degraded experience offline

**Priority:** Must-have

---

### US-7: Use the App with Accessibility Features
**As a** user with a disability, **I want** the app to work with screen readers and large text **so that** I can use it like anyone else.

**Acceptance criteria:**
- All interactive elements have semantic labels for TalkBack
- App is usable with system font scaled to 200%
- Touch targets are at least 48x48dp
- Color is never the only way information is conveyed
- Animations respect system "reduce motion" setting

**Priority:** Must-have

---

## Screen Inventory

| Screen | Description |
|--------|-------------|
| **Reference** | Scrollable list of all 26 NATO alphabet entries. Default landing screen. |
| **Letter Quiz** | Single letter flashcard with Reveal and Next buttons always visible, plus progress indicator |
| **Word Quiz** | Shows a random word with Show Me and Next buttons always visible, plus animated reveal |
| **About** | Shared About page: mission statement, donation link, version info |

---

## UX Flows

### Flow 1: First Launch
1. User opens app → lands on **Reference** screen (bottom nav: Reference is selected)
2. User scrolls through the alphabet, reading entries
3. User taps "Letter Quiz" in bottom nav → enters flashcard mode
4. User taps "Word Quiz" in bottom nav → enters word quiz mode

### Flow 2: Letter Quiz Session
1. User enters Letter Quiz → sees a large random letter (e.g., "M") with both "Reveal" and "Next" buttons visible
2. **Path A (check answer):** User thinks "Mike" → taps "Reveal" → sees "M — Mike" displayed → taps "Next"
3. **Path B (already knows it):** User thinks "Mike" → taps "Next" directly (skips reveal)
4. New letter appears, progress indicator updates (e.g., "2 of 26")
5. After all 26 letters → shows a completion message with option to restart
6. User can tap "Restart" at any time to begin a new cycle

### Flow 3: Word Quiz Session
1. User enters Word Quiz → sees a word (e.g., "HELLO") with both "Show Me" and "Next" buttons visible
2. User says out loud: "Hotel, Echo, Lima, Lima, Oscar"
3. **Path A (check answer):** User taps "Show Me" →
   - Letters animate in vertically, staggered (each slides in from right with a slight delay):
     ```
     H — Hotel
     E — Echo
     L — Lima
     L — Lima
     O — Oscar
     ```
   - User verifies they got it right (honor system) → taps "Next"
4. **Path B (already knows it):** User taps "Next" directly (skips reveal)
5. "Next" always clears any revealed answer and shows a fresh word

### Flow 4: Accessing About
1. From any screen → user taps the info icon (ⓘ) in the top app bar
2. About page slides in as a new screen (no bottom nav visible)
3. User reads the mission, optionally taps the donation link (opens external browser)
4. User taps back → returns to previous screen with state preserved

---

## Test Cases

### Reference Screen Tests
| ID | Test | Expected Result |
|----|------|-----------------|
| T-R1 | Open app fresh | Reference screen loads, all 26 entries visible by scrolling |
| T-R2 | Scroll to bottom | Z = Zulu is the last entry |
| T-R3 | Rotate device | Layout adjusts, no overflow or clipping |
| T-R4 | Increase system font to max | Text remains readable, no overlap |

### Letter Quiz Tests
| ID | Test | Expected Result |
|----|------|-----------------|
| T-LQ1 | Enter Letter Quiz | A single random letter is shown prominently |
| T-LQ2 | Tap Reveal | NATO word appears with smooth animation |
| T-LQ3 | Tap Next after Reveal | New letter appears, progress updates |
| T-LQ4 | Tap Next without Reveal | New letter appears, progress updates |
| T-LQ5 | Complete all 26 letters | Completion message shown, option to restart |
| T-LQ6 | Tap Restart mid-quiz | Counter resets, new random order begins |
| T-LQ7 | Switch to another tab and back | Quiz progress is preserved |
| T-LQ8 | Rapid-tap Next 10 times | No crashes, each tap advances correctly |

### Word Quiz Tests
| ID | Test | Expected Result |
|----|------|-----------------|
| T-WQ1 | Enter Word Quiz | A word is displayed in large text |
| T-WQ2 | Tap "Show Me" | Letters animate in vertically with stagger effect |
| T-WQ3 | Tap "Next" after reveal | New word appears, previous answer clears |
| T-WQ4 | Tap "Next" without reveal | New word appears directly |
| T-WQ5 | Tap "Show Me" rapidly | Animation plays once, no stacking or glitches |
| T-WQ6 | Very long word (e.g., "SOMETHING") | All letters visible, scrollable if needed |
| T-WQ7 | Short word (e.g., "I" or "A") | Displays correctly, not awkwardly empty |
| T-WQ8 | Use 20+ words in sequence | No repeated words in short succession |

### Navigation Tests
| ID | Test | Expected Result |
|----|------|-----------------|
| T-N1 | Tap each bottom nav item | Correct screen loads each time |
| T-N2 | Press system back from any tab | App exits (standard Android behavior) |
| T-N3 | Press system back from About | Returns to previous screen |
| T-N4 | Switch tabs rapidly | No crashes, correct screen shown |

### Accessibility Tests
| ID | Test | Expected Result |
|----|------|-----------------|
| T-A1 | Enable TalkBack, navigate all screens | All elements are announced meaningfully |
| T-A2 | Set font to 200% | App remains usable, no text cutoff |
| T-A3 | Enable "Reduce animations" | Animations are disabled or simplified |

### Offline Test
| ID | Test | Expected Result |
|----|------|-----------------|
| T-O1 | Enable airplane mode, launch app | App works fully |

---

## Data Requirements

| Data | Source | Storage |
|------|--------|---------|
| NATO alphabet (26 entries) | Hardcoded constant | In-app Dart file |
| 1000 most common English words | Hardcoded constant (sourced from public domain word lists) | In-app Dart file |
| Quiz progress (current position) | Runtime state | In-memory only (Riverpod state, not persisted) |

**No persistent storage is needed.** Quiz progress resets on app close. No user data is collected or stored.

---

## Out of Scope

- Voice recognition / speech-to-text (honor system only)
- Score tracking or statistics across sessions
- Custom word lists
- Numbers or punctuation NATO codes (letters only)
- Multiplayer or social features
- User accounts or cloud sync
- Settings screen (follows system theme automatically)
