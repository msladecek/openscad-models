include <BOSL2/std.scad>
include <BOSL2/hinges.scad>

square_profile = [7, 5];
round_profile_diameter = 4;

$fn = 64;
wall = 1.2;
offset = 4;
seg_gap = 0.2;

module hinge(inner)
	knuckle_hinge(
		length=square_profile[0] + 2 * wall,
		segs=3,
		arm_height=0,
		arm_angle=90,
		offset=offset,
		knuckle_diam=square_profile[1] + 2 * wall,
		gap=seg_gap,
		in_place=true,
		inner=inner,
		anchor=CENTER,
	)
	children();

module square_hinge(inner)
	hinge(inner=inner) {
		attach(BOTTOM, TOP)
		cuboid([square_profile[0] + 2 * wall, square_profile[1] + 2 * wall, wall])
		attach(BOTTOM, TOP)
		rect_tube(isize=square_profile, wall=wall, height=8);

		children();
	}

module square_square_hinge()
	square_hinge(inner=false)
	attach(CENTER, CENTER)
	square_hinge(inner=true);


xcopies(n=3, spacing=20)
xrot(90)
square_square_hinge();
