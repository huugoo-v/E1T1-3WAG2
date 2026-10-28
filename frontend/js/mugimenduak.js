document.addEventListener("DOMContentLoaded", async () => {
  const gorputza = document.getElementById("mugimenduTaula");
  const taula = document.getElementById("mugimenduTaulaOsoa");
  const hutsik = document.getElementById("mugimenduHutsik");
  const mezua = document.getElementById("mezuErrorea");

  document.getElementById("irten").addEventListener("click", async (e) => {
    e.preventDefault();
    await fetch("../backend/api/logout.php", { credentials: "same-origin" });
    window.location.href = "login.html";
  });

  try {
    const response = await fetch("../backend/api/mugimenduak.php", {
      credentials: "same-origin",
    });
    const data = await response.json();
    if (response.status === 401 || data.saioa === false) {
      window.location.replace("login.html");
      return;
    }
    if (!data.success)
      throw new Error(data.message || "Ezin izan dira mugimenduak kargatu.");

    // Irakurtzeko soilik: ez dago ezabatu edo gehitzeko botoirik
    data.mugimenduak.forEach((m) => {
      const tr = document.createElement("tr");
      [
        [m.materiala, m.marka, m.modeloa].filter(Boolean).join(" "),
        m.etiketa,
        m.nondik,
        m.nora,
        m.data,
        m.erabiltzailea,
      ].forEach((balioa) => {
        const td = document.createElement("td");
        td.textContent = balioa ?? "";
        tr.append(td);
      });
      gorputza.append(tr);
    });
    taula.hidden = !data.mugimenduak.length;
    hutsik.hidden = data.mugimenduak.length > 0;
  } catch (error) {
    mezua.textContent = error.message || "Zerbitzariarekin konexio errorea.";
  }
});
