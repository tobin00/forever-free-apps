// App catalog data. To add a new app, append an entry to the array below.
// See docs/templates/08-WEBSITE.md for the full schema.
const APPS_DATA = {
  apps: [
    {
      id: "nato_alphabet",
      name: "NATO Alphabet Trainer",
      tagline: "Learn the phonetic alphabet — free, offline, ad-free.",
      description: "NATO Alphabet Trainer is a free, ad-free app to learn and practice the NATO phonetic alphabet (Alpha, Bravo, Charlie...).\n\nWhether you need it for work, military service, aviation, ham radio, or just want to learn something useful — this app makes it easy with a clean reference and two quiz modes: Letter Flashcards and a Word Quiz that gives you real English words to spell out phonetically.\n\nCompletely free, no ads, no tracking, works entirely offline.",
      androidUrl: "https://play.google.com/store/apps/details?id=com.foreverfree.nato_alphabet",
      iosUrl: null,
      screenshots: [
        { src: "apps/nato_alphabet/screenshots/01.png", w: 1080, h: 2400, alt: "Reference screen showing all 26 NATO code words" },
        { src: "apps/nato_alphabet/screenshots/02.png", w: 1080, h: 2400, alt: "Letter quiz — tap to reveal the code word" },
        { src: "apps/nato_alphabet/screenshots/03.png", w: 1080, h: 2400, alt: "Letter quiz — code word revealed" },
        { src: "apps/nato_alphabet/screenshots/04.png", w: 1080, h: 2400, alt: "Word quiz — spell a word using NATO alphabet" },
        { src: "apps/nato_alphabet/screenshots/05.png", w: 1080, h: 2400, alt: "Word quiz — answer revealed letter by letter" }
      ]
    }
  ]
};
