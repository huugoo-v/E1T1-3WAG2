// Taulak mugikorrean txartel gisa erakusteko: gelaxka bakoitzari bere zutabearen izena ematen dio
// (CSS-ak data-label erabiltzen du). Taulak JavaScript bidez betetzen direnez, aldaketak behatzen ditu.
(function () {
  function etiketatu() {
    document.querySelectorAll("table").forEach((taula) => {
      const izenak = [...taula.querySelectorAll("thead th")].map((th) => th.textContent.trim());
      taula.querySelectorAll("tbody tr").forEach((tr) => {
        [...tr.children].forEach((td, i) => {
          if (izenak[i] && td.dataset.label !== izenak[i]) td.dataset.label = izenak[i];
        });
      });
    });
  }

  let itxaroten = false;
  function programatu() {
    if (itxaroten) return;
    itxaroten = true;
    requestAnimationFrame(() => {
      itxaroten = false;
      etiketatu();
    });
  }

  document.addEventListener("DOMContentLoaded", () => {
    etiketatu();
    new MutationObserver(programatu).observe(document.body, { childList: true, subtree: true });
  });
})();
