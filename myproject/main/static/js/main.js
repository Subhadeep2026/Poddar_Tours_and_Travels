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
  initChatbot();
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

// --- Chatbot Logic ---
function initChatbot() {
  const toggleBtn = document.getElementById('chatbot-toggle');
  const closeBtn = document.getElementById('chatbot-close');
  const chatWindow = document.getElementById('chatbot-window');
  const chatForm = document.getElementById('chatbot-form');
  const chatInput = document.getElementById('chatbot-input');
  const chatMessages = document.getElementById('chatbot-messages');

  if (!toggleBtn) return;

  toggleBtn.addEventListener('click', () => {
    chatWindow.classList.toggle('d-none');
    if (!chatWindow.classList.contains('d-none')) {
      chatInput.focus();
    }
  });

  closeBtn.addEventListener('click', () => {
    chatWindow.classList.add('d-none');
  });

  chatForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const message = chatInput.value.trim();
    if (!message) return;

    // Append user message
    appendMessage('user', message);
    chatInput.value = '';

    // Show typing indicator
    const typingId = showTyping();

    try {
      const response = await fetch('/chatbot/', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': getCookie('csrftoken')
        },
        body: JSON.stringify({ message: message })
      });
      
      if (!response.ok) throw new Error('Server unreachable');
      
      const data = await response.json();
      removeTyping(typingId);
      appendMessage('bot', data.reply);
      
      // Ensure status is online
      const dot = document.getElementById('chatbot-status-dot');
      if (dot) {
        dot.classList.remove('status-offline');
        dot.classList.add('status-online');
      }
    } catch (error) {
      removeTyping(typingId);
      console.error('Chatbot error:', error);
      appendMessage('bot', "Sorry, I'm having trouble connecting right now. Please check your internet connection.");
      
      // Switch status to offline
      const dot = document.getElementById('chatbot-status-dot');
      if (dot) {
        dot.classList.remove('status-online');
        dot.classList.add('status-offline');
      }
    }
  });

  function appendMessage(sender, text) {
    const msgDiv = document.createElement('div');
    msgDiv.className = sender === 'user' ? 'user-message' : 'bot-message';
    
    if (sender === 'bot') {
      msgDiv.innerHTML = `
        <div class="d-flex align-items-start">
          <img src="${CHATBOT_ICON_URL}" class="rounded-circle me-2" style="width: 30px; height: 30px; border: 1px solid #ddd;">
          <div class="message-content shadow-sm">${text}</div>
        </div>`;
    } else {
      msgDiv.innerHTML = `<div class="message-content shadow-sm">${text}</div>`;
    }
    
    chatMessages.appendChild(msgDiv);
    chatMessages.scrollTo({ top: chatMessages.scrollHeight, behavior: 'smooth' });
  }

  function showTyping() {
    const id = 'typing-' + Date.now();
    const typingDiv = document.createElement('div');
    typingDiv.id = id;
    typingDiv.className = 'bot-message';
    typingDiv.innerHTML = `
      <div class="d-flex align-items-start">
        <img src="${CHATBOT_ICON_URL}" class="rounded-circle me-2" style="width: 30px; height: 30px; border: 1px solid #ddd;">
        <div class="message-content shadow-sm"><i class="bi bi-three-dots"></i> TripNova AI is typing...</div>
      </div>`;
    chatMessages.appendChild(typingDiv);
    chatMessages.scrollTo({ top: chatMessages.scrollHeight, behavior: 'smooth' });
    return id;
  }

  function removeTyping(id) {
    const el = document.getElementById(id);
    if (el) el.remove();
  }

  function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
      const cookies = document.cookie.split(';');
      for (let i = 0; i < cookies.length; i++) {
        const cookie = cookies[i].trim();
        if (cookie.substring(0, name.length + 1) === (name + '=')) {
          cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
          break;
        }
      }
    }
    return cookieValue;
  }
}

setInterval(initReveal, 2000);

