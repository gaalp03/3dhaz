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
cap_bw = 5;                        // sapka alsó fala (benne a csavarfejek)
s_pf = s_cap + cap_bw + clr;       // nyomtató eleje (163.3)
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
lid_t = -30;                       // osztósík a sapka és a fedél között
cap_back = cav_t0 - 2.4;           // sapka hátlapja (-39.8)
lip_s0 = s_cap - 4;                // a sapka elülső pereme ráhajlik a telefon tetejére
slot_s = s_pb - slot_from_back;    // papírnyílás közepe a sapka elején

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
    // test-hát csavarok (süllyesztett, a telefon alatt, a Qi zónában)
    for (p = body_screws) translate([p[0], p[1], -deck_t - 1]) {
        cylinder(d = 3.4, h = 20);
        translate([0, 0, deck_t + 1 - 1.8]) cylinder(d1 = 3.4, d2 = 6.8, h = 1.81);
        translate([0, 0, deck_t + 1]) cylinder(d = 6.8, h = 12);   // csavarhúzó-hozzáférés a tálcafalon át
    }
    // sapka-csavarok anyái (nejlon M3), hátulról betolva
    for (x = [-20, 20]) {
        translate([x, s_cap - 14, -3.5]) rotate([-90, 0, 0]) cylinder(d = 3.4, h = 20);
        bx(x - 2.9, x + 2.9, s_cap - 9, s_cap - 6.3, -deck_t - 1, -0.6);
    }
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
        // fülek a sapka rögzítéséhez
        bxs(22, nfc_hw + 1, s_cap - 8, s_cap, t_back, -15);
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
    // csavarok a fülekben + anyafészek hátulról
    for (x = [-28, 28]) {
        translate([x, s_cap - 14, -18.5]) rotate([-90, 0, 0]) cylinder(d = 3.4, h = 20);
        bx(x - 2.9, x + 2.9, s_cap - 6, s_cap - 3.3, t_back - 1, -15.5);
    }
}
module back_bosses() for (p = body_screws) translate([p[0], p[1], t_back + 1]) difference() {
    cylinder(r = 3.5, h = -deck_t - t_back - 1);
    translate([0, 0, 2]) cylinder(d = 2.6, h = 40);
}
module back_full() { back(); back_bosses(); }

// ================= SAPKA (nyomtatóház) =================
module cap_outer() {
    hull() {
        translate([0, 0, lid_t - 6]) linear_extrude(cap_front - 1.5 - lid_t + 6) rrect(C_hw, s_cap, s_top, 9);
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
lid_screws = [[42.5, s_pf + 3], [-42.5, s_pf + 3], [40.5, s_pb - 1], [-40.5, s_pb - 1]];
module cap_inside_parts() {
    // fedélcsavar-oszlopok a sarkokban
    for (p = lid_screws) translate([p[0], p[1], cav_t0 - 1]) cylinder(r = 3.5, h = cav_t1 - cav_t0 + 1);
    // oldalvezetők: a nyomtatót középre fogják, köztük fut a kábel
    for (sx = [-1, 1]) {
        translate([sx > 0 ? pr_w/2 + clr : -cav_hw - 0.5, 0, 0]) {
            bx(0, side_gap - clr + 0.5, s_pf + 8, s_pb - 8, t_pf - 4, cav_t1 + eps);
            if (sx < 0) bx(0, side_gap - clr + 0.5, s_pf + 8, s_pb - 8, cav_t0 - eps, t_pb + 3);
            else {
                bx(0, side_gap - clr + 0.5, s_pf + 8, s_pf + 22, cav_t0 - eps, t_pb + 3);
                bx(0, side_gap - clr + 0.5, s_pf + 60, s_pb - 8, cav_t0 - eps, t_pb + 3);
            }
        }
    }
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
    // sapka -> test csavarok (nejlon M3), fej a sapka alsó falában
    for (p = [[20, -3.5], [-20, -3.5], [28, -18.5], [-28, -18.5]]) {
        translate([p[0], s_cap - 1, p[1]]) rotate([-90, 0, 0]) cylinder(d = 3.4, h = cap_bw + 2);
        translate([p[0], cav_s0 - 3, p[1]]) rotate([-90, 0, 0]) cylinder(d = 6.5, h = 10);
    }
    // fedélcsavarok menetfurata
    for (p = lid_screws) translate([p[0], p[1], lid_t - 1]) cylinder(d = 2.6, h = 14);
}
module top() intersection() { cap_full(); bx(-80, 80, 100, 400, lid_t, 40); }
module lid() difference() {
    intersection() { cap_full(); bx(-80, 80, 100, 400, -80, lid_t); }
    for (p = lid_screws) translate([p[0], p[1], cap_back - 1]) {
        cylinder(d = 3.4, h = 20);
        cylinder(d = 6.5, h = 1 + (lid_t - cap_back) - 4);
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
