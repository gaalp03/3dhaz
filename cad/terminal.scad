// Hordozható fizetési terminál, Teya PRO / SUNMI felépítéssel
// MXW01 (Fun Print) hőnyomtató a "sapkában", alatta Samsung Galaxy S21 FE (tok nélkül), mögötte mágneses Qi + powerbank.
//
// Készülék-koordináták (minden modul ebben készül):
//   x = szélesség (0 = közép, + = jobb, a kijelzőre nézve)
//   s = hossz a telefon mentén (0 = a telefon alja, + = felfelé a sapka felé)   -> OpenSCAD Y
//   t = vastagság (0 = a telefon hátlapja, + = a kijelző felé / előre)           -> OpenSCAD Z
// A kézben tartott helyzetet (kb. 52°) csak az "assembly" nézet forgatja be.
//
// PART = "base"  : test eleje (telefontálca + Qi zseb)
//        "back"  : test hátulja (powerbank-rekesz + oldalsínek)
//        "top"   : nyomtató-sapka (papírnyílás, ablakok)
//        "lid"   : sapka hátlapja / papírcsere-fedél
//        "assembly", "assembly_flat"
//
// Rögzítés: csavar nélküli, nyomtatott pattintós (cantilever snap-fit) kötések, fém nélkül.
//   1. fedél -> sapka : felül 2 zsanér-nyelv (horonyba), alul 2 rugós kar; nyitás a sapka alján lévő 2 résen át
//   2. test hát -> test eleje: 4 rugós kar a lap réseibe (a telefon alatt rejtve)
//   3. test -> sapka : 4 lapos, XY-ban nyomtatott nyelv a sapka alsó falába; oldás belülről
// Kampó: ~30°-os beszálló rámpa, derékszögű tartóél, ~0.3 mm hézag, ékes (filézett) tő.
PART = is_undef(PART_OVERRIDE) ? "assembly" : PART_OVERRIDE;
$fn = 72;
eps = 0.02;

// ---------------- telefon: S21 FE ----------------
ph_L = 155.7; ph_W = 74.5; ph_T = 7.9;
pocket_hw = ph_W/2 + 1;            // 38.25
hold_ang = 52;                     // kézben / bemutató nézetben a kijelző dőlése

// ---------------- test ----------------
B_hw = 43.5;                       // test fél-szélessége (87 mm)
deck_t = 7;                        // a telefon mögötti lap (benne a Qi zseb)
t_back = -22;                      // test hátlapja
wall = 2.2;
tray_top = ph_T - 2;               // a tálca oldalfala a kijelző síkja alatt marad
s_bot = -5;                        // test alja
s_cap = 157;                       // itt kezdődik a sapka
qi_s = 72; qi_d = 58; qi_depth = 6;// Qi + mágnesgyűrű zseb (elölről, a telefon hátához simul)
bay_s1 = 103;                      // powerbank-rekesz vége (a felső harmad alatt!)
nfc_hw = 35.3;                     // NFC-bemélyedés fél-szélessége hátul
nfc_s0 = 114;                      // a bemélyedés itt éri el a teljes mélységet
lane_x0 = 37.5; lane_x1 = 41.3;    // kábelcsatorna az oldalsínekben

// ---------------- nyomtató (MXW01), sapka ----------------
pr_w = 80; pr_h = 43; pr_l = 105; pr_r = 15;
ear_l = 7.5; ear_gap = 23.2; ear_t = 7.5;
slot_from_back = 51;
clr = 1.3;
cap_front = ph_T + 3;              // 10.9 – a sapka eleje 3 mm-rel a kijelző előtt
cap_fw = 2.4;                      // elülső fal
t_pf = cap_front - cap_fw - 1.6;   // nyomtató arca (6.9)
t_pb = t_pf - pr_h;                // nyomtató alja (-36.1)
cap_bw = 5;                        // sapka alsó fala (itt kattannak a nyelvek)
snap_room = 3;                     // hely a sapka alján a kampóknak
s_pf = s_cap + cap_bw + clr + snap_room;  // nyomtató eleje (166.3)
s_pb = s_pf + pr_l;                // nyomtató test hátulja (268.3)
s_ear = s_pb + ear_l;              // fülek vége (275.8)
side_gap = 4.8;                    // oldalt hely kábelnek (bal) / reteszkiállásnak (jobb)
cav_hw = pr_w/2 + side_gap;        // 44.8
C_hw = cav_hw + wall;              // sapka fél-szélessége (47 -> 94 mm)
cav_s0 = s_cap + cap_bw;           // 162
cav_s1 = s_pb + clr;               // test-üreg vége
ear_s1 = s_ear + clr + 5;          // fülzseb + hely 90°-os USB-C dugónak
s_top = ear_s1 + 2.4;              // sapka teteje
cav_t0 = t_pb - 1.3;               // üreg hátul (-37.4)
cav_t1 = cap_front - cap_fw;       // üreg elöl (8.5)
lid_t = -36.4;                     // osztósík: a fedél szinte lapos hátlap
cap_back = cav_t0 - 2.4;           // sapka hátlapja (-39.8)
lip_s0 = s_cap - 4;                // a sapka elülső pereme ráhajlik a telefon tetejére
slot_s = s_pb - slot_from_back;    // papírnyílás közepe a sapka elején

// ---------------- pattintós kötések ----------------
sn_gap = 0.3;                      // hézag
sn_hook = 1.0;                     // kampó kiállása (beakadás)
sn_ramp = sn_hook / tan(30);       // 30°-os beszálló él hossza
// (3) test -> sapka nyelvek: XY-ban fekvő lapos kar, t irányban hajlik
tg_th = 1.6;                       // nyelv vastagsága
tg_catch = cav_s0 + sn_gap;        // tartóél helye (a sapka alsó falának belső síkja mögött)
tg_tip = tg_catch + 0.7 + sn_ramp; // nyelv vége
tgf_x = [16, 24];                  // elülső nyelvek (a lapból), x tartomány, ±
tgf_root = 143;
tgb_x = [18, 26];                  // hátsó nyelvek (a hát füleiből), ±
tgb_root = 141;
// (2) test hát -> eleje: függőleges rugós karok a rekeszben
bk_x = [34.9, 36.5];               // kar x tartománya (kampó kifelé), ±
bk_s = [6, 84];                    // karok kezdete s mentén (8 mm szélesek)
bk_ledge = -2.4;                   // a lap résében a tartóél
// (1) fedél: alsó karok és felső zsanér-nyelvek
la_x = [5, 13];                    // alsó karok, ±
la_s0 = cav_s0 + sn_gap;           // kar külső síkja
la_th = 1.2;
la_top = -23.5;                    // kar vége (szabad hossz ~10 mm)
la_catch = -26.1;                  // tartóél (a sapka alsó falán lévő ablak alsó éle + hézag)
lh_x = [13, 19];                   // felső zsanér-nyelvek, ±
// körbefutó illesztőperem (nyelv + horony), mint a nyomtatott dobozoknál
rim_w = 1.0; rim_h = 1.8; rim_gap = 0.25;

// ---------------- segédek ----------------
module bx(x0,x1,s0,s1,t0,t1) translate([x0,s0,t0]) cube([x1-x0, s1-s0, t1-t0]);
module bxs(x0,x1,s0,s1,t0,t1) { bx(x0,x1,s0,s1,t0,t1); bx(-x1,-x0,s0,s1,t0,t1); }
module rrect(hw, s0, s1, r) hull() for (x=[-hw+r, hw-r], s=[s0+r, s1-r]) translate([x,s]) circle(r);
// (x,t) profil kihúzása s mentén
module ext_s(s0, s1) translate([0, s1, 0]) rotate([90,0,0]) linear_extrude(s1 - s0) children();
module body_profile(t0, t1) hull() {
    for (x = [-B_hw + 6, B_hw - 6]) translate([x, t_back + 6]) circle(6);
    for (x = [-B_hw + 1.2, B_hw - 1.2]) translate([x, tray_top - 1.2]) circle(1.2);
}

// ================= TEST ELEJE: telefontálca + Qi =================
module body_outer() ext_s(s_bot, s_cap) body_profile();
module base() difference() {
    intersection() { body_outer(); bx(-60, 60, s_bot - 1, s_cap + 1, -deck_t, 40); }
    // telefonzseb (a teteje a sapka pereme alá fut)
    bx(-pocket_hw, pocket_hw, 0, s_cap + 1, 0, 40);
    // jobb oldal: gombok (hangerő + bekapcsoló) szabadon
    bx(pocket_hw - 1, B_hw + 1, 78, 152, 1.5, 40);
    // alul középen nyitva: USB-C, hangszóró, SIM
    bx(-24, 24, s_bot - 1, 1, -1, 40);
    // Qi + mágnesgyűrű zseb elölről, a telefon hátához simul
    translate([0, qi_s, -qi_depth]) cylinder(d = qi_d, h = qi_depth + 1);
    translate([22, qi_s, -deck_t - 1]) cylinder(d = 6, h = 3);       // Qi kábel a rekeszbe
    // opcionális tartalék csavarfuratok (alapból NEM kellenek)
    for (p = body_screws) translate([p[0], p[1], -deck_t - 1]) {
        cylinder(d = 3.4, h = 20);
        translate([0, 0, deck_t + 1 - 1.8]) cylinder(d1 = 3.4, d2 = 6.8, h = 1.81);
        translate([0, 0, deck_t + 1]) cylinder(d = 6.8, h = 12);   // csavarhúzó-hozzáférés a tálcafalon át
    }
    // (3) ablak a lapban a sapka-nyelvek fölött (a nyelv szabadon hajolhat)
    bxs(tgf_x[0] - 0.4, tgf_x[1] + 0.4, tgf_root, s_cap + 1, -deck_t + tg_th, 1);
    bxs(tgf_x[0] - 0.4, tgf_x[0], tgf_root, s_cap + 1, -deck_t - 1, 1);
    bxs(tgf_x[1], tgf_x[1] + 0.4, tgf_root, s_cap + 1, -deck_t - 1, 1);
    // (2) rések a hátsó rész rugós karjainak, felül kiszélesítve a tartóélhez
    for (s0 = bk_s) {
        bxs(bk_x[0] - sn_gap - 1.0, bk_x[1] + sn_gap, s0 - sn_gap, s0 + 8 + sn_gap, -deck_t - 1, bk_ledge);
        bxs(bk_x[0] - sn_gap - 1.0, bk_x[1] + sn_hook + sn_gap, s0 - sn_gap, s0 + 8 + sn_gap, bk_ledge - eps, 0.5);
    }
    // horony a test-hát körbefutó pereméhez (a lap hátoldalán)
    translate([0, 0, -deck_t - 1]) linear_extrude(1 + rim_h + 0.2) back_rim_2d(rim_gap);
    // NFC érintési zóna jelölése a lap hátulján
    translate([0, 135, -deck_t - 0.01]) difference() {
        cylinder(d = 30, h = 0.7); translate([0, 0, -1]) cylinder(d = 27, h = 3);
    }
    translate([0, 135, -deck_t - 0.01]) cylinder(d = 8, h = 0.7);
}
// alsó tartóperem (csak a kávát fogja, a kijelző szabad)
module base_lips() {
    bxs(24, B_hw - 0.6, s_bot, 0, tray_top - eps, ph_T + 2.3);
    bxs(24, pocket_hw, -eps, 2.5, ph_T + 0.3, ph_T + 2.3);
    // (3) sapka-nyelvek: a lap alsó rétegében fekszenek, a lap végén túl a sapkába nyúlnak
    for (m = [0, 1]) mirror([m, 0, 0]) {
        bx(tgf_x[0], tgf_x[1], tgf_root, tg_tip, -deck_t, -deck_t + tg_th);
        hull() {   // ékes tő
            bx(tgf_x[0], tgf_x[1], tgf_root - 0.5, tgf_root, -deck_t, -deck_t + tg_th + 1.6);
            bx(tgf_x[0], tgf_x[1], tgf_root, tgf_root + 3, -deck_t, -deck_t + tg_th);
        }
        hull() {   // kampó: derékszögű tartóél, 30°-os rámpa
            bx(tgf_x[0], tgf_x[1], tg_catch, tg_catch + 0.7, -deck_t + tg_th - eps, -deck_t + tg_th + sn_hook);
            bx(tgf_x[0], tgf_x[1], tg_tip - 0.05, tg_tip, -deck_t + tg_th - eps, -deck_t + tg_th);
        }
    }
}
body_screws = [[37, 2], [-37, 2], [37, 99], [-37, 99]];

// ================= TEST HÁTULJA: powerbank-rekesz + oldalsínek =================
module back_outer() intersection() {
    union() {
        ext_s(s_bot, bay_s1) body_profile();
        // ferde átmenet az NFC-bemélyedésbe (45°, támasz nélkül nyomtatható)
        hull() {
            intersection() { ext_s(bay_s1 - eps, bay_s1) body_profile(); bx(-nfc_hw, nfc_hw, 0, 400, -50, 50); }
            bx(-nfc_hw, nfc_hw, nfc_s0 - eps, nfc_s0, -deck_t - 2, -deck_t);
        }
        // oldalsínek a sapkáig
        intersection() { ext_s(bay_s1 - 5, s_cap) body_profile(); union() { bxs(nfc_hw, 60, 0, 400, -50, 50); } }
        // fülek a sapka rögzítéséhez (bennük a pattintós nyelvek)
        bxs(15.5, nfc_hw + 1, tgb_root - 2, s_cap, t_back, -15);
    }
    bx(-60, 60, s_bot - 1, s_cap + 1, -60, -deck_t);
}
module back() difference() {
    back_outer();
    // powerbank-rekesz: kb. 105 × 82 × 12.8 mm
    bx(-B_hw + wall, B_hw - wall, s_bot + wall, bay_s1, t_back + wall, -deck_t + 1);
    hull() {
        bx(-nfc_hw + wall, nfc_hw - wall, bay_s1 - 1, bay_s1, t_back + wall, -deck_t + 1);
        bx(-nfc_hw + wall, nfc_hw - wall, nfc_s0 - 2*wall - eps, nfc_s0 - 2*wall, -deck_t - 0.01, -deck_t + 1);
    }
    // kábelcsatorna mindkét oldalsínben a sapkáig
    bxs(lane_x0, lane_x1, bay_s1 - 6, s_cap + 1, t_back + wall, -deck_t + 1);
    // powerbank töltőnyílás alul
    bx(-15, 15, s_bot - 1, s_bot + wall + 1, -18, -10);
    // (3) a nyelvek körül kivágás a fülekben
    bxs(tgb_x[0] - 0.4, tgb_x[1] + 0.4, tgb_root, s_cap + 1, t_back + tg_th, -14);
    bxs(tgb_x[0] - 0.4, tgb_x[0], tgb_root, s_cap + 1, t_back - 1, -14);
    bxs(tgb_x[1], tgb_x[1] + 0.4, tgb_root, s_cap + 1, t_back - 1, -14);
}
module back_snaps() for (m = [0, 1]) mirror([m, 0, 0]) {
    // (3) sapka-nyelv a hátlap síkjában
    bx(tgb_x[0], tgb_x[1], tgb_root, tg_tip, t_back, t_back + tg_th);
    hull() {
        bx(tgb_x[0], tgb_x[1], tgb_root - 0.5, tgb_root, t_back, t_back + tg_th + 1.6);
        bx(tgb_x[0], tgb_x[1], tgb_root, tgb_root + 3, t_back, t_back + tg_th);
    }
    hull() {
        bx(tgb_x[0], tgb_x[1], tg_catch, tg_catch + 0.7, t_back + tg_th - eps, t_back + tg_th + sn_hook);
        bx(tgb_x[0], tgb_x[1], tg_tip - 0.05, tg_tip, t_back + tg_th - eps, t_back + tg_th);
    }
    // (2) rugós karok a lap réseibe, kampó kifelé
    for (s0 = bk_s) {
        bx(bk_x[0], bk_x[1], s0, s0 + 8, t_back + wall - eps, -0.4);
        hull() {   // ékes tő
            bx(bk_x[0] - 1.2, bk_x[1] + 1.2, s0, s0 + 8, t_back + wall - eps, t_back + wall + 0.1);
            bx(bk_x[0], bk_x[1], s0, s0 + 8, t_back + wall - eps, t_back + wall + 2.2);
        }
        hull() {   // derékszögű tartóél lefelé, 30°-os rámpa felül
            bx(bk_x[1] - eps, bk_x[1] + sn_hook, s0, s0 + 8, bk_ledge + sn_gap, bk_ledge + sn_gap + 0.2);
            bx(bk_x[1] - eps, bk_x[1], s0, s0 + 8, bk_ledge + sn_gap, bk_ledge + sn_gap + 0.2 + sn_ramp);
        }
    }
}
module back_bosses() for (p = body_screws) translate([p[0], p[1], t_back + 1]) difference() {
    cylinder(r = 3.5, h = -deck_t - t_back - 1);
    translate([0, 0, 2]) cylinder(d = 2.6, h = 40);
}
// a perem 2D alakja (x,s): a hát külső falának belső élén fut, alul és két oldalt
module back_rim_2d(g = 0) difference() {
    translate([-(B_hw - wall + rim_w + g), s_bot + wall - rim_w - g]) square([2*(B_hw - wall + rim_w + g), s_cap - 0.5 - (s_bot + wall - rim_w - g)]);
    translate([-(B_hw - wall - g), s_bot + wall + g]) square([2*(B_hw - wall - g), 400]);
}
module back_rim() translate([0, 0, -deck_t - eps]) linear_extrude(rim_h) back_rim_2d(0);
module back_full() { back(); back_bosses(); back_snaps(); back_rim(); }

// ================= SAPKA (nyomtatóház) =================
module cap_outer() {
    hull() {
        translate([0, 0, cap_back + 3.8]) linear_extrude(cap_front - 1.5 - cap_back - 3.8) rrect(C_hw, s_cap, s_top, 9);
        translate([0, 0, cap_front - 1.5]) linear_extrude(1.5) rrect(C_hw - 1.5, s_cap + 1.5, s_top - 1.5, 7.5);
        translate([0, 0, cap_back]) linear_extrude(1) rrect(C_hw - 7, s_cap + 7, s_top - 7, 4);
    }
    // elülső perem: ráül a telefon felső élére
    translate([0, 0, ph_T + 0.3]) linear_extrude(cap_front - ph_T - 0.3) rrect(C_hw - 1.5, lip_s0, s_cap + 10, 4);
}
module cap_cavity() {
    translate([0, 0, cav_t0]) linear_extrude(cav_t1 - cav_t0) {
        rrect(cav_hw, cav_s0, cav_s1, 18);
        translate([-(ear_gap/2 + ear_t + 2), cav_s1 - 20]) square([ear_gap + 2*ear_t + 4, ear_s1 - cav_s1 + 20]);
    }
}
module cap_inside_parts() {
    // oldalvezetők elöl: a nyomtatót középre fogják, mögöttük fut a kábel
    for (sx = [-1, 1]) translate([sx > 0 ? pr_w/2 + clr : -cav_hw - 0.5, 0, 0])
        bx(0, side_gap - clr + 0.5, s_pf + 8, s_pb - 8, t_pf - 4, cav_t1 + eps);
    // alsó ütköző: a nyomtató nem csúszik rá a kampókra
    bxs(27, 34, cav_s0 - eps, s_pf - 0.3, t_pb + 2, t_pf - 2);
}
module cap_full() difference() {
    union() { difference() { cap_outer(); cap_cavity(); } intersection() { cap_inside_parts(); cap_outer(); } }
    // a telefon teteje becsúszik a perem alá (behelyezéskor +3.5 mm)
    bx(-pocket_hw, pocket_hw, lip_s0 - 1, ph_L + 3.5, -0.2, ph_T + 0.3);
    // a test eleje illeszkedik a perem alá
    translate([0, 0, 0]) bx(-B_hw - 0.2, B_hw + 0.2, lip_s0 - 1, s_cap, -deck_t - 0.2, ph_T + 0.3);
    // papírnyílás fogazott tépőéllel (a fogak az alsó, kijelző felőli élen)
    translate([0, 0, cav_t1 - 1]) linear_extrude(cap_fw + 3)
        polygon(concat([[33.5, slot_s + 4], [-33.5, slot_s + 4]],
                       [for (i = [0:21]) each [[-33.5 + i*3, slot_s - 4], [-33.5 + i*3 + 1.5, slot_s - 2.4]]],
                       [[33.5, slot_s - 4]]));
    // BAL: bekapcsoló ablak (nyomtató hátuljától 6..45, aljától 6..38)
    bx(-C_hw - 1, -cav_hw + eps - 3, s_pb - 45, s_pb - 6, t_pb + 6, t_pb + 38);
    // JOBB: papírkinyitó ablak, hátrafelé nyitott (a nyomtató hátulról, a kiálló retesszel együtt tehető be)
    bx(cav_hw - 3, C_hw + 1, s_pf + 40 - 14, s_pf + 40 + 14, lid_t - 20, t_pb + 30);
    // USB-C a fülek között (a sapka tetején, kívülről is dugható)
    bx(-8, 8, ear_s1 - 1, s_top + 1, t_pb + 4, t_pb + 16);
    // kábelátvezetés a test oldalsíneiből (powerbank -> nyomtató)
    bxs(28, lane_x1, s_cap - 1, cav_s0 + 1, t_back + wall, -deck_t - 1);
    // (3) rések a test nyelveinek (lefelé hely a hajláshoz)
    bxs(tgf_x[0] - 0.4, tgf_x[1] + 0.4, s_cap - 1, cav_s0 + eps, -deck_t - 1.6, -deck_t + tg_th + sn_gap);
    bxs(tgb_x[0] - 0.4, tgb_x[1] + 0.4, s_cap - 1, cav_s0 + eps, t_back - 1.6, t_back + tg_th + sn_gap);
    // (1) ablak a fedél alsó karjainak: itt kattannak, és innen nyomhatók ki (nyitás)
    bxs(la_x[0] - 0.4, la_x[1] + 0.4, s_cap - 1, cav_s0 + eps, la_catch - sn_gap, la_top + sn_gap);
    // (1) horony a sapka tetőfalában a fedél zsanér-nyelveinek
    bxs(lh_x[0] - 0.4, lh_x[1] + 0.4, ear_s1 - 0.6, ear_s1 + 1.2, lid_t + 0.5, lid_t + 1.8);   // alatta 0.5 mm perem tart
}
module top() intersection() { cap_full(); bx(-80, 80, 100, 400, lid_t, 40); }
module cav_2d() {
    rrect(cav_hw, cav_s0, cav_s1, 18);
    translate([-(ear_gap/2 + ear_t + 2), cav_s1 - 20]) square([ear_gap + 2*ear_t + 4, ear_s1 - cav_s1 + 20]);
}
module printer_2d() translate([0, s_pf + pr_l/2]) offset(r = pr_r) square([pr_w - 2*pr_r, pr_l - 2*pr_r], center = true);
// fedél pereme: a sapka nyílásába ül, körbe zár (a kampók és a nyomtató helyén megszakad)
module lid_rim() translate([0, 0, cav_t0 - eps]) linear_extrude(lid_t - cav_t0 + rim_h) difference() {
    offset(delta = -rim_gap) cav_2d();
    offset(delta = -rim_gap - rim_w) cav_2d();
    offset(r = 0.6) printer_2d();
    for (m = [0, 1]) mirror([m, 0]) {
        translate([la_x[0] - 1, cav_s0 - 1]) square([la_x[1] - la_x[0] + 2, 4]);
        translate([lh_x[0] - 1, ear_s1 - 3]) square([lh_x[1] - lh_x[0] + 2, 4]);
    }
    translate([cav_hw - 4, s_pf + 40 - 15]) square([10, 30]);    // retesz-ablak
}
module lid() {
    intersection() { cap_full(); bx(-80, 80, 100, 400, -80, lid_t); }
    lid_rim();
    for (m = [0, 1]) mirror([m, 0, 0]) {
        // alsó rugós karok (kampó lefelé, a sapka alsó falának ablakába)
        bx(la_x[0], la_x[1], la_s0, la_s0 + la_th, cav_t0 - eps, la_top);
        hull() {   // ékes tő
            bx(la_x[0], la_x[1], la_s0, la_s0 + la_th + 1.5, cav_t0 - eps, cav_t0 + 0.1);
            bx(la_x[0], la_x[1], la_s0, la_s0 + la_th, cav_t0 - eps, cav_t0 + 1.5);
        }
        hull() {   // derékszögű tartóél, 30°-os rámpa
            bx(la_x[0], la_x[1], la_s0 - sn_hook, la_s0 + eps, la_catch, la_catch + 0.8);
            bx(la_x[0], la_x[1], la_s0 - 0.05, la_s0 + eps, la_catch, la_catch + 0.8 + sn_ramp);
        }
        // felső zsanér-nyelvek (L alak): becsúsznak a tetőfal hornyába
        bx(lh_x[0], lh_x[1], ear_s1 - 1.6, ear_s1 - 0.3, cav_t0 - eps, lid_t + 1.5);
        bx(lh_x[0], lh_x[1], ear_s1 - 0.3 - eps, ear_s1 + 0.9, lid_t + 0.8, lid_t + 1.5);
    }
}

// ================= makettek =================
module printer_dummy() color("turquoise", 0.65) {
    translate([0, 0, t_pb]) linear_extrude(pr_h) translate([0, s_pf + pr_l/2]) offset(r = pr_r) square([pr_w - 2*pr_r, pr_l - 2*pr_r], center = true);
    for (sx = [-1, 1]) bx(sx*(ear_gap/2 + ear_t/2) - ear_t/2, sx*(ear_gap/2 + ear_t/2) + ear_t/2, s_pb - 1, s_ear, t_pb + 10, t_pb + 35);
}
module phone_dummy() color([0.08, 0.08, 0.1]) bx(-ph_W/2, ph_W/2, 0, ph_L, 0, ph_T);
module screen_dummy() color([0.25, 0.4, 0.75]) bx(-ph_W/2 + 2, ph_W/2 - 2, 5, ph_L - 4, ph_T - 0.05, ph_T + 0.01);
module qi_dummy() color("orange") translate([0, qi_s, -qi_depth + 0.3]) cylinder(d = 56, h = qi_depth - 0.5);
module powerbank_dummy() color("dimgray") bx(-32.5, 32.5, 0, 98, t_back + wall + 0.3, t_back + wall + 10.3);

module assembly_flat(show_inside = false) {
    color([0.12, 0.13, 0.14]) { base(); base_lips(); back_full(); }
    color([0.85, 0.92, 0.18]) top();
    color([0.12, 0.13, 0.14]) lid();
    phone_dummy(); screen_dummy();
    if (show_inside) { printer_dummy(); qi_dummy(); powerbank_dummy(); }
}

if (PART == "base") translate([0, 0, deck_t]) { base(); base_lips(); }                 // a lap hátulja az ágyon
else if (PART == "back") translate([0, 0, -t_back]) back_full();                        // hátlappal az ágyon
else if (PART == "top") translate([0, 0, cap_front]) rotate([0, 180, 0]) top();          // elejével az ágyon
else if (PART == "lid") translate([0, 0, -cap_back]) lid();                             // hátlappal az ágyon
else if (PART == "raw_base") { base(); base_lips(); }      // készülék-koordinátában (előnézethez)
else if (PART == "raw_back") back_full();
else if (PART == "raw_top") top();
else if (PART == "raw_lid") lid();
else if (PART == "raw_dummies") { phone_dummy(); screen_dummy(); printer_dummy(); qi_dummy(); powerbank_dummy(); }
else if (PART == "assembly_flat") assembly_flat(true);
else if (PART == "assembly") rotate([hold_ang, 0, 0]) assembly_flat(false);
