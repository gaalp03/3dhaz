# 3dhaz – hordozható fizetési terminál (Teya PRO felépítés)

MXW01 (Fun Print) mini hőnyomtató + Samsung Galaxy S21 FE (tok nélkül) + mágneses Qi + kis powerbank, egy kézben fogható darabban.
Felül a nyomtató „sapka”, alatta a telefon mint érintőkijelző, ahogy a Teya PRO / SUNMI terminálokon.

![elölről, kézben tartva](docs/front.png)

| oldalnézet | hátulnézet | belül (sapkafedél nélkül) |
|---|---|---|
| ![oldal](docs/side.png) | ![hát](docs/back.png) | ![belül](docs/inside.png) |

## Felépítés
- **Sapka (sárga):** zárt nyomtatóház a telefon tetején. Az elülső pereme 4 mm-en ráül a telefon felső élére, így nincs rés köztük. A nyomtató arccal előre fekszik benne, a blokk a sapka elején, a fogazott tépőélnél jön ki, a kijelzőtől 57 mm-re feljebb.
- **Test:** benne a telefon. A kijelző teljesen szabad: a tálca fala a kijelző síkja alatt marad, alul egy 2 mm-es perem csak a kávát fogja.
- **A telefon mögött:** középen mágneses Qi zseb, alatta powerbank-rekesz. A felső harmad mögött csak műanyag van (7 mm), hátul egy bemélyedéssel a kártyás érintéshez (NFC / Tap to Pay).
- Nincs láb, rúd vagy állvány: az egész egy fogható darab.

## Fő méretek (mm)
| | |
|---|---|
| Teljes | 290 hosszú × 94 széles (sapka) / 87 (test) |
| Vastagság | test 28 (+2 mm kiálló üveg), sapka 51 |
| Kézben / bemutató nézetben | a kijelző kb. 52°-ban dől |
| Telefonzseb | 76,5 × 159,2 (3,5 mm hely a behelyezéshez) |
| Qi + mágnesgyűrű zseb | Ø58 × 6, elölről, közvetlenül a telefon háta mögött; középpontja 72 mm-re a telefon aljától |
| NFC-zóna | a telefon felső 52 mm-e mögött: fém, mágnes és kábel nélkül, 7 mm műanyag, hátul bemélyedés |
| Powerbank-rekesz | 105 × 82 × 12,8 (pl. vékony 5000 mAh-s), a felső harmad alatt; töltőnyílás a test alján |
| Nyomtató-üreg | 89,6 × 107,6 + fülzseb, 45,8 mély; oldalt 4,8 mm kábelhely |
| Papírnyílás | 67 × 8 a sapka elején, fogazott alsó éllel |
| Bekapcsoló ablak (bal) | a nyomtató hátuljától 6–45, aljától 6–38 |
| Papírkinyitó ablak (jobb) | 28 széles, hátrafelé nyitott, a kiálló reteszhez |
| USB-C (fülek között) | 16 × 12 kivágás a sapka tetején, kívülről is dugható |

## Részek (mind ráfér egy 220 × 220-as ágyra, támasz nélkül)
| fájl | mi ez | nyomtatási helyzet |
|---|---|---|
| `stl/terminal_base.stl` / `.3mf` | test eleje: telefontálca + Qi zseb | a lap hátulja az ágyon |
| `stl/terminal_back.stl` / `.3mf` | test hátulja: powerbank-rekesz + oldalsínek | hátlappal az ágyon |
| `stl/terminal_top.stl` / `.3mf` | nyomtató-sapka (papírnyílás, ablakok) | elejével az ágyon |
| `stl/terminal_lid.stl` / `.3mf` | sapka hátlapja (papírcsere-fedél) | hátlappal az ágyon |

Javasolt beállítás: PLA vagy PETG, 3–4 fal, 20 % infill. A sapka sárga, a többi fekete, ha Teya-színeket szeretnél.
Forrás: `cad/terminal.scad` (`PART = base | back | top | lid | assembly`). Színes előnézet: `cad/render/view.scad`.

## Összeszerelés
1. **Qi modul** (kerek, mágnesgyűrűs, Ø50–56, ≤6 mm): elölről a zsebbe kell tenni, a kábelét a lyukon át a rekeszbe vezetni.
2. **Powerbank** a rekeszbe. A test eleje és hátulja 4 db M3 × 16 süllyesztett csavarral áll össze, a csavarok a telefon alatt, az alsó részen vannak.
3. **Nyomtató:** hátulról kell a sapkába tenni, arccal előre, fülekkel felfelé. A reteszt a jobb oldali ablakba kell igazítani. A sapkafedél 4 db M3-mal zárul.
4. **Sapka a testre:** 4 db **nejlon** M3 csavarral, belülről a sapka alsó falán át, nejlon anyával (az anyák hátulról tolhatók be). Ezek a telefon teteje közelében vannak, ezért nem lehetnek fémből.
5. **Belső tápellátás (opcionális):** a powerbankból mindkét oldalsínben fut egy kábelcsatorna a sapkába, a nyomtató mellett fel a fülek közé, ahol 90°-os USB-C dugó kell.
6. **Telefon:** a tetejét fel kell tolni a sapka pereme alá, aztán az alját lenyomni és visszacsúsztatni a perem mögé. Kivétel fordított sorrendben.

**Papírcsere:** sapkafedél le (4 csavar), és a nyomtató hátrafelé kivehető.

## Fontos tudnivalók
- **Az S21 FE nem MagSafe-es, nincs benne mágnes.** A mágneses „odaugráshoz” egy vékony mágneses gyűrűmatrica kell a telefon hátára, középre vagy kicsit lejjebb, de a felső harmadba nem. Matrica nélkül a peremek tartják a telefont, és a Qi így is tölt.
- A papírnyílás a sapka közepén van, nem közvetlenül a kijelző fölött, mint a Teyán. Ezt az MXW01 adottsága szabja meg: a papír 51 mm-re jön ki a hátuljától. Előre, a kijelzőtől elfelé lép ki, a kijelzőbe nem ütközik.
- A nyomtató kb. 52°-ban megdöntve dolgozik. Ezt érdemes egy próbanyomással ellenőrizni.
- A Qi zseb helye (`qi_s`) és a gombok kivágása becsült értékek; a valódi telefonhoz igazítani kell őket.
- A forma Teya PRO-szerű felépítést követ, de nem másolja a Teya formavilágát, logóját vagy színeit.
