# Pre-Launch Checklist — NATO Alphabet Trainer

> Copied from `docs/templates/07-CHECKLIST.md`. Check off each item before release.

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
- [ ] Every test case from REQUIREMENTS.md has been manually verified
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

## Website (Phase 9)

- [x] App icon copied to `website/apps/nato_alphabet/icon.png`
- [x] 5 phone screenshots copied to `website/apps/nato_alphabet/screenshots/`
- [x] App entry added to `website/apps-data.js`
- [x] `androidUrl` is correct live store link
- [x] `iosUrl` is null (iOS not yet live)
- [x] Website verified locally and in Chrome
- [x] Commit pushed — GitHub Actions deploy workflow completed successfully
- [x] Live site at `https://coziahr.com/foreverfree` confirmed working
- [ ] User confirmed site looks correct on desktop and mobile

## Post-Launch

- [ ] Verify store listing is live and accurate
- [ ] Install from store on a real device and verify
- [ ] Check for any crash reports (Play Console → Quality → Crashes)
- [ ] Update docs/templates with any lessons learned
