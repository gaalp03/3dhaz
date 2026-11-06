// Fizetési terminál ház – MXW01 hőnyomtató + Samsung S21 FE
// X: szélesség (0 = közép), Y: mélység (0 = eleje/kezelő), Z: magasság (0 = asztal)
// PART = "base" | "top" | "assembly"
PART = "assembly";
$fn = 64;

// ---------- alapméretek ----------
wall  = 2.2;     // oldalfal
floor_t = 2.4;   // padló
lid_t = 2.4;     // fedél
clr   = 1.3;     // ráhagyás a nyomtató körül

// nyomtató (tolómérős + becsült)
pr_w = 80; pr_h = 43; pr_l = 105; pr_r = 15;
ear_l = 7.5; ear_gap = 23.2; ear_t = 7.5;
slot_from_back = 51;

// ház
W   = pr_w + 2*clr + 2*wall;          // 86.6 -> ~87
D   = 172;                             // teljes mélység (farok a stabilitáshoz)
Hb  = floor_t + pr_h + 1.6;            // talp falmagasság (47)
zL  = Hb + lid_t;                      // fedél teteje (49.4)
R_out = 8;

cav_w  = pr_w + 2*clr;
pr_y0  = wall + 1.25;                  // nyomtató eleje
pr_y1  = pr_y0 + pr_l;                 // nyomtató test vége
cav_y1 = pr_y1 + 1.25;                 // test-üreg vége
ear_y1 = pr_y1 + ear_l + 1.25;         // fülzseb vége
part_y1 = ear_y1 + wall;               // válaszfal hátsó síkja
slot_y = pr_y1 - slot_from_back;       // papírnyílás közepe

// telefon
ph_L = 155.7; ph_W = 74.5; ph_T = 7.9;
ang = 52;                              // dőlés a vízszinteshez
u = [cos(ang), sin(ang)];              // felfelé a telefon mentén
n = [-sin(ang), cos(ang)];             // a kijelző normálisa
P0 = [80, zL + 20];                    // telefon alsó-hátsó éle
function pt(s,t) = P0 + s*u + t*n;
lipT = ph_T + 2.3;
plate_len = 125; plate_t = 3;
pocket_w = ph_W + 2;
pan_in = W/2 - 3;                      // oldalpanel belső síkja

// csavarok
scr = [[ 37.5, 6], [-37.5, 6], [37.5, D-6], [-37.5, D-6]];

// ---------- segédek ----------
module rrect(w, l, r) {                // XY, eleje y=0, középre x
    hull() for (x=[-w/2+r, w/2-r], y=[r, l-r]) translate([x,y]) circle(r);
}
module ext(x0, x1, pts) {              // YZ profil kihúzása X mentén
    translate([x0-0.02,0,0]) rotate([90,0,90]) linear_extrude(x1-x0+0.04) polygon(pts);
}
module both(x0, x1, pts) { ext(x0,x1,pts); ext(-x1,-x0,pts); }

// ---------- TALP ----------
module base() {
    difference() {
        union() {
            linear_extrude(Hb) rrect(W, D, R_out);
        }
        // nyomtató üreg (lekerekített test + fülzseb)
        translate([0,0,floor_t]) linear_extrude(Hb) {
            translate([0,wall]) rrect(cav_w, pr_l+2.5, pr_r+clr);
            translate([-(ear_gap/2+ear_t+2), cav_y1-20]) square([ear_gap+2*ear_t+4, ear_y1-cav_y1+20]);
        }
        // hátsó kábeltér
        translate([0,0,floor_t]) linear_extrude(Hb)
            difference() {
                translate([-cav_w/2, part_y1]) square([cav_w, D-wall-part_y1]);
                for (s=[-1,1]) translate([s*37.5, D-6]) circle(4.5);
            }
        // USB-C átvezető a válaszfalon (nagyvonalú)
        translate([-10, ear_y1-1, 6]) cube([20, wall+2, 18]);
        // kábelkivezetés hátul, alul
        translate([-8, D-wall-1, -1]) cube([16, wall+2, 11]);
        // JOBB: papírkinyitó ablak (felül nyitott, a fedél zárja)
        translate([W/2-wall-1, pr_y0+40-14, 12]) cube([wall+2, 28, Hb]);
        // BAL: bekapcsoló ablak (hátuljától 6..45 mm, asztaltól 6..38 mm)
        translate([-W/2-1, pr_y1-45, 6]) cube([wall+2, 39, 32]);
        // csavarfuratok (M3 önmetsző, Ø2.6)
        for (p=scr) translate([p[0],p[1],Hb-14]) cylinder(d=2.6, h=15);
        // gumitalp mélyedések
        for (x=[-32,32], y=[12, D-14]) translate([x,y,-0.01]) cylinder(d=10.5, h=1);
    }
    // hátsó csavaroszlopok
    for (s=[-1,1]) translate([s*37.5, D-6, 0]) difference() {
        hull() { cylinder(r=4.5, h=Hb); translate([s*3,3,0]) cylinder(r=1, h=Hb); }
        translate([0,0,Hb-14]) cylinder(d=2.6, h=15);
    }
}

// ---------- FEDÉL + TELEFONBÖLCSŐ ----------
K1 = pt(0,-plate_t); K2 = pt(0, lipT);
F  = pt(plate_len, -plate_t);
function plate_under_z(y) = K1[1] + (y-K1[0])/u[0]*u[1];
back_y0 = F[0]-3;

module top() {
    difference() {
        union() {
            // fedéllap
            translate([0,0,Hb]) linear_extrude(lid_t) rrect(W, D, R_out);
            // tépőél (fogazott)
            translate([0, slot_y-4, zL-0.01]) rotate([90,0,0]) linear_extrude(3)
                polygon(concat([[-34.5,0]],
                    [for (i=[0:22]) each [[-34.5+i*3, 2], [-34.5+i*3+1.5, 3.2]]],
                    [[34.5,2],[34.5,0]]));
            // oldalpanelek (ék oldala + alsó pofa)
            both(pan_in, W/2, [[K2[0], zL-0.01], K2, pt(25,lipT), pt(25,0),
                               pt(plate_len,0), F, [F[0], zL-0.01]]);
            // belső pofák (oldalvezetés, csak alul -> a gombok szabadok)
            both(pocket_w/2, pan_in, [pt(-0.5,-0.3), pt(25,-0.3), pt(25,lipT), pt(-0.5,lipT)]);
            // támasztólap
            ext(-pan_in, pan_in, [K1, pt(0,0), pt(plate_len,0), F]);
            // alsó tartóperem (két oldalt, középen nyitva USB/hangszóró/SIM)
            both(22, pan_in, [[K2[0], zL-0.01], K2, pt(0,0), pt(1.5,0), pt(1.5,-plate_t), [pt(1.5,-plate_t)[0], zL-0.01]]);
            both(22, pocket_w/2, [pt(-0.5,ph_T+0.3), pt(2.5,ph_T+0.3), pt(2.5,lipT), pt(-0.5,lipT)]);
            // ék hátfala
            ext(-pan_in, pan_in, [[back_y0, zL-0.01], [F[0], zL-0.01], F+[0,1.5],
                                  [back_y0, plate_under_z(back_y0)+1.5]]);
        }
        // papírkimenet
        translate([0,0,Hb-1]) linear_extrude(lid_t+6) hull()
            for (x=[-33.5+4, 33.5-4]) translate([x, slot_y]) circle(4);
        // csavarok: süllyesztett M3
        for (p=scr) translate([p[0],p[1],Hb-1]) {
            cylinder(d=3.4, h=10);
            translate([0,0,1+lid_t-1.8]) cylinder(d1=3.4, d2=6.8, h=1.81);
        }
        // kábelátvezetés az ékből a hátsó kábeltérbe
        translate([-10, 128, Hb-1]) cube([20, 14, lid_t+2]);
    }
}

// ---------- ellenőrző makettek ----------
module printer_dummy() {
    color("turquoise", 0.6) translate([0, pr_y0, floor_t]) {
        linear_extrude(pr_h) rrect(pr_w, pr_l, pr_r);
        for (s=[-1,1]) translate([s*(ear_gap/2+ear_t/2)-ear_t/2, pr_l-1, 10]) cube([ear_t, ear_l+1, 25]);
    }
}
module phone_dummy() {
    color("black", 0.7) translate([-ph_W/2,0,0]) rotate([90,0,90])
        linear_extrude(ph_W) polygon([pt(0,0), pt(ph_L,0), pt(ph_L,ph_T), pt(0,ph_T)]);
}

if (PART == "base") base();
else if (PART == "top") translate([0,0,-Hb]) top();
else { color("gainsboro") base(); color("silver") top(); printer_dummy(); phone_dummy(); }
