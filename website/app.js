function projectCard(project) {
  const article = document.createElement("article");
  article.className = `project-card accent-${project.accent}${project.featured ? " project-featured" : ""}`;

  const imageLink = document.createElement("a");
  const mediaStyle = project.mediaStyle === "phones" ? "phones" : "cover";
  imageLink.className = `project-visual media-${mediaStyle}`;
  imageLink.href = project.url;
  imageLink.setAttribute("aria-label", `Open ${project.name}`);
  const images = [{ src: project.image, alt: project.imageAlt }];
  if (mediaStyle === "phones" && project.image2) images.push({ src: project.image2, alt: project.image2Alt || "" });
  if (mediaStyle === "phones") {
    const gallery = document.createElement("span");
    gallery.className = `phone-gallery${images.length === 1 ? " single" : ""}`;
    images.forEach(({ src, alt }) => {
      const image = document.createElement("img");
      image.className = "phone-shot";
      image.src = src;
      image.alt = alt;
      image.loading = project.featured ? "eager" : "lazy";
      image.decoding = "async";
      gallery.appendChild(image);
    });
    imageLink.appendChild(gallery);
  } else {
    const image = document.createElement("img");
    image.src = project.image;
    image.alt = project.imageAlt;
    image.loading = project.featured ? "eager" : "lazy";
    image.decoding = "async";
    imageLink.appendChild(image);
  }

  const body = document.createElement("div");
  body.className = "project-body";
  const type = document.createElement("p");
  type.className = "project-type";
  type.textContent = project.type;
  const title = document.createElement("h3");
  const titleLink = document.createElement("a");
  titleLink.href = project.url;
  titleLink.textContent = project.name;
  title.appendChild(titleLink);
  const description = document.createElement("p");
  description.className = "project-description";
  description.textContent = project.description;
  const visit = document.createElement("a");
  visit.className = "project-link";
  visit.href = project.url;
  visit.innerHTML = "Open project <span aria-hidden=\"true\">↗</span>";
  body.append(type, title, description, visit);
  article.append(imageLink, body);
  return article;
}

const grid = document.querySelector("#project-grid");

function renderProjects(projects) {
  if (!grid) return;
  grid.replaceChildren();
  projects.filter((project) => project.published).forEach((project) => grid.appendChild(projectCard(project)));
}

renderProjects(PROJECTS);

fetch("api/projects.php", { headers: { Accept: "application/json" } })
  .then((response) => response.ok ? response.json() : Promise.reject(new Error("catalog unavailable")))
  .then((data) => { if (Array.isArray(data.projects)) renderProjects(data.projects); })
  .catch(() => { /* The bundled catalog remains visible if the API is unavailable. */ });
