document.addEventListener('DOMContentLoaded', () => {
    const errorea = document.getElementById('mezuErrorea');
    const burua = document.getElementById('gelaBurua');
    const edukia = document.getElementById('materialEdukiak');

    function sortu(tag, testua, klasea = '') {
        const elementua = document.createElement(tag);
        elementua.textContent = testua ?? '';
        if (klasea) elementua.className = klasea;
        return elementua;
    }

    function gelaMarraztu(gela) {
        document.title = `${gela.izena} - Inbentarioa`;
        document.getElementById('gelaIzena').textContent = gela.izena;
        document.getElementById('gelaTaldea').textContent = gela.taldea || 'Talde esleiturik gabe';

        const kategoriak = {};
        gela.materialak.forEach(m => {
            const kategoria = m.kategoria || 'Beste batzuk';
            (kategoriak[kategoria] = kategoriak[kategoria] || []).push(m);
        });

        const laburpena = document.getElementById('gelaLaburpena');
        laburpena.replaceChildren(sortu('span', `${gela.materialak.length} material guztira`));
        Object.entries(kategoriak).forEach(([k, lista]) => laburpena.append(sortu('span', `${k}: ${lista.length}`)));
        burua.hidden = false;

        edukia.replaceChildren();
        if (!gela.materialak.length) {
            edukia.append(sortu('p', 'Oraindik ez dago gela honetan esleitutako materialik.', 'material-hutsik'));
            return;
        }

        Object.entries(kategoriak).forEach(([kategoria, materialak]) => {
            const blokea = document.createElement('section');
            blokea.className = 'material-kategoria';
            const goiburua = document.createElement('div');
            goiburua.className = 'material-kategoria-goiburua';
            goiburua.append(sortu('h3', kategoria), sortu('span', String(materialak.length), 'material-kopurua'));
            blokea.append(goiburua);

            const taula = document.createElement('table');
            taula.innerHTML = '<thead><tr><th>Materiala</th><th>Etiketa</th><th>Marka / modeloa</th><th>Egoera</th></tr></thead>';
            const tbody = document.createElement('tbody');
            materialak.forEach(m => {
                const tr = document.createElement('tr');
                [m.izena, m.etiketa, [m.marka, m.modeloa].filter(Boolean).join(' / '), m.egoera].forEach(balioa => {
                    tr.append(sortu('td', balioa || '—'));
                });
                tbody.append(tr);
            });
            taula.append(tbody);
            blokea.append(taula);
            edukia.append(blokea);
        });
    }

    async function kargatu() {
        const id = Number(new URLSearchParams(window.location.search).get('id'));
        if (!id) {
            errorea.textContent = 'Ez da gelarik aukeratu.';
            return;
        }
        try {
            const response = await fetch('../backend/api/gelak.php', {credentials: 'same-origin'});
            const data = await response.json();
            if (response.status === 401 || data.saioa === false) {
                window.location.replace('login.html');
                return;
            }
            if (!response.ok || !data.success) throw new Error(data.message || 'Ezin izan da gela kargatu.');
            const gela = data.gelak.find(g => g.id === id);
            if (!gela) throw new Error('Gela ez da aurkitu.');
            gelaMarraztu(gela);
        } catch (error) {
            errorea.textContent = error.message || 'Zerbitzariarekin konexio errorea.';
        }
    }

    document.getElementById('irten').addEventListener('click', async e => {
        e.preventDefault();
        await fetch('../backend/api/logout.php', {credentials: 'same-origin'});
        window.location.href = 'login.html';
    });
    kargatu();
});
