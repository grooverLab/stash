// pz.js - zoom + pan for rendered mermaid diagrams. No dependencies.
// Wheel = zoom (cursor-centered), drag = pan, double-click = reset, buttons too.
function attachPanZoom() {
  document.querySelectorAll('.diagram').forEach(function (box) {
    var svg = box.querySelector('svg');
    if (!svg || box.dataset.pz) return;
    box.dataset.pz = '1';

    var inner = document.createElement('div');
    inner.className = 'pz-inner';
    svg.parentNode.insertBefore(inner, svg);
    inner.appendChild(svg);

    var s = 1, tx = 0, ty = 0;
    function render() { inner.style.transform = 'translate(' + tx + 'px,' + ty + 'px) scale(' + s + ')'; }

    // initial fit: scale to the container width (capped) and center horizontally
    var bw = box.clientWidth, sw = svg.getBoundingClientRect().width || bw;
    s = Math.min(1.6, Math.max(0.3, (bw - 64) / sw));
    tx = Math.max(0, (bw - sw * s) / 2);
    ty = 8;
    var fit = { s: s, tx: tx, ty: ty };
    render();

    var bar = document.createElement('div');
    bar.className = 'pz-bar';
    [['+', 1.25], ['−', 0.8], ['reset', 0]].forEach(function (b) {
      var el = document.createElement('button');
      el.textContent = b[0];
      el.onclick = function () {
        if (b[1] === 0) { s = fit.s; tx = fit.tx; ty = fit.ty; }
        else { s = Math.min(6, Math.max(0.2, s * b[1])); }
        render();
      };
      bar.appendChild(el);
    });
    box.appendChild(bar);

    box.addEventListener('wheel', function (e) {
      e.preventDefault();
      var r = box.getBoundingClientRect();
      var mx = e.clientX - r.left, my = e.clientY - r.top;
      var f = e.deltaY < 0 ? 1.12 : 1 / 1.12;
      var ns = Math.min(6, Math.max(0.2, s * f));
      // keep the point under the cursor fixed while zooming
      tx = mx - (mx - tx) * (ns / s);
      ty = my - (my - ty) * (ns / s);
      s = ns;
      render();
    }, { passive: false });

    var drag = null;
    box.addEventListener('pointerdown', function (e) {
      if (e.target.closest('.pz-bar')) return;
      drag = { x: e.clientX - tx, y: e.clientY - ty };
      box.setPointerCapture(e.pointerId);
      box.classList.add('grabbing');
    });
    box.addEventListener('pointermove', function (e) {
      if (!drag) return;
      tx = e.clientX - drag.x; ty = e.clientY - drag.y; render();
    });
    ['pointerup', 'pointercancel'].forEach(function (ev) {
      box.addEventListener(ev, function () { drag = null; box.classList.remove('grabbing'); });
    });
    box.addEventListener('dblclick', function () { s = fit.s; tx = fit.tx; ty = fit.ty; render(); });
  });
}
