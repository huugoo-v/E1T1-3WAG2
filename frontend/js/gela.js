document.addEventListener('DOMContentLoaded', () => {
    const errorea = document.getElementById('mezuErrorea');
    const mezuOna = document.getElementById('mezuOna');
    const burua = document.getElementById('gelaBurua');
    const edukiontzia = document.getElementById('materialEdukiak');
    const taula = document.getElementById('materialTaula');
    const gorputza = document.getElementById('materialGorputza');
    const hutsik = document.getElementById('materialHutsik');
    const dialog = document.getElementById('mugituDialog');
    const form = document.getElementById('mugituForm');
    const formErrorea = document.getElementById('formErrorea');
    const mugituInfo = document.getElementById('mugituInfo');
    const helburua = document.getElementById('helburuGela');
    const gordeBotoia = document.getElementById('mugituGorde');
    const bilatuForm = document.getElementById('bilatuForm');
    const bilatuInput = document.getElementById('bilatu');
    const emaitzaKopurua = document.getElementById('emaitzaKopurua');

    const KATEGORIA_ORDENA = ['Mahaigaineko ekipoa', 'Portatila', 'Periferikoak', 'Beste batzuk'];
    const gelaId = Number(new URLSearchParams(window.location.search).get('id'));
    let gelak = [];
    let gela = null;
    let mugitzekoa = null;

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

    function ordenatu(materialak) {
        const ordena = k => {
            const i = KATEGORIA_ORDENA.indexOf(k);
            return i === -1 ? KATEGORIA_ORDENA.length : i;
        };
        return [...materialak].sort((a, b) =>
            ordena(a.kategoria) - ordena(b.kategoria) ||
            (a.izena || '').localeCompare(b.izena || '', 'eu') ||
            (a.etiketa || '').localeCompare(b.etiketa || '', 'eu', {numeric: true}));
    }

    // Maiuskulak eta azentuak kontuan hartu gabe bilatzen da; hitz guztiak agertu behar dira
    const normalizatu = t => String(t ?? '').toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');

    function iragazi(materialak) {
        const hitzak = normalizatu(bilatuInput.value).split(/\s+/).filter(Boolean);
        if (!hitzak.length) return materialak;
        return materialak.filter(m => {
            const testua = normalizatu([m.izena, m.etiketa, m.marka, m.modeloa, m.kategoria, m.egoera, m.deskribapena].join(' '));
            return hitzak.every(h => testua.includes(h));
        });
    }

    function errenkada(m) {
        const tr = document.createElement('tr');
        const markaModeloa = [m.marka, m.modeloa].filter(Boolean).join(' / ');
        const egoera = m.egoera || '—';
        const egoeraTd = document.createElement('td');
        egoeraTd.append(sortu('span', egoera, 'egoera-pila ' + (/operatibo/i.test(egoera) ? 'egoera-ona' : 'egoera-bestea')));

        const mugitu = document.createElement('button');
        mugitu.type = 'button';
        mugitu.textContent = 'Mugitu';
        mugitu.setAttribute('aria-label', `${m.etiketa} mugitu beste gela batera`);
        mugitu.addEventListener('click', () => ireki(m));
        const ekintzak = document.createElement('td');
        ekintzak.className = 'taula-ekintzak';
        ekintzak.append(mugitu);

        tr.append(sortu('td', m.izena), sortu('td', m.etiketa), sortu('td', markaModeloa || '—'), sortu('td', m.kategoria || '—'), egoeraTd, ekintzak);
        return tr;
    }

    function marraztu() {
        document.title = `${gela.izena} - Inbentarioa`;
        document.getElementById('gelaIzena').textContent = gela.izena;
        document.getElementById('gelaTaldea').textContent = gela.taldea || 'Talde esleiturik gabe';

        const kategoriak = {};
        gela.materialak.forEach(m => {
            const k = m.kategoria || 'Beste batzuk';
            kategoriak[k] = (kategoriak[k] || 0) + 1;
        });
        const laburpena = document.getElementById('gelaLaburpena');
        laburpena.replaceChildren(sortu('span', `${gela.materialak.length} material guztira`));
        Object.entries(kategoriak).forEach(([k, kopurua]) => laburpena.append(sortu('span', `${k}: ${kopurua}`)));
        burua.hidden = false;

        bilatuForm.hidden = false;
        zerrendaMarraztu();
        edukiontzia.hidden = false;
    }

    // Taula bilaketaren arabera marrazten da (bilaketa hutsik badago, guztia)
    function zerrendaMarraztu() {
        const guztira = gela.materialak.length;
        const emaitza = ordenatu(iragazi(gela.materialak));
        gorputza.replaceChildren(...emaitza.map(errenkada));
        taula.hidden = !emaitza.length;
        hutsik.hidden = emaitza.length > 0;
        hutsik.textContent = guztira ? 'Ez da materialik aurkitu bilaketa horrekin.' : 'Oraindik ez dago gela honetan esleitutako materialik.';
        emaitzaKopurua.textContent = bilatuInput.value.trim() ? `${emaitza.length} / ${guztira} material` : '';
        edukiontzia.scrollTop = 0;
    }

    async function kargatu() {
        if (!gelaId) {
            errorea.textContent = 'Ez da gelarik aukeratu.';
            return;
        }
        try {
            const data = await eskatu('../backend/api/gelak.php');
            gelak = data.gelak;
            gela = gelak.find(g => g.id === gelaId);
            if (!gela) throw new Error('Gela ez da aurkitu.');
            errorea.textContent = '';
            marraztu();
        } catch (error) {
            errorea.textContent = error.message || 'Zerbitzariarekin konexio errorea.';
        }
    }

    // ===== Gailua beste gela batera mugitzeko leihoa =====
    function ireki(gailua) {
        mugitzekoa = gailua;
        mezuOna.textContent = '';
        formErrorea.textContent = '';
        mugituInfo.textContent = `${gailua.izena} · ${gailua.etiketa} (orain: ${gela.izena})`;
        const besteak = gelak.filter(g => g.id !== gela.id);
        helburua.replaceChildren(sortu('option', 'Aukeratu gela...'));
        helburua.firstChild.value = '';
        besteak.forEach(g => {
            const aukera = sortu('option', g.taldea ? `${g.izena} (${g.taldea})` : g.izena);
            aukera.value = g.id;
            helburua.append(aukera);
        });
        gordeBotoia.disabled = !besteak.length;
        if (!besteak.length) formErrorea.textContent = 'Ez dago beste gelarik.';
        dialog.showModal();
        helburua.focus();
    }

    function itxi() {
        if (dialog.open) dialog.close();
    }

    form.addEventListener('submit', async e => {
        e.preventDefault();
        formErrorea.textContent = '';
        const helburuId = Number(helburua.value);
        if (!helburuId) {
            formErrorea.textContent = 'Helburuko gela aukeratu behar duzu.';
            return;
        }
        gordeBotoia.disabled = true;
        try {
            const data = await eskatu('../backend/api/mugituGailua.php', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({gailuId: mugitzekoa.id, gelaId: helburuId})
            });
            const m = data.mugimendua;
            itxi();
            await kargatu();
            mezuOna.textContent = `${m.materiala} (${m.etiketa}) mugitu da: ${m.nondik} → ${m.nora}.`;
        } catch (error) {
            formErrorea.textContent = error.message || 'Zerbitzariarekin konexio errorea.';
        } finally {
            gordeBotoia.disabled = false;
        }
    });
    document.getElementById('mugituUtzi').addEventListener('click', itxi);
    dialog.addEventListener('click', e => {
        if (e.target === dialog) itxi();   // atzealdean klik eginda ere itxi
    });

    // Bilatzailea: idaztean iragazten da; Iragazi eta Garbitu botoiek inventarioko berberak dira
    bilatuInput.addEventListener('input', () => gela && zerrendaMarraztu());
    bilatuForm.addEventListener('submit', e => {
        e.preventDefault();
        if (gela) zerrendaMarraztu();
    });
    document.getElementById('garbitu').addEventListener('click', () => {
        bilatuInput.value = '';
        if (gela) zerrendaMarraztu();
        bilatuInput.focus();
    });

    document.getElementById('irten').addEventListener('click', async e => {
        e.preventDefault();
        await fetch('../backend/api/logout.php', {credentials: 'same-origin'});
        window.location.href = 'login.html';
    });
    kargatu();
});
