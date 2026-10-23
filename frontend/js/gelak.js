document.addEventListener('DOMContentLoaded', () => {
    const sare = document.getElementById('gelakSarea');
    const errorea = document.getElementById('mezuErrorea');
    const atala = document.getElementById('materialAtala');
    const edukia = document.getElementById('materialEdukiak');
    const izenburua = document.getElementById('materialIzenburua');
    const azpititulua = document.getElementById('materialAzpititulua');

    function sortu(tag, testua, klasea = '') {
        const elementua = document.createElement(tag);
        elementua.textContent = testua ?? '';
        if (klasea) elementua.className = klasea;
        return elementua;
    }

    function materialakErakutsi(gela) {
        izenburua.textContent = gela.izena;
        azpititulua.textContent = gela.taldea || 'Gelako materiala';
        edukia.replaceChildren();
        atala.hidden = false;

        if (!gela.materialak.length) {
            edukia.append(sortu('p', 'Oraindik ez dago gela honetan esleitutako materialik.', 'material-hutsik'));
            atala.scrollIntoView({behavior: 'smooth', block: 'start'});
            return;
        }

        const kategoriak = {};
        gela.materialak.forEach(materiala => {
            const kategoria = materiala.kategoria || 'Beste batzuk';
            if (!kategoriak[kategoria]) kategoriak[kategoria] = [];
            kategoriak[kategoria].push(materiala);
        });

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
                [m.izena, m.etiketa, [m.marka, m.modeloa].filter(Boolean).join(' / '), m.egoera].forEach(valor => {
                    tr.append(sortu('td', valor || '—'));
                });
                tbody.append(tr);
            });
            taula.append(tbody);
            blokea.append(taula);
            edukia.append(blokea);
        });
        atala.scrollIntoView({behavior: 'smooth', block: 'start'});
    }

    async function kargatuGelak() {
        errorea.textContent = '';
        try {
            const response = await fetch('../backend/api/gelak.php', {credentials: 'same-origin'});
            const data = await response.json();
            if (response.status === 401 || data.saioa === false) {
                window.location.replace('login.html');
                return;
            }
            if (!response.ok || !data.success) throw new Error(data.message || 'Ezin izan dira gelak kargatu.');

            sare.replaceChildren();
            data.gelak.forEach(gela => {
                const botoia = document.createElement('button');
                botoia.type = 'button';
                botoia.className = 'gela-txartela';
                botoia.setAttribute('aria-label', `${gela.izena}, materiala ikusi`);
                botoia.append(sortu('span', 'GELA', 'gela-etiketa'), sortu('strong', gela.izena, 'gela-izena'), sortu('span', gela.taldea || 'Talde esleiturik gabe', 'gela-taldea'), sortu('span', `${gela.materialak.length} material`, 'gela-material-kopurua'));
                botoia.addEventListener('click', () => materialakErakutsi(gela));
                sare.append(botoia);
            });
            if (!data.gelak.length) sare.append(sortu('p', 'Ez dago gelarik datu-basean.'));
        } catch (error) {
            errorea.textContent = error.message || 'Zerbitzariarekin konexio errorea.';
            sare.replaceChildren();
        }
    }

    document.getElementById('itxiMateriala').addEventListener('click', () => { atala.hidden = true; });
    document.getElementById('irten').addEventListener('click', async e => {
        e.preventDefault();
        await fetch('../backend/api/logout.php', {credentials: 'same-origin'});
        window.location.href = 'login.html';
    });
    kargatuGelak();
});
