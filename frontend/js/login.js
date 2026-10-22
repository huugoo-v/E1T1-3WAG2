document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("loginForm");
  const errorea = document.getElementById("errorea");

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    errorea.textContent = "";
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
