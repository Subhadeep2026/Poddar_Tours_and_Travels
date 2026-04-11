/**
 * Poddar Tours & Travels - Global Script
 * Handles dynamic component loading and scroll-reveal animations.
 */

const isPageFolder = location.pathname.includes('/pages/');
const componentBasePath = isPageFolder ? '../' : '';

// --- Component Loading ---
function loadComponents() {
  const headerElem = document.getElementById('header');
  if (headerElem) {
    fetch(componentBasePath + 'components/header.html')
      .then(res => res.text())
      .then(data => {
        headerElem.innerHTML = data;
        rewriteComponentLinks(headerElem);
        highlightActiveLink();
        initReveal();
      })
      .catch(err => console.error('Error loading header:', err));
  }

  const footerElem = document.getElementById('footer');
  if (footerElem) {
    fetch(componentBasePath + 'components/footer.html')
      .then(res => res.text())
      .then(data => {
        footerElem.innerHTML = data;
        rewriteComponentLinks(footerElem);
        initReveal();
      })
      .catch(err => console.error('Error loading footer:', err));
  }
}

function rewriteComponentLinks(container) {
  container.querySelectorAll('a, img, link, script').forEach(el => {
    ['href', 'src'].forEach(attr => {
      if (!el.hasAttribute(attr)) return;
      const value = el.getAttribute(attr);
      if (!value || value.startsWith('http') || value.startsWith('//') || value.startsWith('#') || value.startsWith('/') || value.startsWith('mailto:') || value.startsWith('tel:') || value.startsWith('../')) return;
      if (attr === 'href' && value.endsWith('.html')) {
        if (value === 'index.html') {
          el.setAttribute(attr, isPageFolder ? '../index.html' : 'index.html');
        } else {
          el.setAttribute(attr, isPageFolder ? value : 'pages/' + value);
        }
        return;
      }
      if (isPageFolder) {
        el.setAttribute(attr, '../' + value);
      }
    });
  });
}

function highlightActiveLink() {
  const currentPage = location.pathname.split('/').pop() || 'index.html';
  document.querySelectorAll('nav a, .special-nav a').forEach(link => {
    link.classList.toggle('active', link.getAttribute('href') === currentPage);
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
