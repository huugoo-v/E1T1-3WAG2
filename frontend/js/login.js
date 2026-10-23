document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("loginForm");
  const errorea = document.getElementById("errorea");

  // Saioa dagoeneko hasita badago, ez erakutsi loginik
  fetch("../backend/api/sesioaBalidatu.php", { credentials: "same-origin", cache: "no-store" })
    .then((r) => (r.ok ? r.json() : null))
    .then((d) => {
      if (d && d.success) window.location.replace("inbentario.html");
    })
    .catch(() => {});

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    errorea.textContent = "";
    // Bezeroaren aldeko baliozkotzea (zerbitzariak berriz egiaztatzen du)
    const erabiltzailea = form.erabiltzaile.value.trim();
    if (erabiltzailea === "" || form.pasahitza.value === "") {
      errorea.textContent = "Eremuak ezin dira hutsik egon.";
      return;
    }
    try {
      const response = await fetch("../backend/api/login.php", {
        method: "POST",
        body: new FormData(form),
        credentials: "same-origin",
      });
      const data = await response.json();
      if (data.success) {
        window.location.href = "inbentario.html";
      } else {
        errorea.textContent = data.message || "Ezin izan da saioa hasi.";
      }
    } catch (error) {
      errorea.textContent = "Ezin izan da zerbitzariarekin konektatu.";
    }
  });
});
