include <BOSL2/std.scad>

wall = 2;

hole_diameter = 6;
hole_spacing = [20, 15];

switch_body_size = [16.5, 29.2, 18.5];
switch_peg_size = [6.3, 0.7, 10];
switch_peg_spacing = 23.8;
switch_bolt_diameter = 11.7;
switch_bolt_length = 8.8;
switch_lever_length = 17;
switch_lever_diameter = 4;

switch_plate_size = [17, 41.6, 0.8];

bolt_diameter = 3;
plate_thickness = 1.6;

$fn = 32;

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
	width = 2 * switch_body_size.x + 3 * wall;
	height = switch_body_size.y * 2;
	length_bottom = switch_body_size.z + switch_peg_size.z + 20;
	angle = 30;

	diff()
	prismoid(
		size1=[width, length_bottom],
		size2=[width, undef],
		yang=[90 - angle, 90],
		height=height,
	) {
		*
		#attach(FRONT, TOP, inside=true, spin=180)
		up(2)
		switch(plate=true);

		attach(FRONT, CENTER, inside=true)
		zcyl(d=switch_bolt_diameter, l=3*wall);

		attach(BACK, BACK, inside=true)
		down(0.01)
		prismoid(
			size1=[width - 2 * wall, length_bottom - wall],
			size2=[width - 2 * wall, undef],
			yang=[90 - angle, 90],
			height=(height - 2 * wall),
		);

		attach(BOTTOM, CENTER, inside=true)
		xcopies(spacing=hole_spacing.x, 2)
		ycopies(spacing=hole_spacing.y, 2)
		zcyl(h=3*wall, d=bolt_diameter);
	};
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
	zcyl(h=plate_thickness, d=hole_diameter)
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

down(10)
mounting_plate();
