include <BOSL2/std.scad>

wall = 2;
chamfer = wall/3;

thicknesses = [16, 22];

width = 83;
height = 60;

total_length = sum(thicknesses) + (len(thicknesses) + 1) * wall;
total_width = width + 2 * wall;

cuboid([total_width, total_length, wall], anchor=BOTTOM) {
	xflip_copy()
	attach(TOP, BOTTOM, align=LEFT)
	cuboid([wall, total_length, height], edges=[TOP+RIGHT], chamfer=chamfer);

	attach(TOP, BOTTOM, align=FRONT)
	ycopies(spacing=cumsum(concat([0], [for (thickness = thicknesses) thickness + wall]))) {
		edges = $idx == 0 ? [TOP+BACK] : $idx == len(thicknesses) ? [TOP+FRONT] : [TOP+FRONT, TOP+BACK];
		cuboid([total_width, wall, height], edges=edges, chamfer=chamfer);
	}
}
