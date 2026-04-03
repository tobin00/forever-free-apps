# 08 - Website Guide

> **Audience: AI Assistant (Claude).** Instructions for maintaining the ForeverFree website at `https://coziahr.com/foreverfree`.
> Read this before executing Phase 9 for any app.

---

## Overview

The website is a **static single-page site** (plain HTML + CSS + JS, no framework, no build step).
It lives in `website/` in this repo and auto-deploys to `https://coziahr.com/foreverfree`
via GitHub Actions whenever `website/**` changes are pushed to `main`.

### Directory structure

```
website/
├── index.html              # Main page — renders from apps.json
├── apps.json               # Data file: one entry per published app
├── style.css               # All styles
├── app.js                  # Reads apps.json, builds DOM, runs lightbox
├── assets/
│   └── banner.png          # Ko-fi-style brand banner (reused hero image)
└── apps/
    ├── nato_alphabet/
    │   ├── icon.png
    │   └── screenshots/
    │       ├── 01.png
    │       ├── 02.png
    │       └── ...
    └── {app_name}/         # One folder per app
        ├── icon.png
        └── screenshots/
            └── ...
```

---

## Adding a New App (Phase 9 Steps)

### Step 1 — Prepare assets

```
website/apps/{app_name}/icon.png
website/apps/{app_name}/screenshots/01.png
website/apps/{app_name}/screenshots/02.png
...
```

- Use the same icon as the store (512×512 or smaller, PNG)
- Use phone screenshots already created for the store listing
- 4–5 screenshots is ideal; rename them `01.png`, `02.png`, ... in display order

### Step 2 — Add entry to `apps.json`

```json
{
  "id": "nato_alphabet",
  "name": "NATO Alphabet Trainer",
  "tagline": "Learn the phonetic alphabet — free, offline, ad-free.",
  "description": "Master the NATO phonetic alphabet with interactive letter and word quizzes. No ads, no tracking, works completely offline.",
  "androidUrl": "https://play.google.com/store/apps/details?id=com.coziahr.nato_alphabet",
  "iosUrl": null,
  "screenshots": [
    "apps/nato_alphabet/screenshots/01.png",
    "apps/nato_alphabet/screenshots/02.png",
    "apps/nato_alphabet/screenshots/03.png",
    "apps/nato_alphabet/screenshots/04.png"
  ]
}
```

- Set `iosUrl` to `null` if not yet on iOS; the iOS badge will be hidden automatically
- Append new apps to the end of the `apps` array (newest at bottom, or reverse order — follow whatever order is established in the live site)

### Step 3 — Verify locally

Open `website/index.html` directly in a browser (no server needed — it's fully static).
Check:
- New app card appears
- Screenshots load and lightbox opens on click
- Download badges show/hide correctly based on null URLs
- Looks correct on a narrow window (mobile simulation)

### Step 4 — Deploy

```
git add website/
git commit -m "Website: add {app_name}"
git push
```

GitHub Actions will deploy automatically. Check the Actions tab to confirm success, then verify at `https://coziahr.com/foreverfree`.

---

## GitHub Actions Deploy Workflow

The deploy workflow is in `.github/workflows/deploy-website.yml`.

It:
1. Triggers on push to `main` when `website/**` changes
2. SSHes into the web host using the `DEPLOY_SSH_KEY` secret
3. Runs `rsync` to copy `website/` to the server's `public_html/foreverfree/`

**Required GitHub Secrets** (one-time setup by user):
| Secret | Value |
|--------|-------|
| `DEPLOY_SSH_HOST` | Your web host's SSH hostname |
| `DEPLOY_SSH_USER` | Your SSH username |
| `DEPLOY_SSH_KEY` | Private key for a deploy-only SSH keypair |

The user generates the deploy keypair with:
```bash
ssh-keygen -t ed25519 -C "github-deploy" -f deploy_key
```
Then adds `deploy_key.pub` to `~/.ssh/authorized_keys` on the server,
and adds the contents of `deploy_key` (private key) as the `DEPLOY_SSH_KEY` GitHub Secret.

---

## HTTPS

The `/foreverfree` subdirectory inherits the SSL certificate of `coziahr.com`.
No extra setup is needed as long as `https://coziahr.com` has a valid certificate.

If HTTPS is not yet enabled on `coziahr.com`:
- Most hosts: cPanel → SSL/TLS → Let's Encrypt → Enable (free, one click)
- VPS: run `certbot --apache` or `certbot --nginx`

---

## Design Reference

> **TODO — Placeholder:** The visual design for this website has not been finalized yet.
> Once the design is agreed upon, document it here:
> - Color palette and typography choices
> - Card layout specifications
> - Lightbox library choice and configuration
> - Screenshot aspect ratio and sizing conventions
> - Hero banner dimensions and placement
> - Mobile breakpoints
> - Any design decisions made and why

For now, see the conversation notes from the initial website design session.

---

## Philosophy

The website reflects the same values as the apps:
- No trackers, no analytics, no ads
- No cookies or local storage (nothing to disclose)
- Fast: static files only, no JS framework
- Works without JS (graceful degradation): cards and links are plain HTML; lightbox is enhancement only
