# 3dhaz – fizetési terminál ház

MXW01 (Fun Print) mini hőnyomtató + Samsung Galaxy S21 FE, egyben kártyaterminál-kinézettel.

![elöl](docs/front.png)

## Fájlok
- `cad/terminal.scad` – paraméteres OpenSCAD forrás (`PART = "base" | "top" | "assembly"`)
- `stl/terminal_base.stl` / `.3mf` – talp (nyomtatóakna + hátsó kábeltér)
- `stl/terminal_top.stl` / `.3mf` – fedél + ferde telefonbölcső egy darabban

## Fő méretek (mm)
- Külső: 87 × 172, talp 47 magas, fedél teteje 49,4, telefon teteje ~192.
- Nyomtatóakna: 82,6 × 107,5 (R16), fülzseb hátul, 1,25–1,6 ráhagyás körbe.
- Papírkimenet: 67 × 8 a fedélen, elejétől 53,5–61,5; előtte fogazott tépőél.
- Telefon: 52°, alsó éle 20 mm-rel a fedél felett; a papírrés és a tartóperem között ~10,5 mm szabad.
- Jobb oldal: 28 × 35 ablak a papírkinyitónak. Bal oldal: 39 × 32 ablak a bekapcsolónak.
- Belső válaszfalon 20 × 18 USB-C átvezetés, hátul alul 16 × 11 kábelkivezetés.

## Nyomtatás
- Mindkét rész úgy, ahogy exportálva van (talp: padló lent; felső rész: fedél lent). Támasz nem kell.
- PLA/PETG, 3–4 fal, 15–20 % infill.
- Rögzítés: 4 db M3 × 12 süllyesztett fejű önmetsző csavar (furat Ø2,6). Hőbetéthez a furatot Ø4-re kell állítani a .scad-ban.
- 4 db Ø10 gumitalp a talp alá.

## Összerakás / papírcsere
Nyomtató be felülről (fülek hátra, a kinyitó a jobb oldali ablakba kerül), kábel a válaszfalon át, hátul ki.
Fedél rá, 4 csavar. Papírcsere: telefon ki → 4 csavar ki → felső rész le → nyomtató ki.
A telefon töltőkábele a bölcső alsó, középső nyílásán megy be az ék alá, a fedél nyílásán át a hátsó kábeltérbe (90°-os USB-C dugó ajánlott).
