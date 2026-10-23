// Orri babestuen zaindaria.
// Orriak <html class="babesten"> du: CSS-ak ezkutatuta mantentzen du zerbitzariak
// saioa baliozkotzen duen arte. Script honek huts egiten badu (edo JavaScript
// desgaituta badago), orria ezkutuan geratzen da.
(function () {
  const html = document.documentElement;
  const LOGIN = "login.html";
  const HASIERA = "inbentario.html";

  const joan = (url) => window.location.replace(url);

  const domPrest = new Promise((ebatzi) => {
    if (document.readyState === "loading") {
      document.addEventListener("DOMContentLoaded", ebatzi, { once: true });
    } else {
      ebatzi();
    }
  });

  async function balidatu() {
    try {
      const response = await fetch("../backend/api/sesioaBalidatu.php", {
        credentials: "same-origin",
        cache: "no-store",
      });
      if (!response.ok) return joan(LOGIN);

      const data = await response.json();
      if (!data.success) return joan(LOGIN);

      // Admin rola eskatzen duten orriak (adib. erabiltzaileak)
      if (html.dataset.rol === "admin" && data.rol !== "admin") {
        return joan(HASIERA);
      }

      await domPrest;
      window.saioa = { username: data.username, rol: data.rol };
      if (data.rol !== "admin") {
        document.querySelectorAll("[data-admin]").forEach((el) => el.remove());
      }
      html.classList.remove("babesten");
    } catch (error) {
      joan(LOGIN);
    }
  }

  // "Atzera" botoiarekin orria cache-tik berreskuratzen bada (saioa itxi ondoren), berriz balidatu
  window.addEventListener("pageshow", (e) => {
    if (e.persisted) {
      html.classList.add("babesten");
      balidatu();
    }
  });
  // Fitxa berriro aktibatzean, saioa iraungi ez dela egiaztatu
  document.addEventListener("visibilitychange", () => {
    if (document.visibilityState === "visible") balidatu();
  });

  balidatu();
})();
