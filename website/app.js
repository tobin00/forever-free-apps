// App catalog data is loaded via apps-data.js (plain <script> tag — works on file://)

// ── SVG icons ─────────────────────────────────────────────
const ANDROID_ICON = `<svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true" width="20" height="20">
  <path d="M17.523 15.341a.83.83 0 0 1-.83.83.83.83 0 0 1-.83-.83.83.83 0 0 1 .83-.83.83.83 0 0 1 .83.83zm-9.386 0a.83.83 0 0 1-.83.83.83.83 0 0 1-.83-.83.83.83 0 0 1 .83-.83.83.83 0 0 1 .83.83zM17.7 9.3l1.7-3.1a.35.35 0 0 0-.13-.48.35.35 0 0 0-.48.13l-1.72 3.15A10.7 10.7 0 0 0 12 8.1c-1.82 0-3.53.46-5.07 1.27L5.21 6.12a.35.35 0 0 0-.48-.13.35.35 0 0 0-.13.48L6.3 9.3A9.67 9.67 0 0 0 2.3 17h19.4A9.67 9.67 0 0 0 17.7 9.3z"/>
</svg>`;

const IOS_ICON = `<svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true" width="20" height="20">
  <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.8-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
</svg>`;

// ── Lightbox ──────────────────────────────────────────────
// A self-contained image lightbox. No external dependencies.
// Works on file://, http://, and https://.

var lightboxOverlay = null;
var lightboxImg = null;
var lightboxImages = [];  // { src, alt } for the current gallery
var lightboxIndex = 0;

function createLightbox() {
  if (lightboxOverlay) return;

  lightboxOverlay = document.createElement('div');
  lightboxOverlay.id = 'lightbox';
  lightboxOverlay.setAttribute('role', 'dialog');
  lightboxOverlay.setAttribute('aria-modal', 'true');
  lightboxOverlay.setAttribute('aria-label', 'Screenshot viewer');
  lightboxOverlay.style.cssText = [
    'display:none', 'position:fixed', 'inset:0', 'z-index:9999',
    'background:rgba(0,0,0,0.92)', 'align-items:center', 'justify-content:center',
    'cursor:zoom-out'
  ].join(';');

  lightboxImg = document.createElement('img');
  lightboxImg.style.cssText = [
    'max-width:90vw', 'max-height:90vh', 'object-fit:contain',
    'border-radius:8px', 'box-shadow:0 8px 40px rgba(0,0,0,0.6)',
    'cursor:default', 'user-select:none'
  ].join(';');
  lightboxImg.addEventListener('click', function(e) { e.stopPropagation(); });

  var closeBtn = document.createElement('button');
  closeBtn.innerHTML = '&times;';
  closeBtn.setAttribute('aria-label', 'Close');
  closeBtn.style.cssText = [
    'position:absolute', 'top:16px', 'right:20px',
    'background:none', 'border:none', 'color:#fff', 'font-size:2.2rem',
    'cursor:pointer', 'line-height:1', 'padding:4px 10px', 'opacity:0.8'
  ].join(';');
  closeBtn.addEventListener('click', closeLightbox);

  var prevBtn = makeLightboxNavBtn('&#8249;', 'Previous screenshot', 'left:16px', function() { showLightboxAt(lightboxIndex - 1); });
  var nextBtn = makeLightboxNavBtn('&#8250;', 'Next screenshot', 'right:16px', function() { showLightboxAt(lightboxIndex + 1); });

  var counter = document.createElement('div');
  counter.id = 'lightbox-counter';
  counter.style.cssText = [
    'position:absolute', 'bottom:20px', 'left:50%', 'transform:translateX(-50%)',
    'color:rgba(255,255,255,0.7)', 'font:500 0.9rem/1 Inter,sans-serif', 'letter-spacing:0.05em'
  ].join(';');

  lightboxOverlay.appendChild(lightboxImg);
  lightboxOverlay.appendChild(closeBtn);
  lightboxOverlay.appendChild(prevBtn);
  lightboxOverlay.appendChild(nextBtn);
  lightboxOverlay.appendChild(counter);
  lightboxOverlay.addEventListener('click', closeLightbox);

  document.body.appendChild(lightboxOverlay);

  document.addEventListener('keydown', function(e) {
    if (lightboxOverlay.style.display === 'none') return;
    if (e.key === 'Escape') closeLightbox();
    if (e.key === 'ArrowLeft')  showLightboxAt(lightboxIndex - 1);
    if (e.key === 'ArrowRight') showLightboxAt(lightboxIndex + 1);
  });
}

function makeLightboxNavBtn(html, label, posStyle, onClick) {
  var btn = document.createElement('button');
  btn.innerHTML = html;
  btn.setAttribute('aria-label', label);
  btn.style.cssText = [
    'position:absolute', 'top:50%', 'transform:translateY(-50%)',
    posStyle, 'background:rgba(255,255,255,0.15)', 'border:none',
    'color:#fff', 'font-size:2.8rem', 'cursor:pointer', 'border-radius:50%',
    'width:52px', 'height:52px', 'display:flex', 'align-items:center',
    'justify-content:center', 'padding-bottom:3px', 'transition:background 0.15s'
  ].join(';');
  btn.addEventListener('mouseenter', function() { this.style.background = 'rgba(255,255,255,0.28)'; });
  btn.addEventListener('mouseleave', function() { this.style.background = 'rgba(255,255,255,0.15)'; });
  btn.addEventListener('click', function(e) { e.stopPropagation(); onClick(); });
  return btn;
}

function openLightbox(images, startIndex) {
  createLightbox();
  lightboxImages = images;
  showLightboxAt(startIndex);
  lightboxOverlay.style.display = 'flex';
  document.body.style.overflow = 'hidden';
}

function showLightboxAt(index) {
  index = (index + lightboxImages.length) % lightboxImages.length;
  lightboxIndex = index;
  lightboxImg.src = lightboxImages[index].src;
  lightboxImg.alt = lightboxImages[index].alt;
  document.getElementById('lightbox-counter').textContent =
    (index + 1) + ' / ' + lightboxImages.length;
  // Hide nav buttons if only one image
  var btns = lightboxOverlay.querySelectorAll('button[aria-label="Previous screenshot"], button[aria-label="Next screenshot"]');
  btns.forEach(function(b) { b.style.display = lightboxImages.length > 1 ? 'flex' : 'none'; });
}

function closeLightbox() {
  if (!lightboxOverlay) return;
  lightboxOverlay.style.display = 'none';
  document.body.style.overflow = '';
}

// ── Build a single app card ───────────────────────────────
function buildCard(app) {
  var card = document.createElement('article');
  card.className = 'app-card';
  card.id = 'app-' + app.id;

  // Header: icon + title + tagline
  var header = document.createElement('div');
  header.className = 'app-card-header';
  header.innerHTML =
    '<img src="apps/' + app.id + '/icon.png" alt="' + app.name + ' icon" class="app-icon" width="72" height="72">' +
    '<div class="app-title-group">' +
      '<h3 class="app-name">' + app.name + '</h3>' +
      '<p class="app-tagline">' + app.tagline + '</p>' +
    '</div>';
  card.appendChild(header);

  // Screenshots strip
  var strip = document.createElement('div');
  strip.className = 'app-screenshots';

  var images = app.screenshots.map(function(s) { return { src: s.src, alt: s.alt }; });

  app.screenshots.forEach(function(shot, i) {
    var link = document.createElement('a');
    link.className = 'screenshot-link';
    link.href = '#';
    link.setAttribute('aria-label', shot.alt);
    link.addEventListener('click', function(e) {
      e.preventDefault();
      openLightbox(images, i);
    });

    var img = document.createElement('img');
    img.src = shot.src;
    img.alt = shot.alt;
    img.loading = 'lazy';
    img.width = 110;

    link.appendChild(img);
    strip.appendChild(link);
  });
  card.appendChild(strip);

  // Description
  var desc = document.createElement('div');
  desc.className = 'app-description';
  desc.innerHTML = app.description.split('\n\n').map(function(p) {
    return '<p>' + p.trim() + '</p>';
  }).join('');
  card.appendChild(desc);

  // Badges
  var badges = document.createElement('div');
  badges.className = 'app-badges';

  if (app.androidUrl) {
    var a = document.createElement('a');
    a.className = 'badge badge-android';
    a.href = app.androidUrl;
    a.target = '_blank';
    a.rel = 'noopener';
    a.innerHTML = ANDROID_ICON + '<span>Google Play</span>';
    badges.appendChild(a);
  }

  if (app.iosUrl) {
    var b = document.createElement('a');
    b.className = 'badge badge-ios';
    b.href = app.iosUrl;
    b.target = '_blank';
    b.rel = 'noopener';
    b.innerHTML = IOS_ICON + '<span>App Store</span>';
    badges.appendChild(b);
  } else {
    var s = document.createElement('span');
    s.className = 'badge badge-coming-soon';
    s.textContent = 'iOS — coming soon';
    badges.appendChild(s);
  }

  card.appendChild(badges);
  return card;
}

// ── Render ────────────────────────────────────────────────
function renderApps() {
  var list = document.getElementById('app-list');
  if (!list) return;
  APPS_DATA.apps.forEach(function(app) { list.appendChild(buildCard(app)); });
}

renderApps();
