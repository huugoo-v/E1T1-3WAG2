document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('formBaliabidea');
    const mezuErrorea = document.getElementById('mezuErrorea');

    if (form) {
        form.addEventListener('submit', function (e) {
            e.preventDefault(); // Formularioaren birkarga tradizionala gelditu

            const formData = new FormData(this); // Formularioaren datu guztiak bildu

            fetch('functions/sortubaliabide.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json()) // JSON bihurtu
            .then(data => {
                if (data.success) {
                    window.location.href = 'inbentario.php'; // Ondo badago inbentariora bueltatu
                } else if (data.saioa === false) {
                    window.location.href = 'login.php';      // Saioa amaitu da
                } else {
                    mezuErrorea.textContent = data.message;  // Errore mezua erakutsi
                }
            })
            .catch(error => {
                console.error('Errorea:', error);
                mezuErrorea.textContent = 'Zerbitzariarekin konexio errorea gertatu da.';
            });
        });
    }
});
