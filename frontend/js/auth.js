document.addEventListener("DOMContentLoaded", async () => {
  try {
    const response = await fetch("../backend/api/sesioaBalidatu.php", {
      credentials: "same-origin",
    });

    if (!response.ok) {
      window.location.replace("login.html");
      return;
    }

    const data = await response.json();
    if (!data.success) {
      window.location.replace("login.html");
    }
  } catch (error) {
    window.location.replace("login.html");
  }
});
