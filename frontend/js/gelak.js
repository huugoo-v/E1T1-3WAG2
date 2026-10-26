document.addEventListener('DOMContentLoaded', () => {
    const sare = document.getElementById('gelakSarea');
    const errorea = document.getElementById('mezuErrorea');

    function sortu(tag, testua, klasea = '') {
        const elementua = document.createElement(tag);
        elementua.textContent = testua ?? '';
        if (klasea) elementua.className = klasea;
        return elementua;
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
                // Gela bakoitza bere orrira daraman esteka da
                const txartela = document.createElement('a');
                txartela.className = 'gela-txartela';
                txartela.href = 'gela.html?id=' + encodeURIComponent(gela.id);
                txartela.setAttribute('aria-label', `${gela.izena}, materiala ikusi`);
                txartela.append(sortu('span', 'GELA', 'gela-etiketa'), sortu('strong', gela.izena, 'gela-izena'), sortu('span', gela.taldea || 'Talde esleiturik gabe', 'gela-taldea'), sortu('span', `${gela.materialak.length} material`, 'gela-material-kopurua'));
                sare.append(txartela);
            });
            if (!data.gelak.length) sare.append(sortu('p', 'Ez dago gelarik datu-basean.'));
        } catch (error) {
            errorea.textContent = error.message || 'Zerbitzariarekin konexio errorea.';
            sare.replaceChildren();
        }
    }

    document.getElementById('irten').addEventListener('click', async e => {
        e.preventDefault();
        await fetch('../backend/api/logout.php', {credentials: 'same-origin'});
        window.location.href = 'login.html';
    });
    kargatuGelak();
});
