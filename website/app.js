import PhotoSwipeLightbox from 'https://cdn.jsdelivr.net/npm/photoswipe@5.4.4/dist/photoswipe-lightbox.esm.min.js';

// ── SVG icons for download badges ────────────────────────
const ANDROID_ICON = `<svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
  <path d="M17.523 15.341a.83.83 0 0 1-.83.83.83.83 0 0 1-.83-.83.83.83 0 0 1 .83-.83.83.83 0 0 1 .83.83zm-9.386 0a.83.83 0 0 1-.83.83.83.83 0 0 1-.83-.83.83.83 0 0 1 .83-.83.83.83 0 0 1 .83.83zM17.7 9.3l1.7-3.1a.35.35 0 0 0-.13-.48.35.35 0 0 0-.48.13l-1.72 3.15A10.7 10.7 0 0 0 12 8.1c-1.82 0-3.53.46-5.07 1.27L5.21 6.12a.35.35 0 0 0-.48-.13.35.35 0 0 0-.13.48L6.3 9.3A9.67 9.67 0 0 0 2.3 17h19.4A9.67 9.67 0 0 0 17.7 9.3z"/>
</svg>`;

const IOS_ICON = `<svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
  <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.8-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
</svg>`;

// ── Build a single app card ───────────────────────────────
function buildCard(app) {
  const card = document.createElement('article');
  card.className = 'app-card';
  card.id = `app-${app.id}`;

  // Header: icon + title + tagline
  const header = document.createElement('div');
  header.className = 'app-card-header';
  header.innerHTML = `
    <img src="${app.id}/icon.png" alt="${app.name} icon" class="app-icon" width="72" height="72">
    <div class="app-title-group">
      <h3 class="app-name">${app.name}</h3>
      <p class="app-tagline">${app.tagline}</p>
    </div>
  `;
  // Prefix icon path with apps/ dir
  header.querySelector('.app-icon').src = `apps/${app.id}/icon.png`;
  card.appendChild(header);

  // Screenshots strip (PhotoSwipe gallery)
  const galleryId = `gallery-${app.id}`;
  const strip = document.createElement('div');
  strip.className = 'app-screenshots';
  strip.id = galleryId;

  app.screenshots.forEach((shot, i) => {
    const link = document.createElement('a');
    link.className = 'screenshot-link';
    link.href = shot.src;
    link.setAttribute('data-pswp-width', shot.w);
    link.setAttribute('data-pswp-height', shot.h);
    link.setAttribute('target', '_blank');

    const img = document.createElement('img');
    img.src = shot.src;
    img.alt = shot.alt || `Screenshot ${i + 1}`;
    img.loading = 'lazy';
    img.width = 110;

    link.appendChild(img);
    strip.appendChild(link);
  });
  card.appendChild(strip);

  // Description
  const desc = document.createElement('div');
  desc.className = 'app-description';
  const paragraphs = app.description.split('\n\n');
  desc.innerHTML = paragraphs.map(p => `<p>${p.trim()}</p>`).join('');
  card.appendChild(desc);

  // Download badges
  const badges = document.createElement('div');
  badges.className = 'app-badges';

  if (app.androidUrl) {
    const a = document.createElement('a');
    a.className = 'badge badge-android';
    a.href = app.androidUrl;
    a.target = '_blank';
    a.rel = 'noopener';
    a.innerHTML = `${ANDROID_ICON} <span>Google Play</span>`;
    badges.appendChild(a);
  }

  if (app.iosUrl) {
    const a = document.createElement('a');
    a.className = 'badge badge-ios';
    a.href = app.iosUrl;
    a.target = '_blank';
    a.rel = 'noopener';
    a.innerHTML = `${IOS_ICON} <span>App Store</span>`;
    badges.appendChild(a);
  } else {
    const span = document.createElement('span');
    span.className = 'badge badge-coming-soon';
    span.textContent = 'iOS — coming soon';
    badges.appendChild(span);
  }

  card.appendChild(badges);
  return card;
}

// ── Render all app cards ──────────────────────────────────
function renderApps() {
  const list = document.getElementById('app-list');
  if (!list) return;

  APPS_DATA.apps.forEach(app => list.appendChild(buildCard(app)));

  // ── Init PhotoSwipe for every gallery on the page ─────
  const lightbox = new PhotoSwipeLightbox({
    gallery: '.app-screenshots',
    children: 'a.screenshot-link',
    showHideAnimationType: 'zoom',
    pswpModule: () => import('https://cdn.jsdelivr.net/npm/photoswipe@5.4.4/dist/photoswipe.esm.min.js'),
  });
  lightbox.init();
}

renderApps();
