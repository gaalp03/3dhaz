// A bal oldali hosszabbított bekapcsológomb metszete a gomb tengelyén (t = t_btn sík), nyugalomban és végig benyomva
PART_OVERRIDE = "none";
include <../terminal.scad>
RED = [0.90, 0.25, 0.15]; TEAL = [0.38, 0.75, 0.77]; GREY = [0.80, 0.80, 0.80]; DARK = [0.25, 0.25, 0.27];
module sect() projection(cut = true) translate([0, 0, -t_btn]) children();
module draw(col, z) { color("black") translate([0,0,z]) linear_extrude(0.4) offset(delta = 0.12) children(); color(col) translate([0,0,z+0.4]) linear_extrude(0.4) children(); }
module win() intersection() { children(); translate([-52, s_btn - 11]) square([16, 22]); }
module panel(dx, press, title) translate([dx, 0, 0]) {
    draw(TEAL, 0) win() sect() top();
    draw(GREY, 0) win() sect() printer_dummy();
    draw(RED, 1) win() sect() btn_outer(press);
    draw(DARK, 1) win() sect() btn_inner(press);
}
panel(0, 0, "NYUGALOMBAN");
panel(20, btn_travel, "BENYOMVA (2.2 mm)");
