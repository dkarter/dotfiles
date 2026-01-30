// ==UserScript==
// @name         Graphite <-> GitHub PR Links
// @namespace    pdq
// @version      1.0.0
// @description  Add cross-links between Graphite and GitHub PR pages
// @match        https://app.graphite.com/github/pr/pdq/*/*
// @match        https://github.com/pdq/*/pull/*
// @grant        GM_addStyle
// ==/UserScript==

(function () {
  'use strict';

  const GH_HOST = 'https://github.com';
  const GRAPHITE_HOST = 'https://app.graphite.com';

  function addLink(label, href) {
    if (!href) return;
    const existing = document.querySelector(`[data-graphite-link="${label}"]`);
    if (existing) return;

    const link = document.createElement('a');
    link.textContent = label;
    link.href = href;
    link.target = '_blank';
    link.rel = 'noopener noreferrer';
    link.dataset.graphiteLink = label;
    link.className = 'gm-graphite-link';

    const container = document.createElement('div');
    container.className = 'gm-graphite-container';
    container.appendChild(link);

    document.body.appendChild(container);
  }

  function onGraphite() {
    const parts = window.location.pathname.split('/').filter(Boolean);
    // /github/pr/:org/:repo/:number(/:slug?)
    if (parts.length < 5) return;
    const org = parts[2];
    const repo = parts[3];
    const number = parts[4];
    const ghUrl = `${GH_HOST}/${org}/${repo}/pull/${number}`;
    addLink('Open in GitHub', ghUrl);
  }

  function onGithub() {
    const parts = window.location.pathname.split('/').filter(Boolean);
    // /:org/:repo/pull/:number
    if (parts.length < 4) return;
    if (parts[2] !== 'pull') return;
    const org = parts[0];
    const repo = parts[1];
    const number = parts[3];
    const graphiteUrl = `${GRAPHITE_HOST}/github/pr/${org}/${repo}/${number}`;
    addLink('Open in Graphite', graphiteUrl);
  }

  GM_addStyle(`
    .gm-graphite-container {
      position: absolute;
      z-index: 99999;
      background: #0f172a;
      border: 1px solid #1e293b;
      border-radius: 10px;
      padding: 8px 12px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.25);
    }
    .gm-graphite-link {
      color: #e2e8f0;
      font: 600 13px/1.2 "IBM Plex Sans", "Segoe UI", sans-serif;
      text-decoration: none;
    }
    .gm-graphite-link:hover {
      text-decoration: underline;
    }
  `);

  if (location.host === 'app.graphite.com') {
    GM_addStyle(`
    .gm-graphite-container {
      top: 6px;
      right: 332px;
      padding: 6px 10px;
    }
    `);
    onGraphite();
  } else if (location.host === 'github.com') {
    GM_addStyle(`
    .gm-graphite-container {
      top: 12px;
      left: 240px;
    }
    `);
    onGithub();
  }
})();
