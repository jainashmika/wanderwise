/* ============================================================
   WanderWise  -  Global Animation Engine
   Injects: particles, cursor glow, floating orbs, typewriter,
            card tilt, scroll reveals, animated counters
   Include at bottom of <body> on every page.
   ============================================================ */

(function () {
  'use strict';

  /* ── 1. FLOATING PARTICLE CANVAS ── */
  function initParticles(heroSelector) {
    const hero = document.querySelector(heroSelector || '.hero');
    if (!hero) return;

    const canvas = document.createElement('canvas');
    canvas.style.cssText = `
      position:absolute;inset:0;width:100%;height:100%;
      pointer-events:none;z-index:1;opacity:0.55;
    `;
    hero.style.position = 'relative';
    hero.insertBefore(canvas, hero.firstChild);

    const ctx = canvas.getContext('2d');
    let W, H, particles = [];

    const COLORS = ['#0CD4DE','#0096C7','#0ECDD6','#38BDF8','#7DD3FC','#ffffff'];

    function resize() {
      W = canvas.width  = hero.offsetWidth;
      H = canvas.height = hero.offsetHeight;
    }

    class Particle {
      constructor() { this.reset(); }
      reset() {
        this.x     = Math.random() * W;
        this.y     = Math.random() * H;
        this.r     = Math.random() * 3 + 1;
        this.dx    = (Math.random() - 0.5) * 0.6;
        this.dy    = (Math.random() - 0.5) * 0.6 - 0.3;
        this.life  = Math.random();
        this.max   = 0.6 + Math.random() * 0.4;
        this.color = COLORS[Math.floor(Math.random() * COLORS.length)];
      }
    }

    for (let i = 0; i < 80; i++) particles.push(new Particle());

    function draw() {
      ctx.clearRect(0, 0, W, H);
      particles.forEach(p => {
        p.x += p.dx;
        p.y += p.dy;
        p.life += 0.004;
        if (p.life > p.max || p.x < 0 || p.x > W || p.y < 0) p.reset();

        const alpha = Math.sin((p.life / p.max) * Math.PI) * 0.8;
        ctx.beginPath();
        ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
        ctx.fillStyle = p.color + Math.round(alpha * 255).toString(16).padStart(2,'0');
        ctx.fill();
      });
      requestAnimationFrame(draw);
    }

    resize();
    draw();
    window.addEventListener('resize', resize);
  }

  /* ── 2. CURSOR GLOW ── */
  function initCursorGlow() {
    const glow = document.createElement('div');
    glow.style.cssText = `
      position:fixed;width:320px;height:320px;border-radius:50%;
      background:radial-gradient(circle,rgba(12,212,222,0.15) 0%,rgba(0,150,199,0.07) 50%,transparent 70%);
      pointer-events:none;z-index:9999;
      transform:translate(-50%,-50%);transition:opacity 0.3s;
      mix-blend-mode:screen;
    `;
    document.body.appendChild(glow);

    let mx = -500, my = -500;
    document.addEventListener('mousemove', e => { mx = e.clientX; my = e.clientY; });

    function tick() {
      glow.style.left = mx + 'px';
      glow.style.top  = my + 'px';
      requestAnimationFrame(tick);
    }
    tick();
  }

  /* ── 3. FLOATING BACKGROUND ORBS ── */
  function initOrbs() {
    const orbs = [
      { color:'rgba(12,212,222,0.18)',  size:600, x:10,  y:20,  dur:14 },
      { color:'rgba(0,150,199,0.15)',   size:500, x:70,  y:60,  dur:18 },
      { color:'rgba(14,205,214,0.12)',  size:450, x:40,  y:80,  dur:12 },
      { color:'rgba(56,189,248,0.10)',  size:350, x:85,  y:15,  dur:20 },
    ];

    const wrap = document.createElement('div');
    wrap.style.cssText = 'position:fixed;inset:0;pointer-events:none;z-index:0;overflow:hidden;';
    document.body.insertBefore(wrap, document.body.firstChild);

    orbs.forEach((o, i) => {
      const el = document.createElement('div');
      el.style.cssText = `
        position:absolute;
        width:${o.size}px;height:${o.size}px;border-radius:50%;
        background:${o.color};filter:blur(80px);
        left:${o.x}%;top:${o.y}%;
        transform:translate(-50%,-50%);
        animation:orbFloat${i} ${o.dur}s ease-in-out infinite alternate;
      `;
      wrap.appendChild(el);

      const style = document.createElement('style');
      style.textContent = `
        @keyframes orbFloat${i} {
          0%   { transform:translate(-50%,-50%) scale(1); }
          50%  { transform:translate(-50%,-50%) scale(1.15) translate(${30*(i%2?1:-1)}px,${20*(i%2?-1:1)}px); }
          100% { transform:translate(-50%,-50%) scale(0.9) translate(${-20*(i%2?1:-1)}px,${30*(i%2?1:-1)}px); }
        }
      `;
      document.head.appendChild(style);
    });
  }

  /* ── 4. TYPEWRITER HERO TEXT ── */
  function initTypewriter(selector, words, interval) {
    const el = document.querySelector(selector);
    if (!el) return;

    const span = document.createElement('span');
    span.style.cssText = `
      background:linear-gradient(135deg,#0CD4DE,#0284C7,#38BDF8);
      -webkit-background-clip:text;-webkit-text-fill-color:transparent;
      background-clip:text;background-size:200%;
      animation:gradShift 3s ease infinite;
    `;

    const cursor = document.createElement('span');
    cursor.textContent = '|';
    cursor.style.cssText = `
      color:#0CD4DE;-webkit-text-fill-color:#0CD4DE;
      animation:blink 0.8s step-end infinite;margin-left:2px;
    `;

    const style = document.createElement('style');
    style.textContent = `
      @keyframes blink { 0%,100%{opacity:1} 50%{opacity:0} }
      @keyframes gradShift { 0%{background-position:0%} 100%{background-position:200%} }
    `;
    document.head.appendChild(style);

    el.appendChild(span);
    el.appendChild(cursor);

    let wi = 0, ci = 0, deleting = false;

    function type() {
      const word = words[wi];
      if (!deleting) {
        span.textContent = word.slice(0, ++ci);
        if (ci === word.length) { deleting = true; setTimeout(type, interval || 1200); return; }
      } else {
        span.textContent = word.slice(0, --ci);
        if (ci === 0) { deleting = false; wi = (wi + 1) % words.length; }
      }
      setTimeout(type, deleting ? 45 : 85);
    }
    type();
  }

  /* ── 5. CARD MAGNETIC TILT ── */
  function initCardTilt(selector) {
    document.querySelectorAll(selector).forEach(card => {
      card.addEventListener('mousemove', e => {
        const r = card.getBoundingClientRect();
        const x = (e.clientX - r.left) / r.width  - 0.5;
        const y = (e.clientY - r.top)  / r.height - 0.5;
        card.style.transform = `perspective(600px) rotateY(${x*10}deg) rotateX(${-y*10}deg) scale(1.03)`;
        card.style.transition = 'transform 0.1s ease';
      });
      card.addEventListener('mouseleave', () => {
        card.style.transform = '';
        card.style.transition = 'transform 0.4s ease';
      });
    });
  }

  /* ── 6. SCROLL REVEAL ── */
  function initScrollReveal() {
    const style = document.createElement('style');
    style.textContent = `
      .sr { opacity:0; transform:translateY(32px); transition:opacity 0.7s ease, transform 0.7s ease; }
      .sr.visible { opacity:1; transform:translateY(0); }
      .sr-left  { opacity:0; transform:translateX(-40px); transition:opacity 0.7s ease, transform 0.7s ease; }
      .sr-left.visible  { opacity:1; transform:translateX(0); }
      .sr-right { opacity:0; transform:translateX(40px);  transition:opacity 0.7s ease, transform 0.7s ease; }
      .sr-right.visible { opacity:1; transform:translateX(0); }
    `;
    document.head.appendChild(style);

    const obs = new IntersectionObserver(entries => {
      entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add('visible'); obs.unobserve(e.target); }});
    }, { threshold: 0.12 });

    document.querySelectorAll('.sr,.sr-left,.sr-right').forEach(el => obs.observe(el));
  }

  /* ── 7. ANIMATED COUNTERS ── */
  function initCounters() {
    const obs = new IntersectionObserver(entries => {
      entries.forEach(e => {
        if (!e.isIntersecting) return;
        const el = e.target;
        const target = parseFloat(el.dataset.count);
        const suffix = el.dataset.suffix || '';
        const dec    = el.dataset.dec ? parseInt(el.dataset.dec) : 0;
        let start = 0, dur = 1800, startTime = null;
        function step(ts) {
          if (!startTime) startTime = ts;
          const prog = Math.min((ts - startTime) / dur, 1);
          const ease = 1 - Math.pow(1 - prog, 3);
          el.textContent = (start + (target - start) * ease).toFixed(dec) + suffix;
          if (prog < 1) requestAnimationFrame(step);
        }
        requestAnimationFrame(step);
        obs.unobserve(el);
      });
    }, { threshold: 0.5 });

    document.querySelectorAll('[data-count]').forEach(el => obs.observe(el));
  }

  /* ── 8. PULSE RING on CTA buttons ── */
  function initPulseRings() {
    const style = document.createElement('style');
    style.textContent = `
      .pulse-ring {
        position:relative;overflow:visible;
      }
      .pulse-ring::before {
        content:'';position:absolute;inset:-4px;border-radius:inherit;
        border:2px solid rgba(12,212,222,0.5);
        animation:pulseRing 2s ease-out infinite;
      }
      @keyframes pulseRing {
        0%   { transform:scale(1);   opacity:0.8; }
        100% { transform:scale(1.18);opacity:0; }
      }
      .float-anim { animation:floatY 4s ease-in-out infinite; }
      @keyframes floatY { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-10px)} }

      .shimmer-text {
        background:linear-gradient(90deg,#0CD4DE 0%,#0284C7 30%,#38BDF8 60%,#0CD4DE 100%);
        background-size:300%;
        -webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;
        animation:shimmerText 4s linear infinite;
      }
      @keyframes shimmerText { 0%{background-position:0%} 100%{background-position:300%} }

      .glow-card:hover {
        box-shadow:0 0 0 1px rgba(12,212,222,0.3),0 20px 60px rgba(12,212,222,0.2),0 0 80px rgba(0,150,199,0.1) !important;
      }

      .badge-pulse {
        display:inline-flex;align-items:center;gap:6px;
      }
      .badge-pulse .dot {
        width:8px;height:8px;border-radius:50%;background:#4ADE80;
        animation:dotPulse 1.5s ease infinite;
      }
      @keyframes dotPulse { 0%,100%{transform:scale(1);opacity:1} 50%{transform:scale(1.6);opacity:0.6} }

      .wave-divider svg { display:block; }

      /* rainbow border on hover for cards */
      .rainbow-hover {
        position:relative;border-radius:inherit;
      }
      .rainbow-hover::after {
        content:'';position:absolute;inset:-2px;border-radius:inherit;
        background:linear-gradient(135deg,#0CD4DE,#0096C7,#38BDF8,#0ECDD6,#0284C7,#0CD4DE);
        background-size:400%;z-index:-1;opacity:0;
        animation:rainbowBG 4s linear infinite;
        transition:opacity 0.3s;
      }
      .rainbow-hover:hover::after { opacity:1; }
      @keyframes rainbowBG { 0%{background-position:0%} 100%{background-position:400%} }
    `;
    document.head.appendChild(style);
  }

  /* ── 9. GRADIENT TEXT CYCLE on section headings ── */
  function initGradientHeadings() {
    const style = document.createElement('style');
    style.textContent = `
      .grad-cycle {
        background:linear-gradient(135deg,#0CD4DE,#0096C7,#38BDF8,#0CD4DE);
        background-size:300%;
        -webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;
        animation:gradCycle 6s ease infinite;
      }
      @keyframes gradCycle { 0%,100%{background-position:0%} 50%{background-position:200%} }
    `;
    document.head.appendChild(style);
  }

  /* ── 10. STAR RATING SPARKLE ── */
  function initStarSparkle() {
    document.querySelectorAll('.star-sparkle').forEach(el => {
      el.addEventListener('mouseenter', () => {
        el.querySelectorAll('span').forEach((s, i) => {
          setTimeout(() => {
            s.style.transform = 'scale(1.4) rotate(20deg)';
            s.style.transition = 'transform 0.2s ease';
            setTimeout(() => { s.style.transform = ''; }, 300);
          }, i * 60);
        });
      });
    });
  }

  /* ── INIT ALL ── */
  document.addEventListener('DOMContentLoaded', function () {
    initParticles('.hero');
    initCursorGlow();
    initOrbs();
    initScrollReveal();
    initCounters();
    initPulseRings();
    initGradientHeadings();
    initStarSparkle();

    // typewriter  -  only if target element exists
    const tw = document.getElementById('typewriter-target');
    if (tw) {
      initTypewriter('#typewriter-target', [
        'India',
        'Goa',
        'Manali',
        'Jaipur',
        'Kerala',
        'Ladakh',
        'Alleppey',
        'Munnar',
        'Rishikesh',
        'Shimla',
        'Udaipur',
        'Darjeeling',
        'Coorg',
        'Ooty',
        'Varanasi',
        'Agra',
        'Mysore',
        'Hampi',
      ]);
    }

    // card tilt on package + destination cards
    setTimeout(() => {
      initCardTilt('.pkg-card, .dest-card, .spot-card, .hotel-card');
    }, 800);
  });

})();
