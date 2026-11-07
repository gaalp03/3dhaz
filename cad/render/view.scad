// Színes előnézet a kész alkatrészekből (a terminal.scad "raw_*" exportjaiból)
VIEW = "hold";            // "hold" = kézben, 52°-ban | "flat" | "inside" | "exploded" | "tray" | "button"
PART_OVERRIDE = "none";
include <../terminal.scad>
module parts(inside=false) {
    color([0.13,0.14,0.15]) import("base.stl");
    color([0.13,0.14,0.15]) import("back.stl");
    color([0.86,0.93,0.16]) import("top.stl");
    color([0.13,0.14,0.15]) if (!inside) import("lid.stl");
    color([0.13,0.14,0.15]) import("btn.stl");
    color([0.05,0.05,0.06]) phone_dummy();
    color([0.32,0.45,0.85]) bx(-ph_W/2 + 1.5, ph_W/2 - 1.5, 4, ph_L - 3, ph_T - 0.05, ph_T + 0.02);
    if (inside) { printer_dummy(); qi_dummy(); powerbank_dummy(); }
}
if (VIEW == "hold") rotate([hold_ang,0,0]) parts();
else if (VIEW == "inside") parts(true);
else if (VIEW == "tray") color([0.20,0.21,0.23]) import("base.stl");   // csak a tálca, telefon nélkül
else if (VIEW == "exploded") {   // szétszedett nézet: látszanak a pattintós kampók
    color([0.13,0.14,0.15]) import("base.stl");
    color([0.30,0.31,0.33]) translate([0, 0, -45]) import("back.stl");
    color([0.86,0.93,0.16]) translate([0, 45, 0]) import("top.stl");
    color([0.45,0.46,0.48]) translate([0, 45, -45]) import("lid.stl");
    color([0.13,0.14,0.15]) translate([-25, 45, 0]) import("btn.stl");
}
else if (VIEW == "button") {   // a gomb közelről, a sapka bal fala átlátszó
    color([0.86,0.93,0.16,0.35]) import("top.stl");
    color([0.15,0.15,0.17]) import("btn.stl");
    printer_dummy();
}
else parts();
