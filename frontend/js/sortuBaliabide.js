document.addEventListener('DOMContentLoaded', async () => {
    const form = document.getElementById('formBaliabidea');
    const mezuErrorea = document.getElementById('mezuErrorea');
    const params = new URLSearchParams(window.location.search);
    const id = params.get('id');

    document.getElementById('irten').addEventListener('click', async e => {
        e.preventDefault();
        await fetch('../backend/api/logout.php', {credentials: 'same-origin'});
        window.location.href = 'login.html';
    });

    if (id) {
        document.getElementById('izenburua').textContent = 'EKIPAMENDUA EDITATU';
        try {
            const response = await fetch('../backend/api/baliabideak.php?id=' + encodeURIComponent(id), {credentials: 'same-origin'});
            const data = await response.json();
            if (data.saioa === false) {
                window.location.href = 'login.html';
                return;
            }
            if (!data.success || !data.baliabidea) throw new Error(data.message || 'Baliabidea ez da aurkitu.');
            const b = data.baliabidea;
            document.getElementById('id').value = b.id;
            document.getElementById('izena').value = b.izena || '';
            document.getElementById('marka').value = b.marka || '';
            document.getElementById('modeloa').value = b.modeloa || '';
            document.getElementById('kategoria_id').value = b.kategoriaId;
            document.getElementById('deskribapena').value = b.deskribapena || '';
        } catch (error) {
            mezuErrorea.textContent = error.message || 'Ezin izan dira datuak kargatu.';
        }
    }

    form.addEventListener('submit', async e => {
        e.preventDefault();
        mezuErrorea.textContent = '';
        try {
            const response = await fetch('../backend/api/sortuBaliabide.php', {
                method: 'POST',
                body: new FormData(form),
                credentials: 'same-origin'
            });
            const data = await response.json();
            if (data.saioa === false) {
                window.location.href = 'login.html';
            } else if (data.success) {
                window.location.href = 'inbentario.html';
            } else {
                mezuErrorea.textContent = data.message || 'Errorea datuak gordetzean.';
            }
        } catch (error) {
            mezuErrorea.textContent = 'Ezin izan da zerbitzariarekin konektatu.';
        }
    });
});
