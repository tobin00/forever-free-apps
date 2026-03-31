# 07 - Pre-Launch Checklist

> **AI:** Copy this file to `docs/{app_name}/CHECKLIST.md` and check off each item during Phase 7.
> You verify most items yourself. Items requiring user action are in the "Final Approval" section.
> Nothing ships until every item passes.

---

## Code Quality

- [ ] `flutter analyze` reports zero errors and zero warnings
- [ ] No `TODO` or `FIXME` comments left in shipping code
- [ ] No `print()` or `debugPrint()` statements left in shipping code
- [ ] No hardcoded test values or placeholder text
- [ ] All imports are used (no dead imports)
- [ ] Code follows project conventions from 03-ARCHITECTURE.md

## Testing

- [ ] All unit tests pass: `flutter test test/`
- [ ] All widget tests pass (included in above)
- [ ] All integration tests pass: `flutter test integration_test/`
- [ ] Every test case from 01-REQUIREMENTS.md has been manually verified
- [ ] Tested on at least 2 emulator screen sizes (small phone + tablet)
- [ ] Tested in portrait AND landscape orientation
- [ ] Tested with airplane mode enabled (offline)

## Accessibility

- [ ] All interactive elements have semantic labels (for screen readers)
- [ ] App is navigable with TalkBack enabled on Android emulator
- [ ] All touch targets are at least 48x48dp
- [ ] Text is readable with system font size at maximum
- [ ] No information is conveyed by color alone
- [ ] Animations respect "Reduce motion" system setting

## Visual & UX

- [ ] Both light mode and dark mode look correct on every screen
- [ ] No text overflow or clipping on any screen
- [ ] Animations are smooth (no janky frames)
- [ ] Back button behavior is intuitive on every screen
- [ ] Navigation state is preserved when switching tabs
- [ ] App icon displays correctly at all sizes
- [ ] Splash screen (if any) displays correctly

## Performance

- [ ] App launches in under 2 seconds on emulator
- [ ] No perceptible lag during screen transitions
- [ ] Scrolling is smooth (60fps)
- [ ] Memory usage is stable (no unbounded growth during extended use)

## Signing & Build

- [ ] `pubspec.yaml` version number is correct and incremented
- [ ] Android keystore is configured and backed up
- [ ] `key.properties` exists locally and is gitignored
- [ ] Release build succeeds: `flutter build appbundle --release`
- [ ] APK/AAB is reasonable size (< 25MB for a simple app)

## Store Readiness

- [ ] Store description is accurate and follows template
- [ ] At least 4 screenshots taken on clean emulator (no debug banner)
- [ ] Feature graphic created (1024x500, Play Store)
- [ ] Privacy policy is hosted and URL works
- [ ] Data Safety questionnaire completed
- [ ] Content rating questionnaire completed
- [ ] App categorized correctly in store

## CI/CD Pipeline

- [ ] Codemagic build triggered by push to main
- [ ] All CI pipeline stages pass (analyze → test → build)
- [ ] Build artifact (AAB) is downloadable from Codemagic
- [ ] Internal testing track upload successful
- [ ] App installable from internal testing link
- [ ] Manual verification on physical device (if available)

## Final Approval

- [ ] Developer (AI) has self-tested all UX flows
- [ ] Human owner has reviewed and approved the app
- [ ] No known bugs or issues remain
- [ ] Ready to promote to production

---

## Post-Launch

- [ ] Verify store listing is live and accurate
- [ ] Install from store on a real device and verify
- [ ] Check for any crash reports (Play Console → Quality → Crashes)
- [ ] Update docs/templates with any lessons learned

---

## Instructions for AI

This checklist is the same for every app. When you reach Phase 7:
1. Copy this file to `docs/{app_name}/CHECKLIST.md`
2. Work through items yourself, checking each one off
3. For items you can't verify (e.g., physical device testing, store listing live), ask the user to verify
4. If you discover app-specific checks that should apply to all future apps, update THIS template file
