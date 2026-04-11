/**
 * Poddar Tours & Travels - Global Script
 * Handles dynamic component loading and scroll-reveal animations.
 */

// --- Component Loading ---
function loadComponents() {
  // Load Header
  const headerElem = document.getElementById("header");
  if (headerElem) {
    fetch("header.html")
      .then(res => res.text())
      .then(data => {
        headerElem.innerHTML = data;
        highlightActiveLink();
        initReveal(); // Re-initialize animations for new elements
      })
      .catch(err => console.error("Error loading header:", err));
  }

  // Load Footer
  const footerElem = document.getElementById("footer");
  if (footerElem) {
    fetch("footer.html")
      .then(res => res.text())
      .then(data => {
        footerElem.innerHTML = data;
        initReveal(); // Re-initialize animations for footer elements
      })
      .catch(err => console.error("Error loading footer:", err));
  }
}

function highlightActiveLink() {
  const currentPage = location.pathname.split("/").pop() || "Home.html";
  document.querySelectorAll("nav a, .special-nav a").forEach(link => {
    if (link.getAttribute("href") === currentPage) {
      link.classList.add("active");
    } else {
      link.classList.remove("active");
    }
  });
}

// --- Scroll Reveal Animation ---
const observerOptions = {
  threshold: 0.1,
  rootMargin: '0px 0px -50px 0px'
};

const revealObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('active');
    }
  });
}, observerOptions);

function initReveal() {
  const revealElements = document.querySelectorAll('.reveal');
  revealElements.forEach(el => revealObserver.observe(el));
}

// --- Initialization ---
document.addEventListener("DOMContentLoaded", () => {
  loadComponents();
  
  // Initial reveal for elements already on the page
  initReveal();

  // Watch for any future dynamic content injections
  const pageWatcher = new MutationObserver((mutations) => {
    mutations.forEach(m => {
      m.addedNodes.forEach(node => {
        if (node.nodeType === 1) { // Element node
          if (node.classList.contains('reveal')) revealObserver.observe(node);
          node.querySelectorAll('.reveal').forEach(el => revealObserver.observe(el));
        }
      });
    });
  });

  pageWatcher.observe(document.body, { childList: true, subtree: true });
});

// Backup interval to catch any missed elements (e.g., slow loading components)
setInterval(initReveal, 2000);
