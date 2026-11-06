document.addEventListener("DOMContentLoaded", () => {
  const bilatuForm = document.getElementById("bilatuForm");
  const bilatuInput = document.getElementById("bilatu");
  const taula = document.getElementById("taula");
  const gorputza = document.getElementById("taulaGorputza");
  const hutsik = document.getElementById("hutsik");
  const kopurua = document.getElementById("kopurua");
  const mezuErrorea = document.getElementById("mezuErrorea");
  const edukiontzia = document.querySelector(".scroll-edukiontzia");

  function gelaxka(testua) {
    const td = document.createElement("td");
    td.textContent = testua ?? "";
    return td;
  }

  function errenkada(g, admin) {
    const tr = document.createElement("tr");

    const gelaTd = document.createElement("td");
    if (g.gelaId) {
      const esteka = document.createElement("a");
      esteka.className = "gela-esteka";
      esteka.href = "gela.html?id=" + encodeURIComponent(g.gelaId);
      esteka.textContent = g.gela;
      gelaTd.append(esteka);
    } else {
      gelaTd.textContent = "—";
    }

    const egoera = g.egoera || "—";
    const egoeraPila = document.createElement("span");
    egoeraPila.className =
      "egoera-pila " + (/operatibo/i.test(egoera) ? "egoera-ona" : "egoera-bestea");
    egoeraPila.textContent = egoera;
    const egoeraTd = document.createElement("td");
    egoeraTd.append(egoeraPila);

    const td = document.createElement("td");
    td.className = "taula-ekintzak";
    const aldatu = document.createElement("a");
    aldatu.className = "botoia";
    aldatu.href = "objektuakSortu.html?id=" + encodeURIComponent(g.id);
    aldatu.textContent = "Aldatu";
    aldatu.setAttribute("aria-label", `${g.etiketa} aldatu`);
    td.append(aldatu);
    // Gailua ezabatzea administratzaileentzat soilik (zerbitzariak ere egiaztatzen du)
    if (admin) {
      const ezabatu = document.createElement("button");
      ezabatu.type = "button";
      ezabatu.className = "botoi-arriskua";
      ezabatu.textContent = "Ezabatu";
      ezabatu.setAttribute("aria-label", `${g.etiketa} ezabatu`);
      ezabatu.addEventListener("click", () => gailuaEzabatu(g));
      td.append(ezabatu);
    }

    tr.append(
      gelaxka(g.etiketa),
      gelaxka(g.izena),
      gelaxka(g.marka),
      gelaxka(g.modeloa),
      gelaxka(g.kategoria),
      gelaTd,
      egoeraTd,
      td,
    );
    return tr;
  }

  async function kargatu(bilatu = "") {
    mezuErrorea.textContent = "";
    try {
      const response = await fetch(
        "../backend/api/gailuak.php?bilatu=" + encodeURIComponent(bilatu),
        { credentials: "same-origin" },
      );
      const data = await response.json();
      if (data.saioa === false) {
        window.location.href = "login.html";
        return;
      }
      if (!data.success)
        throw new Error(data.message || "Datuak ezin izan dira kargatu.");
      const admin = (await window.saioaPrest)?.rol === "admin";
      gorputza.replaceChildren(...data.gailuak.map((g) => errenkada(g, admin)));
      taula.hidden = !data.gailuak.length;
      hutsik.hidden = data.gailuak.length > 0;
      kopurua.textContent = data.gailuak.length === 1 ? "1 gailu" : `${data.gailuak.length} gailu`;
      edukiontzia.scrollTop = 0;
    } catch (error) {
      mezuErrorea.textContent =
        error.message || "Zerbitzariarekin konexio errorea.";
    }
  }

  async function gailuaEzabatu(g) {
    if (
      !confirm(
        `Ziur "${g.izena}" (${g.etiketa}) gailua ezabatu nahi duzula?\n` +
          "Bere mugimendu-historia ere ezabatuko da.",
      )
    )
      return;
    mezuErrorea.textContent = "";
    try {
      const response = await fetch("../backend/api/ezabatuGailua.php", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ id: g.id }),
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
