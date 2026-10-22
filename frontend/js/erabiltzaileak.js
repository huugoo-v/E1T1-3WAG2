document.addEventListener("DOMContentLoaded", async () => {
  const taula = document.getElementById("erabiltzaileTaula");
  const mezua = document.getElementById("mezuErrorea");
  document.getElementById("irten").addEventListener("click", async (e) => {
    e.preventDefault();
    await fetch("../backend/api/logout.php", { credentials: "same-origin" });
    window.location.href = "login.html";
  });
  try {
    const response = await fetch("../backend/api/erabiltzaileak.php", {
      credentials: "same-origin",
    });
    const data = await response.json();
    if (data.saioa === false) {
      window.location.href = "login.html";
      return;
    }
    if (!data.success)
      throw new Error(data.message || "Ezin izan dira erabiltzaileak kargatu.");
    data.erabiltzaileak.forEach((u) => {
      const tr = document.createElement("tr");
      for (const value of [u.username, u.rol]) {
        const td = document.createElement("td");
        td.textContent = value;
        tr.append(td);
      }
      taula.append(tr);
    });
  } catch (error) {
    mezua.textContent = error.message || "Zerbitzariarekin konexio errorea.";
  }
});
