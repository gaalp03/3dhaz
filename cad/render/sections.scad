// Metszetrajzok a három pattintós kötésről (piros = kampós rész, türkiz = ellendarab), a valódi modellből vágva
PART_OVERRIDE = "none";
include <../terminal.scad>
RED = [0.90, 0.25, 0.15]; TEAL = [0.38, 0.75, 0.77]; GREY = [0.80, 0.80, 0.80];
module p_base() { base(); base_lips(); }
module p_back() back_full();
module p_top()  top();
module p_lid()  lid();
// x = c sík: 2D (s, t)
module secx(c) multmatrix([[0,1,0,0],[1,0,0,0],[0,0,1,0]]) projection(cut = true) rotate([0, 90, 0]) translate([-c, 0, 0]) children();
// s = c sík: 2D (x, t)
module secs(c) projection(cut = true) rotate([-90, 0, 0]) translate([0, -c, 0]) children();
module draw(col, z) { color("black") translate([0,0,z]) linear_extrude(0.4) offset(delta = 0.15) children(); color(col) translate([0,0,z+0.4]) linear_extrude(0.4) children(); }
module win(x0, y0, w, h) intersection() { children(); translate([x0, y0]) square([w, h]); }
module panel(dx, title) translate([dx, 0, 0]) { children(); color("black") translate([0, 36, 2]) linear_extrude(0.5) text(title, size = 1.9, font = "DejaVu Sans:style=Bold"); }

// 1) fedél -> sapka (x = 9 sík, a fedél alsó karján át)
panel(0, "1. PAPIRFEDEL -> SAPKA") translate([-152, 42, 0]) {
    draw(TEAL, 0) win(152, -42, 26, 26) secx(9) p_top();
    draw(RED, 1)  win(152, -42, 26, 26) secx(9) p_lid();
    draw(GREY, 0) win(152, -42, 26, 26) secx(9) p_back();
}
// 2) test hátulja -> eleje (s = 10 sík, a rugós karon át)
panel(40, "2. TEST HATA -> ELEJE") translate([-20, 26, 0]) {
    draw(TEAL, 0) win(20, -26, 26, 30) secs(10) p_base();
    draw(RED, 1)  win(20, -26, 26, 30) secs(10) p_back();
}
// 3) test -> sapka (x = 20 sík, az elülső és hátsó nyelven át)
panel(80, "3. TEST -> SAPKA") translate([-140, 28, 0]) {
    draw(TEAL, 0) win(140, -28, 30, 32) secx(20) p_top();
    draw(RED, 1)  win(140, -28, 30, 32) secx(20) p_base();
    draw(RED, 1)  win(140, -28, 30, 32) secx(20) p_back();
}
