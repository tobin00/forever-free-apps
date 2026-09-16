function projectCard(project) {
  const article = document.createElement("article");
  article.className = `project-card accent-${project.accent}${project.featured ? " project-featured" : ""}`;

  const imageLink = document.createElement("a");
  imageLink.className = "project-visual";
  imageLink.href = project.url;
  imageLink.setAttribute("aria-label", `Open ${project.name}`);
  const image = document.createElement("img");
  image.src = project.image;
  image.alt = project.imageAlt;
  image.loading = project.featured ? "eager" : "lazy";
  image.decoding = "async";
  imageLink.appendChild(image);

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
if (grid) PROJECTS.filter((project) => project.published).forEach((project) => grid.appendChild(projectCard(project)));
