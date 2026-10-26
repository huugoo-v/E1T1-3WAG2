document.addEventListener("DOMContentLoaded", () => {
  const bilatuForm = document.getElementById("bilatuForm");
  const bilatuInput = document.getElementById("bilatu");
  const gorputza = document.getElementById("taulaGorputza");
  const mezuErrorea = document.getElementById("mezuErrorea");

  function gelaxka(testua) {
    const td = document.createElement("td");
    td.textContent = testua ?? "";
    return td;
  }

  function taulaMarraztu(baliabideak) {
    gorputza.replaceChildren();
    baliabideak.forEach((b) => {
      const tr = document.createElement("tr");
      tr.append(
        gelaxka(b.izena),
        gelaxka(b.marka),
        gelaxka(b.modeloa),
        gelaxka(b.kategoria),
        gelaxka(b.deskribapena),
      );
      const td = document.createElement("td");
      td.className = "taula-ekintzak";
      const aldatu = document.createElement("a");
      aldatu.className = "botoia";
      aldatu.href = "objektuakSortu.html?id=" + encodeURIComponent(b.id);
      aldatu.textContent = "Aldatu";
      const ezabatu = document.createElement("button");
      ezabatu.type = "button";
      ezabatu.className = "botoi-arriskua";
      ezabatu.textContent = "Ezabatu";
      ezabatu.addEventListener("click", () => baliabideaEzabatu(b.id));
      td.append(aldatu, ezabatu);
      tr.append(td);
      gorputza.append(tr);
    });
  }

  async function kargatu(bilatu = "") {
    mezuErrorea.textContent = "";
    try {
      const response = await fetch(
        "../backend/api/baliabideak.php?bilatu=" + encodeURIComponent(bilatu),
        { credentials: "same-origin" },
      );
      const data = await response.json();
      if (data.saioa === false) {
        window.location.href = "login.html";
        return;
      }
      if (!data.success)
        throw new Error(data.message || "Datuak ezin izan dira kargatu.");
      taulaMarraztu(data.baliabideak);
    } catch (error) {
      mezuErrorea.textContent =
        error.message || "Zerbitzariarekin konexio errorea.";
    }
  }

  async function baliabideaEzabatu(id) {
    if (!confirm("Ziur baliabide hau ezabatu nahi duzula?")) return;
    try {
      const response = await fetch("../backend/api/ezabatuBaliabide.php", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ id }),
        credentials: "same-origin",
      });
      const data = await response.json();
      if (data.saioa === false) {
        window.location.href = "login.html";
        return;
      }
      if (!data.success)
        throw new Error(data.message || "Ezin izan da ezabatu.");
      kargatu(bilatuInput.value);
    } catch (error) {
      mezuErrorea.textContent =
        error.message || "Ezabatzean errorea gertatu da.";
    }
  }

  bilatuForm.addEventListener("submit", (e) => {
    e.preventDefault();
    kargatu(bilatuInput.value);
  });
  document.getElementById("garbitu").addEventListener("click", (e) => {
    e.preventDefault();
    bilatuInput.value = "";
    kargatu();
  });
  document.getElementById("irten").addEventListener("click", async (e) => {
    e.preventDefault();
    await fetch("../backend/api/logout.php", { credentials: "same-origin" });
    window.location.href = "login.html";
  });
  kargatu();
});
