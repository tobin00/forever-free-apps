const SUPABASE_URL = "https://vdpasrxiwsqziwakqbpa.supabase.co";
const SUPABASE_KEY = "sb_publishable_OlI76P8vdYbmFRoy3bciOQ_d6tVMa2x";
const client = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY, {
  auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true }
});

const authPanel = document.querySelector("#auth-panel");
const editor = document.querySelector("#editor");
const authStatus = document.querySelector("#auth-status");
const editorStatus = document.querySelector("#editor-status");
const accountName = document.querySelector("#account-name");
const signOutButton = document.querySelector("#sign-out");
const projectList = document.querySelector("#project-list");
const template = document.querySelector("#project-template");
const uploadForm = document.querySelector("#upload-form");
const uploadStatus = document.querySelector("#upload-status");
const uploadResult = document.querySelector("#upload-result");
const uploadedPath = document.querySelector("#uploaded-path");
let projects = [];
let accessToken = null;

function setStatus(element, message, kind = "") {
  element.textContent = message;
  element.className = `status ${kind}`.trim();
}

async function api(path = "?admin=1", options = {}) {
  const response = await fetch(`../api/projects.php${path}`, {
    ...options,
    headers: {
      Accept: "application/json",
      Authorization: `Bearer ${accessToken}`,
      "X-Ff-Auth": `Bearer ${accessToken}`,
      ...(options.body ? { "Content-Type": "application/json" } : {}),
      ...(options.headers || {})
    }
  });
  const data = await response.json().catch(() => ({}));
  if (!response.ok) throw new Error(data.error || "Something went wrong.");
  return data;
}

function readCard(card) {
  const value = (name) => card.querySelector(`[name="${name}"]`).value.trim();
  return {
    id: value("id"), name: value("name"), type: value("type"),
    description: value("description"), url: value("url"), mediaStyle: value("mediaStyle"),
    image: value("image"), imageAlt: value("imageAlt"), image2: value("image2"),
    image2Alt: value("image2Alt"), accent: value("accent"),
    published: card.querySelector('[name="published"]').checked,
    featured: card.querySelector('[name="featured"]').checked
  };
}

function collectProjects() {
  return [...projectList.querySelectorAll(".project-editor-card")].map(readCard);
}

function refreshCards() {
  const cards = [...projectList.children];
  cards.forEach((card, index) => {
    card.querySelector(".card-number").textContent = `${index + 1}. ${card.querySelector('[name="name"]').value || "New project"}`;
    card.querySelector(".move-up").disabled = index === 0;
    card.querySelector(".move-down").disabled = index === cards.length - 1;
  });
}

function addCard(project = {}) {
  const card = template.content.firstElementChild.cloneNode(true);
  const fields = ["id", "name", "type", "description", "url", "mediaStyle", "image", "imageAlt", "image2", "image2Alt", "accent"];
  fields.forEach((name) => { if (project[name] != null) card.querySelector(`[name="${name}"]`).value = project[name]; });
  if (!project.mediaStyle) card.querySelector('[name="mediaStyle"]').value = "cover";
  card.querySelector('[name="published"]').checked = project.published ?? true;
  const featured = card.querySelector('[name="featured"]');
  featured.checked = Boolean(project.featured);
  featured.name = "featured";
  featured.addEventListener("change", () => {
    if (featured.checked) projectList.querySelectorAll('[name="featured"]').forEach((input) => { if (input !== featured) input.checked = false; });
  });
  card.querySelectorAll("input, textarea, select").forEach((field) => field.addEventListener("input", refreshCards));
  card.querySelector(".move-up").addEventListener("click", () => { if (card.previousElementSibling) projectList.insertBefore(card, card.previousElementSibling); refreshCards(); });
  card.querySelector(".move-down").addEventListener("click", () => { if (card.nextElementSibling) projectList.insertBefore(card.nextElementSibling, card); refreshCards(); });
  card.querySelector(".remove-button").addEventListener("click", () => {
    const name = card.querySelector('[name="name"]').value || "this project";
    if (window.confirm(`Remove ${name}? This takes effect after you save.`)) { card.remove(); refreshCards(); }
  });
  projectList.appendChild(card);
  refreshCards();
  return card;
}

function renderProjects() {
  projectList.replaceChildren();
  projects.forEach(addCard);
}

async function openEditor(session) {
  accessToken = session.access_token;
  setStatus(authStatus, "Checking administrator access…");
  try {
    const data = await api();
    projects = data.projects;
    renderProjects();
    authPanel.hidden = true;
    editor.hidden = false;
    signOutButton.hidden = false;
    const meta = session.user.user_metadata || {};
    accountName.textContent = meta.full_name || meta.name || session.user.email || "Signed in";
  } catch (error) {
    setStatus(authStatus, error.message, "error");
    await client.auth.signOut();
  }
}

document.querySelector("#google-sign-in").addEventListener("click", async () => {
  setStatus(authStatus, "Opening Google sign-in…");
  const { error } = await client.auth.signInWithOAuth({ provider: "google", options: { redirectTo: new URL(".", location.href).href } });
  if (error) setStatus(authStatus, error.message, "error");
});

document.querySelector("#email-form").addEventListener("submit", async (event) => {
  event.preventDefault();
  const email = new FormData(event.currentTarget).get("email");
  setStatus(authStatus, "Sending your sign-in link…");
  const { error } = await client.auth.signInWithOtp({ email, options: { shouldCreateUser: true, emailRedirectTo: new URL(".", location.href).href } });
  setStatus(authStatus, error ? error.message : "Check your email for a sign-in link.", error ? "error" : "success");
});

signOutButton.addEventListener("click", async () => { await client.auth.signOut(); location.replace("./"); });
document.querySelector("#add-project").addEventListener("click", () => { const card = addCard({ accent: "blue", published: false, featured: false }); card.querySelector('[name="name"]').focus(); });

uploadForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  if (!uploadForm.reportValidity()) return;
  const button = document.querySelector("#upload-button");
  const formData = new FormData(uploadForm);
  formData.set("overwrite", document.querySelector("#upload-overwrite").checked ? "1" : "0");
  button.disabled = true;
  uploadResult.hidden = true;
  setStatus(uploadStatus, "Uploading…");
  try {
    const response = await fetch("../api/upload.php", {
      method: "POST",
      headers: { Authorization: `Bearer ${accessToken}`, "X-Ff-Auth": `Bearer ${accessToken}` },
      body: formData
    });
    const data = await response.json().catch(() => ({}));
    if (!response.ok) throw new Error(data.error || "The image could not be uploaded.");
    uploadedPath.value = data.path;
    uploadResult.hidden = false;
    uploadForm.reset();
    setStatus(uploadStatus, `Uploaded ${data.path}`, "success");
  } catch (error) {
    setStatus(uploadStatus, error.message, "error");
  } finally {
    button.disabled = false;
  }
});

document.querySelector("#copy-upload-path").addEventListener("click", async () => {
  await navigator.clipboard.writeText(uploadedPath.value);
  setStatus(uploadStatus, "Path copied.", "success");
});

document.querySelector("#save").addEventListener("click", async () => {
  const forms = [...projectList.querySelectorAll(".project-editor-card")];
  forms.forEach((card) => {
    const secondImage = card.querySelector('[name="image2"]');
    const secondAlt = card.querySelector('[name="image2Alt"]');
    secondAlt.setCustomValidity(secondImage.value.trim() && !secondAlt.value.trim() ? "Describe the second screenshot." : "");
  });
  if (forms.some((card) => ![...card.querySelectorAll("input, textarea, select")].every((field) => field.checkValidity()))) {
    forms.flatMap((card) => [...card.querySelectorAll("input, textarea, select")]).find((field) => !field.checkValidity())?.reportValidity();
    return;
  }
  const next = collectProjects();
  setStatus(editorStatus, "Saving…");
  try {
    const data = await api("", { method: "PUT", body: JSON.stringify({ projects: next }) });
    projects = data.projects;
    renderProjects();
    setStatus(editorStatus, "Saved. The public site is updated.", "success");
  } catch (error) { setStatus(editorStatus, error.message, "error"); }
});

client.auth.getSession().then(({ data }) => {
  if (data.session) openEditor(data.session);
  else setStatus(authStatus, "");
});
