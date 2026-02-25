include <BOSL2/std.scad>
include <BOSL2/screws.scad>

wall = 2.5;
width = 32;
length = 33.5;
tab_length = 2.5;
width_with_tabs = 37.6;
rounding_radius1 = 10;
rounding_radius2 = 16;
grip_width = 67;
screw_distance = 38;

function socket_profile() =
	union(
		rect([width, length], rounding=[rounding_radius1, rounding_radius1, rounding_radius2, rounding_radius2]),
		back(
			tab_length/3 * 2,
			rect([width_with_tabs, tab_length])
		)
	);

outer_profile = rect(
	[width_with_tabs + 2 * wall, length + 2 * wall],
	rounding=[rounding_radius1 + 2 * wall,  rounding_radius1 + 2 * wall, 0, 0]
);
inner_profile = socket_profile();

$fn = 32;

diff()
linear_sweep(difference(outer_profile, inner_profile), height=6.5) {
	xflip_copy()
	attach(TOP, BOTTOM, align=FRONT+LEFT)
	fwd(2)
	wedge([wall, 16, 10]);

	attach(FRONT, BACK, align=BOTTOM)
	cuboid([width_with_tabs + 2 * wall, wall, 6.5])
	attach(FRONT, BACK, align=BOTTOM)
	xrot(5)
	down(2.5)
	cuboid([grip_width, wall, 36], except=[FRONT, BACK], rounding=18)
	attach(FRONT, BOTTOM)
	xcopies(n=2, spacing=screw_distance)
	down(10)
	screw_hole("M3", l=20);
}
