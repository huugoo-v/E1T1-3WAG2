document.addEventListener("DOMContentLoaded", async () => {
  const gorputza = document.getElementById("mugimenduTaula");
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

    data.mugimenduak.forEach((m) => {
      const tr = document.createElement("tr");
      [m.gela, m.etiketa, m.materiala, m.erabiltzailea, m.hasieraData, m.amaieraData || "—"].forEach((balioa) => {
        const td = document.createElement("td");
        td.textContent = balioa ?? "";
        tr.append(td);
      });
      gorputza.append(tr);
    });
  } catch (error) {
    mezua.textContent = error.message || "Zerbitzariarekin konexio errorea.";
  }
});
