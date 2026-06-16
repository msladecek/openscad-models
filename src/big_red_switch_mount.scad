include <BOSL2/std.scad>

wall = 2;

hole_diameter = 6.4;
hole_spacing = [20, 15];

switch_body_size = [16.5, 29.2, 18.5];
switch_peg_size = [6.3, 0.7, 10];
switch_peg_spacing = 23.8;
switch_bolt_diameter = 11.8;
switch_bolt_length = 8.8;
switch_lever_length = 17;
switch_lever_diameter = 4;

switch_plate_size = [17, 41.6, 0.8];

bolt_diameter = 3.2;
nut_size = 6.2;
nut_height = 2.7;

plate_thickness = 1.6;
plate_rim_height = 11;
plate_rim_offset = 39.5 - plate_thickness - switch_plate_size.z;

$fn = 64;

module switch(plate=false) {
	cuboid(switch_body_size, except=[BOTTOM], rounding=0.5, anchor=TOP) {
		attach(BOTTOM, TOP)
		ycopies(n=2, spacing=switch_peg_spacing)
		cuboid(switch_peg_size, edges=[BOTTOM+LEFT, BOTTOM+RIGHT], chamfer=1);

		attach(TOP, BOTTOM)
		zcyl(d=switch_bolt_diameter, length=switch_bolt_length, rounding2=0.5);

		if (plate) {
			attach(TOP, BOTTOM, align=BACK)
			up(2)
			cuboid(switch_plate_size, except=[TOP, BOTTOM], rounding=0.5);
		}
	};
}

module mounting_box() {
	width = hole_spacing.x + hole_diameter + 2 * wall;
	height = switch_body_size.y * 2;
	length_bottom = switch_body_size.z + switch_peg_size.z + 20;
	angle = 30;
	depth = 60;

	// rot(from=TOP, to=FRONT)
	diff()
	rect_tube(size=[width, height], length=depth, wall=wall) {
		attach_part("inside")
		attach(BACK, BOTTOM, spin=90)
		cuboid([depth, width, nut_height]);

		attach(BACK, BOTTOM, align=TOP)
		xcopies(spacing=hole_spacing.x, 2)
		fwd(plate_rim_offset)
		fwd(hole_spacing.y/2)
		ycopies(spacing=hole_spacing.y, 2)
		zcyl(h=plate_thickness/2, d=hole_diameter)
		attach(TOP, TOP, inside=true)
		down(0.01)
		tag("remove")
		zcyl(h=(plate_thickness/2 + nut_height), d=bolt_diameter)
		attach(BOTTOM, TOP)
		regular_prism(n=6, h=nut_height, r=nut_size/2, anchor=BOTTOM, spin=30);

		attach(TOP, BACK)
		down(wall)
		cuboid([width, wall, height]) {
			attach(BACK, FRONT)
			cuboid([width, switch_body_size.z/2, height])
			attach(FRONT, TOP, inside=true)
			cuboid([switch_body_size.x, switch_body_size.y, switch_body_size.z]);

			attach(FRONT, CENTER, inside=true)
			up(0.01)
			zcyl(h=2*wall, d=switch_bolt_diameter);
		}
	}
}

module mounting_plate() {
	diff()
	cuboid(
		size=[1.5 * hole_spacing.x, 1.5 * hole_spacing.y, wall],
		except=[TOP, BOTTOM],
		rounding=2,
	)
	attach(TOP, BOTTOM)
	xcopies(spacing=hole_spacing.x, 2)
	ycopies(spacing=hole_spacing.y, 2)
	zcyl(h=plate_thickness/2, d=hole_diameter)
	attach(TOP, TOP, inside=true)
	down(0.01)
	tag("remove")
	zcyl(h=3*wall, d=bolt_diameter);
}


*
xcopies(spacing=hole_spacing.x, 2)
ycopies(spacing=hole_spacing.y, 2)
zcyl(h=2, d=hole_diameter);

// switch(plate=true);
mounting_box();

down(20)
mounting_plate();
