// Hordozható fizetési terminál – MXW01 hőnyomtató + Samsung Galaxy S21 FE + mágneses Qi
// Koordináták: X szélesség (0 = közép), Y mélység (0 = eleje, a kijelző felőli oldal), Z magasság (0 = asztal)
// PART = "base" (bölcső + markolat + nyomtatóház-padló) | "top" (nyomtató-burkolat) | "assembly"
PART = "assembly";
$fn = 64;

// ---------------- általános ----------------
wall = 2.2;           // oldalfal
top_t = 2.4;          // tető
W = 87;               // teljes szélesség
eps = 0.02;

// ---------------- nyomtató (MXW01) ----------------
pr_w = 80; pr_h = 43; pr_l = 105; pr_r = 15;
ear_l = 7.5; ear_gap = 23.2; ear_t = 7.5;
slot_from_back = 51;
clr = 1.3;
cav_w = pr_w + 2*clr;                  // 82.6
pr_y0 = wall + 1.25;                   // nyomtató eleje (doboz-lokális)
pr_y1 = pr_y0 + pr_l;                  // test hátulja
cav_y1 = pr_y1 + 1.25;                 // test-üreg vége
ear_y1 = pr_y1 + ear_l + 1.25 + 5;     // fülzseb + hely a 90°-os USB-C dugónak
box_L = ear_y1 + wall;                 // 124.4
cav_h = pr_h + 1.6;                    // 44.6
hood_h = cav_h + top_t;                // 47
slot_y = pr_y1 - slot_from_back;       // papírnyílás közepe (lokális)

// ---------------- telefon (S21 FE, tok nélkül) ----------------
ph_L = 155.7; ph_W = 74.5; ph_T = 7.9;
ang = 55;                              // kijelző dőlése a vízszinteshez
P0 = [10.4, 12];                       // telefon alsó-hátsó éle (Y,Z)
u = [cos(ang), sin(ang)];
n = [-sin(ang), cos(ang)];
function pt(s,t) = P0 + s*u + t*n;
lipT = ph_T + 2.3;                     // perem a kijelző síkja előtt
pocket_w = ph_W + 2;                   // 76.5
cheek = pocket_w/2;                    // 38.25
plate_thick = 12;                      // Qi-zóna (alsó 2/3)
plate_thin = 3;                        // NFC-zóna (felső 1/3): vékony, fémmentes
s_hood = ph_L + 3.5;                   // 159.2 – ennyi hely kell a behelyezéshez
s_top = s_hood + 2.8;                  // 162
qi_s = 72; qi_d = 58;                  // Qi + mágnesgyűrű zseb (Ø58, ~10.8 mély)

// ---------------- nyomtatóház helye ----------------
box_y0 = 100;                          // doboz eleje
floor_z0 = 145;                        // padló alja
floor_t = 7.4;                         // padló (benne kábelcsatorna)
floor_z1 = floor_z0 + floor_t;         // 152.4 – nyomtató alja
R_box = 8;

// ---------------- markolat-láb ----------------
leg_y0 = 192; leg_y1 = 222; leg_w = 44; leg_r = 10; leg_wall = 2.4;

// csavarok (doboz-lokális): M3 felülről, anya oldalról a padlóba
scr = [[37.5, 6], [-37.5, 6], [37.5, box_L-6], [-37.5, box_L-6]];

// ---------------- segédek ----------------
module rrect(w, l, r) hull() for (x=[-w/2+r, w/2-r], y=[r, l-r]) translate([x,y]) circle(r);
module pf() translate([0, P0[0], P0[1]]) rotate([ang,0,0]) children();   // telefon-koordináták: X, s, t
module bx(x0,x1,s0,s1,t0,t1) translate([x0,s0,t0]) cube([x1-x0, s1-s0, t1-t0]);
module bxs(x0,x1,s0,s1,t0,t1) { bx(x0,x1,s0,s1,t0,t1); bx(-x1,-x0,s0,s1,t0,t1); }
module boxloc() translate([0, box_y0, 0]) children();

// ================= BÖLCSŐ (telefon-koordinátákban) =================
module cradle_body() {
    pf() {
        // hátlap: alul vastag (Qi), felül vékony (NFC), átmenet ferdén
        bx(-W/2, W/2, -4, 104, -plate_thick, 0);
        hull() { bx(-W/2, W/2, 100, 104, -plate_thick, 0); bx(-W/2, W/2, 100, 116, -plate_thin, 0); }
        bx(-W/2, W/2, 100, s_top, -plate_thin, 0);
        // oldalsínek (a telefon szélességén kívül, bennük a Qi kábelcsatorna)
        bxs(37.5, W/2, -4, s_top, -plate_thick, 0);
        // alsó talpak / tartóperem (középen 44 mm nyitva: USB-C, hangszóró, SIM)
        bxs(22, W/2, -4, 0, -plate_thick, lipT);
        bxs(22, cheek, -0.5, 2.5, ph_T + 0.3, lipT);           // alsó perem (csak a kávát fogja)
        bxs(cheek - eps, W/2, -0.5, 25, -eps, lipT);           // alsó oldalpofák
        bx(-W/2, -cheek + eps, 135, s_top, -eps, lipT);        // bal felső pofa
        bx(cheek - eps, W/2, 152, s_top, -eps, lipT);          // jobb felső: rövid, a gombok szabadok
        // felső "kalap": behelyezéskor a telefon teteje ide csúszik fel
        bx(-W/2, W/2, s_hood, s_top, -plate_thick, lipT);
        bx(-cheek - eps, cheek + eps, ph_L - 2, s_hood + eps, ph_T + 0.3, lipT);
    }
    // talp-lapolás az asztalhoz
    for (sx = [-1, 1]) hull() {
        pf() bx(sx > 0 ? 22 : -W/2, sx > 0 ? W/2 : -22, -4, 0, -plate_thick, lipT);
        translate([sx > 0 ? 22 : -W/2, -0.3, 0]) cube([W/2 - 22, 18.2, 0.01]);
    }
    // nyak: a bölcső teteje és a nyomtatóház padlója között
    difference() {
        hull() {
            pf() bx(-W/2, W/2, s_hood, s_top, -plate_thick, lipT);
            translate([-W/2 + R_box, box_y0, floor_z0]) cube([W - 2*R_box, 30, 0.01]);
            translate([-W/2, box_y0 + R_box, floor_z0]) cube([W, 22, 0.01]);
        }
        translate([-W, box_y0, floor_z0]) cube([2*W, 300, 100]);
    }
}

module cradle_cuts() {
    pf() {
        // Qi + mágnesgyűrű zseb hátulról, 1.2 mm héj a telefon felé
        translate([0, qi_s, -plate_thick - 1]) cylinder(d = qi_d, h = plate_thick - 1.2 + 1);
        // kábel a zsebtől a jobb oldalsínig (a Qi-zónában, nem az NFC mögött)
        bx(25, 42.25, qi_s - 2.5, qi_s + 2.5, -10, -5);
        // csatorna a jobb oldalsínben felfelé
        bx(38.75, 42.25, qi_s - 2.5, s_top - 2, -10, -5);
        // NFC érintési zóna jelölése a vékony rész hátulján (bemélyített célkör)
        translate([0, 132, -plate_thin - 0.01]) difference() {
            cylinder(d = 30, h = 0.7); translate([0, 0, -1]) cylinder(d = 27, h = 3);
        }
        translate([0, 132, -plate_thin - 0.01]) cylinder(d = 8, h = 0.7);
    }
    // csatorna a nyakon át a padlóba
    hull() {
        pf() bx(38.75, 42.25, s_top - 6, s_top - 2, -10, -5);
        translate([27, box_y0 + 4, floor_z0 + 1.5]) cube([5, 5, 4.5]);
    }
}

// ================= MARKOLAT-LÁB =================
module leg_body() {
    hull() for (x = [-leg_w/2 + leg_r, leg_w/2 - leg_r], y = [leg_y0 + leg_r, leg_y1 - leg_r])
        translate([x, y, 0]) cylinder(r = leg_r, h = floor_z0 + 0.5);
}
module leg_cuts() {
    // üreges: kábel + 1→2 USB-C táp-elosztó helye
    translate([0, 0, leg_wall]) hull()
        for (x = [-leg_w/2 + leg_r, leg_w/2 - leg_r], y = [leg_y0 + leg_r, leg_y1 - leg_r])
            translate([x, y, 0]) cylinder(r = leg_r - leg_wall, h = floor_z0 + 2 - leg_wall);
    // USB-C táp-bemenet hátul, alul (beépíthető USB-C aljzathoz)
    translate([0, leg_y1 + 1, 14]) rotate([90, 0, 0]) {
        hull() for (x = [-3.25, 3.25]) translate([x, 0, 0]) cylinder(d = 7.5, h = 8);
        hull() for (x = [-6, 6]) translate([x, 0, 0]) cylinder(d = 11, h = 2.5);
    }
    // 2 db M2.5 furat az aljzat peremének (opcionális)
    for (x = [-10, 10]) translate([x, leg_y1 + 1, 14]) rotate([90, 0, 0]) cylinder(d = 2.2, h = 8);
}

// ================= PADLÓ (a nyomtatóház alja, a talp része) =================
module floor_body() boxloc() translate([0, 0, floor_z0]) linear_extrude(floor_t) rrect(W, box_L, R_box);
module floor_cuts() {
    boxloc() {
        // Qi kábelcsatorna a padlóban (zárt), előről a lábig
        translate([27, 4, floor_z0 + 1.5]) cube([5, leg_y0 + 12 - box_y0 - 4, 4.5]);
        translate([12, leg_y0 + 6 - box_y0, floor_z0 + 1.5]) cube([20, 6, 4.5]);
        translate([12, leg_y0 + 6 - box_y0, floor_z0 - 3]) cube([6, 6, 9]);
        // nyomtató USB-C kábele: a fülek között le a lábba
        translate([-10, pr_y1 + 1, floor_z0 - 3]) cube([20, leg_y1 - box_y0 - pr_y1 - 4, floor_t + 4]);
        // csavarok + oldalról betolható M3 anya
        for (p = scr) {
            translate([p[0], p[1], floor_z0 - 6]) cylinder(d = 3.4, h = 20);
            translate([p[0] > 0 ? p[0] - 2.9 : -W/2 - 1, p[1] - 3, floor_z0 + 2.4])
                cube([W/2 - abs(p[0]) + 2.9 + 1, 6, 2.8]);
        }
    }
}

module base() {
    difference() {
        union() { cradle_body(); leg_body(); floor_body(); }
        cradle_cuts(); leg_cuts(); floor_cuts();
    }
}

// ================= NYOMTATÓ-BURKOLAT (felső rész) =================
module hood() boxloc() translate([0, 0, floor_z1]) difference() {
    linear_extrude(hood_h) rrect(W, box_L, R_box);
    // üreg: lekerekített test + fülzseb
    translate([0, 0, -1]) linear_extrude(cav_h + 1) {
        translate([0, wall]) rrect(cav_w, pr_l + 2.5, pr_r + clr);
        translate([-(ear_gap/2 + ear_t + 2), cav_y1 - 20]) square([ear_gap + 2*ear_t + 4, ear_y1 - cav_y1 + 20]);
    }
    // papírkimenet fogazott tépőéllel (fogak a kijelző felőli élen)
    translate([0, 0, cav_h - 1]) linear_extrude(top_t + 2)
        polygon(concat([[-33.5, slot_y + 4], [33.5, slot_y + 4]],
                       [for (i = [0:22]) each [[33.5 - i*3, slot_y - 4], [33.5 - i*3 - 1.5, slot_y - 2.4]]],
                       [[-33.5, slot_y - 4]]));
    // BAL: bekapcsoló ablak (hátuljától 6..45, aljától 6..38)
    translate([-W/2 - 1, pr_y1 - 45, 6]) cube([wall + 2, 39, 32]);
    // JOBB: papírkinyitó ablak, alul nyitott (a burkolat így rácsúszik a kiálló reteszre)
    translate([W/2 - wall - 1, pr_y0 + 40 - 14, -1]) cube([wall + 2, 28, 23]);
    // hátul USB-C kivágás (egyenes kábelhez kívülről)
    translate([-8, box_L - wall - 1, 4]) cube([16, wall + 2, 12]);
    // csavarfurat + mély süllyesztés felülről
    for (p = scr) translate([p[0], p[1], -1]) {
        cylinder(d = 3.4, h = 20);
        translate([0, 0, 9]) cylinder(d = 6.5, h = hood_h);
    }
}

// ================= makettek =================
module printer_dummy() color("turquoise", 0.6) boxloc() translate([0, pr_y0, floor_z1]) {
    linear_extrude(pr_h) rrect(pr_w, pr_l, pr_r);
    for (s = [-1, 1]) translate([s*(ear_gap/2 + ear_t/2) - ear_t/2, pr_l - 1, 10]) cube([ear_t, ear_l + 1, 25]);
}
module phone_dummy() color("black", 0.75) pf() bx(-ph_W/2, ph_W/2, 0, ph_L, 0, ph_T);
module qi_dummy() color("orange", 0.8) pf() translate([0, qi_s, -1.2 - 7]) cylinder(d = 56, h = 7);

if (PART == "base") translate([0, 0, floor_z1]) rotate([0, 180, 0]) base();          // padló tetejével az ágyon
else if (PART == "top") translate([0, 0, floor_z1 + hood_h]) rotate([0, 180, 0]) hood(); // tetővel az ágyon
else if (PART == "assembly") { color("gainsboro") base(); color("silver") hood(); printer_dummy(); phone_dummy(); qi_dummy(); }
