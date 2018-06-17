// chosen dimensions
insertion_hole_d = 18;
insertion_height = 110;
clearance_d = 50;
rounding_radius = 3;
extra_width = 1;
slot_count = 2;

epsilon = 0.01;
// aliases
rr = rounding_radius;
rd = rounding_radius * 2;
slot_spacing = clearance_d;

// calculated
clearance_r = clearance_d / 2;
round_bar_d = rd + epsilon;
basic_width = insertion_hole_d + round_bar_d * 2 + extra_width * 2 + clearance_d * (slot_count - 1);
stickout = clearance_r + insertion_hole_d / 2 + rr + extra_width;

// Coordinate scheme: x = vertical as mounted, y = depth (perpendicular to wall), z = width

main();

module main() {
    minkowski() {
        sphere(r=rounding_radius, $fn=8);
        
        shrunk_geometry();
    }
}

module shrunk_geometry() {
    // back plate
    translate([0, 0, -(basic_width - rd) / 2])
    cube([insertion_height, epsilon, basic_width - rd]);
    
    // base
    translate([0, 0, -(basic_width - rd) / 2])
    cube([epsilon, stickout, basic_width - rd]);
    fillet();

    translate([insertion_height / 2, 0, 0]) {
        ring();
        fillet();
        scale([-1, 1, 1]) fillet();
    }
    translate([insertion_height, 0, 0]) {
        ring();
        scale([-1, 1, 1]) fillet();
    }
}

module ring() {
    difference() {
        translate([0, 0, -(basic_width - rd) / 2])
        cube([epsilon, stickout, basic_width - rd]);
        
        for (i = [0:slot_count - 1]) {
            translate([0, clearance_d / 2, (i - slot_count / 2 + 0.5) * slot_spacing])
            rotate([0, 90, 0])
            rotate([0, 0, 90])
            cylinder(d=insertion_hole_d + rd, h=1000, center=true, $fn=6);
        }
    }
}

//translate([0, 0, basic_width])
//fillet();
module fillet() {
    r = rd;
    h = basic_width - rd;
    rotate([0, 0, 180])
    translate([-r, -r, 0])
    difference() {
        translate([0, 0, -h / 2])
        cube([r, r, h]);
        cylinder(r=r, h=h + epsilon * 2, center=true, $fn=16);
    }
}