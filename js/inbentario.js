document.addEventListener('DOMContentLoaded', () => {
    const bilatuForm  = document.getElementById('bilatuForm');
    const bilatuInput = document.getElementById('bilatu');
    const gorputza    = document.getElementById('taulaGorputza');
    const mezuErrorea = document.getElementById('mezuErrorea');

    // Gelaxka bat sortu (textContent erabiltzen da, htmlspecialchars bezala babesten du)
    function gelaxka(testua) {
        const td = document.createElement('td');
        td.textContent = testua ?? '';
        return td;
    }

    // Taula marraztu
    function taulaMarraztu(baliabideak) {
        gorputza.innerHTML = '';

        baliabideak.forEach(b => {
            const tr = document.createElement('tr');

            tr.appendChild(gelaxka(b.izena));
            tr.appendChild(gelaxka(b.marka));
            tr.appendChild(gelaxka(b.modeloa));
            tr.appendChild(gelaxka(b.kategoria));
            tr.appendChild(gelaxka(b.deskribapena));

            const td = document.createElement('td');

            const aldatu = document.createElement('a');
            aldatu.href = 'objetuakSortu.php?id=' + encodeURIComponent(b.id);
            aldatu.textContent = 'Aldatu';

            const ezabatu = document.createElement('a');
            ezabatu.href = 'functions/ezabatuBaliabide.php?id=' + encodeURIComponent(b.id);
            ezabatu.textContent = 'Ezabatu';

            td.appendChild(aldatu);
            td.append(' | ');
            td.appendChild(ezabatu);
            tr.appendChild(td);

            gorputza.appendChild(tr);
        });
    }

    // Datuak zerbitzaritik kargatu
    function kargatu(bilatu = '') {
        mezuErrorea.textContent = '';

        fetch('functions/baliabide.php?bilatu=' + encodeURIComponent(bilatu))
            .then(response => response.text().then(testua => {
                // Probak egiteko: JSON ez bada, erantzun errealaren hasiera erakusten da
                try {
                    return JSON.parse(testua);
                } catch (e) {
                    throw new Error('HTTP ' + response.status + ' -> ' + testua.substring(0, 200));
                }
            }))
            .then(data => {
                if (data.success) {
                    taulaMarraztu(data.baliabideak);
                } else if (data.saioa === false) {
                    window.location.href = 'login.php'; // Saioa amaitu da
                } else {
                    mezuErrorea.textContent = data.message;
                }
            })
            .catch(error => {
                console.error('Errorea:', error);
                mezuErrorea.textContent = 'Zerbitzariarekin konexio errorea gertatu da. ' + error.message;
            });
    }

    // Bilatzailea
    bilatuForm.addEventListener('submit', e => {
        e.preventDefault();
        kargatu(bilatuInput.value);
    });

    // Garbitu botoia
    document.getElementById('garbitu').addEventListener('click', e => {
        e.preventDefault();
        bilatuInput.value = '';
        kargatu();
    });

    kargatu(); // Orria irekitzean
});