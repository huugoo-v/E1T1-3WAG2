document.addEventListener("DOMContentLoaded", async () => {
  const API = "../backend/api/erabiltzaileak.php";
  const taula = document.getElementById("erabiltzaileTaula");
  const mezua = document.getElementById("mezuErrorea");
  const form = document.getElementById("erabiltzaileForm");
  const idInput = document.getElementById("id");
  const usernameInput = document.getElementById("username");
  const pasahitzaInput = document.getElementById("pasahitza");
  const rolInput = document.getElementById("rol");
  const utzi = document.getElementById("utzi");
  let unekoId = null;

  document.getElementById("irten").addEventListener("click", async (e) => {
    e.preventDefault();
    await fetch("../backend/api/logout.php", { credentials: "same-origin" });
    window.location.href = "login.html";
  });

  // Erantzunak kudeatu: saio-galera -> login, baimen-falta -> hasiera
  async function eskatu(url, aukerak = {}) {
    const response = await fetch(url, { credentials: "same-origin", ...aukerak });
    const data = await response.json();
    if (response.status === 401 || data.saioa === false) {
      window.location.replace("login.html");
      throw new Error("Saioa iraungi da.");
    }
    if (response.status === 403) {
      window.location.replace("inbentario.html");
      throw new Error("Baimenik ez.");
    }
    return data;
  }

  function formaGarbitu() {
    form.reset();
    idInput.value = "";
    document.getElementById("formIzenburua").textContent = "Erabiltzaile berria";
    document.getElementById("pasahitzaOharra").textContent = "(*)";
    utzi.hidden = true;
  }

  function gelaxka(testua) {
    const td = document.createElement("td");
    td.textContent = testua ?? "";
    return td;
  }

  function taulaMarraztu(erabiltzaileak) {
    taula.replaceChildren();
    erabiltzaileak.forEach((u) => {
      const tr = document.createElement("tr");
      tr.append(gelaxka(u.username), gelaxka(u.rol));

      const aldatu = document.createElement("a");
      aldatu.href = "#";
      aldatu.textContent = "Aldatu";
      aldatu.addEventListener("click", (e) => {
        e.preventDefault();
        idInput.value = u.id;
        usernameInput.value = u.username;
        pasahitzaInput.value = "";
        rolInput.value = u.rol;
        document.getElementById("formIzenburua").textContent = "Erabiltzailea aldatu";
        document.getElementById("pasahitzaOharra").textContent = "(utzi hutsik ez aldatzeko)";
        utzi.hidden = false;
        usernameInput.focus();
      });

      const ezabatu = document.createElement("button");
      ezabatu.type = "button";
      ezabatu.textContent = "Ezabatu";
      ezabatu.className = "botoi-arriskua";
      ezabatu.disabled = u.id === unekoId;
      ezabatu.addEventListener("click", () => ezabatuErabiltzailea(u));

      const td = document.createElement("td");
      td.className = "taula-ekintzak";
      td.append(aldatu, ezabatu);
      tr.append(td);
      taula.append(tr);
    });
  }

  async function kargatu() {
    try {
      const data = await eskatu(API);
      if (!data.success)
        throw new Error(data.message || "Ezin izan dira erabiltzaileak kargatu.");
      unekoId = data.unekoId;
      taulaMarraztu(data.erabiltzaileak);
    } catch (error) {
      mezua.textContent = error.message || "Zerbitzariarekin konexio errorea.";
    }
  }

  async function ezabatuErabiltzailea(u) {
    if (!confirm(`Ziur "${u.username}" erabiltzailea ezabatu nahi duzula?`)) return;
    mezua.textContent = "";
    try {
      const data = await eskatu(API, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ ekintza: "ezabatu", id: u.id }),
      });
      if (!data.success) throw new Error(data.message || "Ezin izan da ezabatu.");
      kargatu();
    } catch (error) {
      mezua.textContent = error.message;
    }
  }

  // Bezeroaren aldeko baliozkotzea (zerbitzariak berriz egiaztatzen du)
  function baliozkotu(username, pasahitza, sortzen) {
    if (!/^[A-Za-z0-9_.-]{3,50}$/.test(username))
      return "Erabiltzailea 3-50 karakterekoa izan behar da (letrak, zenbakiak, _ . -).";
    if ((sortzen || pasahitza !== "") && (pasahitza.length < 8 || pasahitza.length > 72))
      return "Pasahitzak 8 eta 72 karaktere artean izan behar ditu.";
    return "";
  }

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    mezua.textContent = "";
    const sortzen = idInput.value === "";
    const username = usernameInput.value.trim();
    const pasahitza = pasahitzaInput.value;
    const errorea = baliozkotu(username, pasahitza, sortzen);
    if (errorea) {
      mezua.textContent = errorea;
      return;
    }
    try {
      const data = await eskatu(API, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          ekintza: sortzen ? "sortu" : "aldatu",
          id: sortzen ? undefined : Number(idInput.value),
          username,
          pasahitza,
          rol: rolInput.value,
        }),
      });
      if (!data.success) throw new Error(data.message || "Errorea datuak gordetzean.");
      formaGarbitu();
      kargatu();
    } catch (error) {
      mezua.textContent = error.message || "Zerbitzariarekin konexio errorea.";
    }
  });

  utzi.addEventListener("click", (e) => {
    e.preventDefault();
    formaGarbitu();
  });

  kargatu();
});
