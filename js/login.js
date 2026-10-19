
document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('loginForm');
    const mezuErrorea = document.getElementById('errorea');

    if (loginForm) {
        loginForm.addEventListener('submit', function (e) {
            e.preventDefault(); // Orrialdea berriro ez kargatzeko

            const formData = new FormData(this); // Formularioaren datuak bildu

            fetch('functions/login.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    window.location.href = 'inbentario.php'; // Ondo badago inbentariora joan
                } else {
                    mezuErrorea.textContent = data.message;  // PHP-ren errore mezua erakutsi
                }
            })
            .catch(error => {
                console.error('Errorea:', error);
                mezuErrorea.textContent = 'Zerbitzariarekin konexio errorea gertatu da.';
            });
        });
    }
});