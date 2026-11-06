document.addEventListener("DOMContentLoaded", async () => {
  const form = document.getElementById("formBaliabidea");
  const mezuErrorea = document.getElementById("mezuErrorea");
  const gelaSelect = document.getElementById("gela_id");
  const params = new URLSearchParams(window.location.search);
  const id = params.get("id");

  document.getElementById("irten").addEventListener("click", async (e) => {
    e.preventDefault();
    await fetch("../backend/api/logout.php", { credentials: "same-origin" });
    window.location.href = "login.html";
  });

  async function eskatu(url) {
    const response = await fetch(url, { credentials: "same-origin" });
    const data = await response.json();
    if (data.saioa === false) {
      window.location.href = "login.html";
      throw new Error("Saioa iraungi da.");
    }
    return data;
  }

  try {
    // Gelen zerrenda (aukeratzeko)
    const gelak = await eskatu("../backend/api/gailuak.php?gelak=1");
    if (!gelak.success) throw new Error(gelak.message || "Ezin izan dira gelak kargatu.");
    gelak.gelak.forEach((g) => {
      const aukera = document.createElement("option");
      aukera.value = g.id;
      aukera.textContent = g.taldea ? `${g.izena} (${g.taldea})` : g.izena;
      gelaSelect.append(aukera);
    });

    if (id) {
      document.getElementById("izenburua").textContent = "EKIPAMENDUA EDITATU";
      const data = await eskatu("../backend/api/gailuak.php?id=" + encodeURIComponent(id));
      if (!data.success || !data.gailua)
        throw new Error(data.message || "Gailua ez da aurkitu.");
      const g = data.gailua;
      document.getElementById("id").value = g.id;
      document.getElementById("etiketa").value = g.etiketa || "";
      document.getElementById("izena").value = g.izena || "";
      document.getElementById("marka").value = g.marka || "";
      document.getElementById("modeloa").value = g.modeloa || "";
      document.getElementById("kategoria_id").value = g.kategoriaId;
      document.getElementById("deskribapena").value = g.deskribapena || "";
      document.getElementById("egoera").value = g.egoera || "Operatiboa";
      document.getElementById("erosketa_data").value = g.erosketaData || "";
      // Gela ez da hemen aldatzen (mugimenduak gelaren orritik erregistratzen dira)
      gelaSelect.value = g.gelaId ?? "";
      gelaSelect.disabled = true;
      gelaSelect.required = false;
      document.getElementById("gelaOharra").hidden = false;
    }
  } catch (error) {
    mezuErrorea.textContent = error.message || "Ezin izan dira datuak kargatu.";
  }

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    mezuErrorea.textContent = "";
    // Bezeroaren aldeko baliozkotzea (zerbitzariak berriz egiaztatzen du)
    const erroreak = [];
    const etiketa = form.etiketa.value.trim();
    const izena = form.izena.value.trim();
    if (etiketa === "" || etiketa.length > 50)
      erroreak.push("Etiketa derrigorrezkoa da (gehienez 50 karaktere).");
    if (izena === "" || izena.length > 150)
      erroreak.push("Izena derrigorrezkoa da (gehienez 150 karaktere).");
    if (form.marka.value.trim().length > 100)
      erroreak.push("Marka luzeegia da (gehienez 100 karaktere).");
    if (form.modeloa.value.trim().length > 100)
      erroreak.push("Modeloa luzeegia da (gehienez 100 karaktere).");
    if (form.deskribapena.value.trim().length > 2000)
      erroreak.push("Deskribapena luzeegia da (gehienez 2000 karaktere).");
    if (!form.kategoria_id.value) erroreak.push("Kategoria aukeratu behar da.");
    if (!id && !gelaSelect.value) erroreak.push("Gela aukeratu behar da.");
    if (erroreak.length) {
      mezuErrorea.textContent = erroreak.join(" ");
      return;
    }
    try {
      const response = await fetch("../backend/api/sortuGailua.php", {
        method: "POST",
        body: new FormData(form),
        credentials: "same-origin",
      });
      const data = await response.json();
      if (data.saioa === false) {
        window.location.href = "login.html";
      } else if (data.success) {
        window.location.href = "inbentario.html";
      } else {
        mezuErrorea.textContent = data.message || "Errorea datuak gordetzean.";
      }
    } catch (error) {
      mezuErrorea.textContent = "Ezin izan da zerbitzariarekin konektatu.";
    }
  });
});
