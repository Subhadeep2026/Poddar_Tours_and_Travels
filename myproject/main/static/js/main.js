/**
 * Poddar Tours & Travels - Global Script
 * Handles dynamic component loading and scroll-reveal animations.
 */

const isPageFolder = location.pathname.includes('/pages/');
const componentBasePath = '/static/components/';

// --- Component Loading ---
function loadComponents() {
  const headerElem = document.getElementById('header');
  if (headerElem) {
    fetch(componentBasePath + 'header.html')
      .then(res => res.text())
      .then(data => {
        headerElem.innerHTML = data;
        // rewriteComponentLinks(headerElem);
        highlightActiveLink();
        initReveal();
      })
      .catch(err => console.error('Error loading header:', err));
  }

  const footerElem = document.getElementById('footer');
  if (footerElem) {
    fetch(componentBasePath + 'footer.html')
      .then(res => res.text())
      .then(data => {
        footerElem.innerHTML = data;
        // rewriteComponentLinks(footerElem);
        initReveal();
      })
      .catch(err => console.error('Error loading footer:', err));
  }
}

/* 
function rewriteComponentLinks(container) {
  // This function is for static HTML sites and interferes with Django URLs.
  // It has been disabled to ensure Django's {% url %} tags work correctly.
}
*/

function highlightActiveLink() {
  const currentPath = location.pathname;
  const currentPage = currentPath === '/' ? '/' : currentPath.split('/').pop();
  document.querySelectorAll('nav a, .special-nav a').forEach(link => {
    const href = link.getAttribute('href');
    const linkPage = href === '/' ? '/' : href.split('/').pop();
    link.classList.toggle('active', currentPage === linkPage);
  });
}

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

document.addEventListener('DOMContentLoaded', () => {
  loadComponents();
  initReveal();
  const pageWatcher = new MutationObserver((mutations) => {
    mutations.forEach(m => {
      m.addedNodes.forEach(node => {
        if (node.nodeType === 1) {
          if (node.classList.contains('reveal')) revealObserver.observe(node);
          node.querySelectorAll('.reveal').forEach(el => revealObserver.observe(el));
        }
      });
    });
  });
  pageWatcher.observe(document.body, { childList: true, subtree: true });
});

setInterval(initReveal, 2000);
