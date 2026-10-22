# E1T1-3WAG2

## Egituraren laburpena

- `frontend/`: HTML, CSS eta JavaScript.
- `backend/api/`: PHP APIa; eskaerak jaso eta JSON erantzunak ematen ditu.
- `backend/config/`: datu-basearen konexioa eta saioaren konfigurazioa.
- `db/e1inbentarioa.sql`: datu-basea, taulak eta hasierako datuak.
- `index.html`: proiektuaren hasierako orria; loginera birbideratzen du.

## Instalazioa (Apache + PHP + MySQL/MariaDB)

1. Kopiatu `E1T1-3WAG2` karpeta Apache-ren web direktorioan, adibidez `/var/www/html/E1T1-3WAG2`.
2. Inportatu `db/e1inbentarioa.sql` phpMyAdmin bidez edo terminaletik. SQL fitxategiak `e1inbentarioa` datu-basea sortzen du.
3. Ireki `backend/config/db.php` eta egiaztatu MySQL erabiltzailea eta pasahitza. Lehenetsitako balioak `wesuser` eta `123456` dira; zure instalazioan desberdinak badira, aldatu edo ezarri `DB_HOST`, `DB_NAME`, `DB_USER` eta `DB_PASS` ingurune-aldagaiak.
4. Egiaztatu Apache-n PHP eta `pdo_mysql` luzapena aktibatuta daudela.
5. Ireki `http://localhost/E1T1-3WAG2/` edo `http://localhost/E1T1-3WAG2/frontend/login.html`.

Ez ireki HTML fitxategiak zuzenean `file://` bidez: PHP APIak Apache/PHP zerbitzariaren bidez erabili behar dira.

## Nola dago banatuta

- HTML-k orrien egitura dauka.
- CSS-k itxura kontrolatzen du.
- JavaScript-ek `fetch()` bidez deitzen dio PHP APIari.
- PHP-k saioak kudeatzen ditu, sarrerak balioztatzen ditu eta PDO bidez MySQL kontsultatzen du.
- APIak JSON erantzunak ematen ditu.

## API nagusiak

- `backend/api/login.php`: saioa hasi.
- `backend/api/logout.php`: saioa itxi.
- `backend/api/baliabideak.php`: baliabideak zerrendatu, bilatu edo ID bidez eskuratu.
- `backend/api/sortuBaliabide.php`: baliabidea sortu edo eguneratu.
- `backend/api/ezabatuBaliabide.php`: baliabidea ezabatu.
- `backend/api/erabiltzaileak.php`: erabiltzaileak zerrendatu.

## Kontuan hartu

SQL dump-ean agertzen diren erabiltzaileen pasahitz-hashak aurrez dauden datuak dira; ezin da haien pasahitza ondorioztatu. Saioa hasteko arazoak badaude, ezarri pasahitz berria datu-basean `password_hash()` erabiliz eta egiaztatu `backend/config/db.php`-ko konexio-datuak.

`backend/config/.htaccess` fitxategiak konfigurazio-fitxategien zuzeneko sarbidea blokeatzen du Apache-n. Apache zerbitzariak `.htaccess` onartu behar du (`AllowOverride All`) arau hori aplikatzeko.
