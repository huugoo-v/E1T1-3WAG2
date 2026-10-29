document.addEventListener('DOMContentLoaded', () => {
    const errorea = document.getElementById('mezuErrorea');
    const mezuOna = document.getElementById('mezuOna');
    const taula = document.getElementById('gelakTaula');
    const gorputza = document.getElementById('gelakGorputza');
    const hutsik = document.getElementById('gelakHutsik');
    const dialog = document.getElementById('gelaDialog');
    const form = document.getElementById('gelaForm');
    const formErrorea = document.getElementById('formErrorea');
    const izenaInput = document.getElementById('gelaIzena');
    const taldeaInput = document.getElementById('gelaTaldea');
    const gordeBotoia = document.getElementById('gelaGorde');

    function sortu(tag, testua, klasea = '') {
        const elementua = document.createElement(tag);
        elementua.textContent = testua ?? '';
        if (klasea) elementua.className = klasea;
        return elementua;
    }

    // Saioa iraungi bada login-era bidaltzen du; bestela JSON datuak itzultzen ditu
    async function eskatu(url, aukerak = {}) {
        const response = await fetch(url, {credentials: 'same-origin', ...aukerak});
        const data = await response.json();
        if (response.status === 401 || data.saioa === false) {
            window.location.replace('login.html');
            throw new Error('Saioa iraungi da.');
        }
        if (!response.ok || !data.success) throw new Error(data.message || 'Errorea zerbitzariarekin.');
        return data;
    }

    function errenkada(gela, admin) {
        const tr = document.createElement('tr');

        const izena = document.createElement('a');
        izena.className = 'gela-esteka';
        izena.href = 'gela.html?id=' + encodeURIComponent(gela.id);
        izena.textContent = gela.izena;
        const izenaTd = document.createElement('td');
        izenaTd.append(izena);

        const ikusi = document.createElement('a');
        ikusi.className = 'botoia';
        ikusi.href = izena.href;
        ikusi.textContent = 'Ikusi';
        ikusi.setAttribute('aria-label', `${gela.izena} gelako materiala ikusi`);

        const ekintzak = document.createElement('td');
        ekintzak.className = 'taula-ekintzak';
        ekintzak.append(ikusi);

        // Gelak ezabatzea administratzaileentzat soilik (zerbitzariak ere egiaztatzen du)
        if (admin) {
            const ezabatu = document.createElement('button');
            ezabatu.type = 'button';
            ezabatu.className = 'botoi-arriskua';
            ezabatu.textContent = 'Ezabatu';
            ezabatu.setAttribute('aria-label', `${gela.izena} gela ezabatu`);
            ezabatu.addEventListener('click', () => gelaEzabatu(gela));
            ekintzak.append(ezabatu);
        }

        tr.append(izenaTd, sortu('td', gela.taldea || '—'), sortu('td', `${gela.materialak.length} material`), ekintzak);
        return tr;
    }

    async function kargatu() {
        try {
            const data = await eskatu('../backend/api/gelak.php');
            const admin = (await window.saioaPrest)?.rol === 'admin';
            gorputza.replaceChildren(...data.gelak.map(gela => errenkada(gela, admin)));
            taula.hidden = !data.gelak.length;
            hutsik.hidden = data.gelak.length > 0;
            hutsik.textContent = 'Ez dago gelarik. Sortu lehenengoa "+ Gela berria" botoiarekin.';
        } catch (error) {
            errorea.textContent = error.message || 'Zerbitzariarekin konexio errorea.';
            taula.hidden = true;
            hutsik.hidden = true;
        }
    }

    async function gelaEzabatu(gela) {
        if (!confirm(`Ziur "${gela.izena}" gela ezabatu nahi duzula?`)) return;
        errorea.textContent = '';
        mezuOna.textContent = '';
        try {
            await eskatu('../backend/api/ezabatuGela.php', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({id: gela.id})
            });
            await kargatu();
            mezuOna.textContent = `"${gela.izena}" gela ezabatu da.`;
        } catch (error) {
            errorea.textContent = error.message || 'Zerbitzariarekin konexio errorea.';
        }
    }

    // ===== Gela berria sortzeko leihoa =====
    function ireki() {
        form.reset();
        formErrorea.textContent = '';
        errorea.textContent = '';
        mezuOna.textContent = '';
        dialog.showModal();
        izenaInput.focus();
    }
    function itxi() {
        if (dialog.open) dialog.close();
    }

    form.addEventListener('submit', async e => {
        e.preventDefault();
        formErrorea.textContent = '';
        const izena = izenaInput.value.trim();
        const taldea = taldeaInput.value.trim();
        if (!izena) {
            formErrorea.textContent = 'Izena derrigorrezkoa da.';
            izenaInput.focus();
            return;
        }
        gordeBotoia.disabled = true;
        try {
            await eskatu('../backend/api/sortuGela.php', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({izena, taldea})
            });
            itxi();
            await kargatu();
            mezuOna.textContent = `"${izena}" gela sortu da.`;
        } catch (error) {
            formErrorea.textContent = error.message || 'Zerbitzariarekin konexio errorea.';
        } finally {
            gordeBotoia.disabled = false;
        }
    });
    document.getElementById('gelaBerria')?.addEventListener('click', ireki);
    document.getElementById('gelaUtzi').addEventListener('click', itxi);
    dialog.addEventListener('click', e => {
        if (e.target === dialog) itxi();   // atzealdean klik eginda ere itxi
    });

    document.getElementById('irten').addEventListener('click', async e => {
        e.preventDefault();
        await fetch('../backend/api/logout.php', {credentials: 'same-origin'});
        window.location.href = 'login.html';
    });
    kargatu();
});
