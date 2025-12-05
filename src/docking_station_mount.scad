include <MCAD/boxes.scad>
include <MCAD/nuts_and_bolts.scad>

nothing = 0.01;

height = 30;
width = 206;
depth = 90;
radius = 6;

cable_width = 15;
ventilation_port_height = 9;
ventilation_port_offset_from_the_top = 5;
plate_thickness = 1.7;
hole_diameter = 6;
hole_offset_edge_to_front_edge = 39;
hole_spacing_x = 15;
hole_spacing_y = 240 / 12;
hole_offset = hole_offset_edge_to_front_edge - plate_thickness - hole_diameter / 2;

thickness = 2;
peg_diameter = hole_diameter * 1.5;

bracket_thickness = 2;

nut_width_minor = 5.4;
nut_height = 2.2;

target_holes = [
	[-6, -3],
	[-6, 0],
	[6, -3],
	[6, 0]
];

module station() {
	translate([- depth / 2 + nothing, 0, height / 2])
	roundedCube([depth, width, height + nothing], radius, sidesonly=true, center=true);
}

module holes() {
	for (i = [-8: 8])
	for (j = [-10: 0]) {
		translate([j * hole_spacing_x - hole_offset, i * hole_spacing_y, height])
		cylinder(d = hole_diameter, h = plate_thickness);
	}
}

module fasteners() {
	for (hole = target_holes) {
		i = hole[0];
		j = hole[1];
		translate([j * hole_spacing_x - hole_offset, i * hole_spacing_y, height + plate_thickness + 1])
		rotate([180, 0, 0])
		boltHole(size=3, length=12);
	}
}

module test_secondary_bracket() {
	translate([0, - peg_diameter / 2, plate_thickness])
	cube([hole_spacing_y, peg_diameter, bracket_thickness]);

	cylinder(d = hole_diameter, h = plate_thickness);
	translate([0, 0, plate_thickness])
	cylinder(d = peg_diameter, h = bracket_thickness);

	translate([hole_spacing_y, 0, 0]) {
		cylinder(d = hole_diameter, h = plate_thickness);
		translate([0, 0, plate_thickness])
		cylinder(d = peg_diameter, h = bracket_thickness);
	}
}

module brackets() {
	difference() {
		for (i = [-7, 7]) {
			translate([-3 * hole_spacing_x - hole_offset, i * hole_spacing_y - peg_diameter / 2, height + plate_thickness])
			cube([3 * hole_spacing_x, peg_diameter, bracket_thickness]);

			for (j = [-3, 0]) {
				translate([j * hole_spacing_x - hole_offset, i * hole_spacing_y, height]) {
					cylinder(d = hole_diameter, h = plate_thickness);

					translate([0, 0, plate_thickness])
					cylinder(d = peg_diameter, h = bracket_thickness);
				}
			}
		}
		fasteners();
	}
}

module pegs() {
	difference () {
		for (hole = target_holes) {
			i = hole[0];
			j = hole[1];

			translate([j * hole_spacing_x - hole_offset, i * hole_spacing_y, height]) {
				rotate([180, 0, 0])
				cylinder(d = peg_diameter, h = 2 * thickness);
			}
		}
		fasteners();
	}
}

module cable_port() {
	translate([- depth / 2, - width/2 - thickness / 2, thickness + cable_width / 4])
	rotate([90, 0, 0])
	roundedCube([cable_width, cable_width / 2, thickness + 2 * nothing], r = 2, sidesonly = true, center = true);
}

module cradle_hull() {
	translate([- depth / 2 - thickness / 2, 0, height / 2 - thickness / 2])
	roundedCube([depth + thickness, width + 2 * thickness, height + thickness], radius + thickness, sidesonly=true, center=true);
}

module cradle_front_cutout() {
	translate([- (radius + thickness) / 2, 0, height / 2 + nothing])
	cube([radius + thickness, width + 2 * thickness + 2 * nothing, height], center=true);
}

module cradle_rear_port() {
	port_width = 2 * 41.5;
	difference() {
		translate([- depth - nothing, 0, height / 2 + nothing])
		cube([2 * thickness, width - port_width, height], center=true);

		translate([- depth - thickness - nothing, port_width / 2 + cable_width, 0])
		difference() {
			cube([thickness, cable_width, cable_width]);

			translate([0, 0, cable_width - nothing])
			rotate([0, 90, 0])
			cylinder(r = cable_width, h = thickness + 2 * nothing);
		}

		translate([- depth - thickness - nothing, - port_width / 2 - 2 * cable_width, 0])
		difference() {
			cube([thickness, cable_width, cable_width]);

			translate([0, cable_width, cable_width - nothing])
			rotate([0, 90, 0])
			cylinder(r = cable_width, h = thickness + 2 * nothing);
		}
	}
}

module cradle_ventilation_ports() {
	base_size = 72;
	size = min(base_size, depth - 2 * radius - 4 * thickness);
	translate([- depth / 2 - base_size / 2, width / 2  + thickness + nothing, height])
	rotate([180, 0, 0])
	translate([0, 0, ventilation_port_offset_from_the_top])
	cube([size, width + 2 * thickness + 2 * nothing, ventilation_port_height]);
}

module cradle_attachment_pylons() {
	support_size = 4 * thickness;

	for (hole = target_holes) {
		i = hole[0];
		j = hole[1];

		distance_from_cradle = min(
			abs(i * hole_spacing_y - width/2 - thickness),
			abs(i * hole_spacing_y + width/2 + thickness)
		);
		translate([j * hole_spacing_x - hole_offset, i * hole_spacing_y, height])
		rotate([0, 0, 90])
		rotate([0, 0, sign(i) * 90])
		rotate([0, 180, 0])
		translate([- peg_diameter / 2, 0, 0]) {
			cube([peg_diameter, distance_from_cradle, 2 * thickness]);

			translate([0, distance_from_cradle, 0]) {
				cube([peg_diameter, thickness, height]);

				difference() {
					rotate([90, 0, 0])
					cube([peg_diameter, support_size + 2 * thickness, support_size]);

					rotate([0, 90,  0])
					translate([- 1.5 * support_size, -support_size, - nothing])
					cylinder(h = peg_diameter + 2 * nothing, d=(2 * support_size));
				}
			}
		}
	}
	pegs();
}

module cradle() {
	difference() {
		cradle_hull();
		cradle_front_cutout();
		station();
		cable_port();
		cradle_rear_port();
		cradle_ventilation_ports();
	}
	difference() {
		cradle_attachment_pylons();
		cable_port();
		fasteners();
	}
}

$fn = 100;

// test_secondary_bracket();

// %station();

// %holes();

// color("darkgreen")
// translate([0, 0, 20])
// brackets();

// color("salmon")
// pegs();

cradle();

// fasteners();
