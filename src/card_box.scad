include <BOSL2/std.scad>


wall = 1.2;
a8 = [52, 74]; // A8

module card_box(card_size, thickness) {
	tag_scope()
	diff()
	cuboid([card_size.x + 2 * wall, thickness + 2 * wall, wall])
	attach(TOP, BOTTOM)
	rect_tube(isize=[card_size.x, thickness], wall=wall, height=card_size.y)
	attach(TOP, BOTTOM)
	rect_tube(
		isize1=[card_size.x, thickness],
		size1=[card_size.x + 2 * wall, thickness + 2 * wall],
		isize2=[card_size.x + wall, thickness + wall],
		size2=[card_size.x + 2 * wall, thickness + 2 * wall],
		height=wall,
	)
	attach(TOP, CENTER)
	tag("remove")
	ycyl(h=(thickness + 2 * wall), d=(card_size.x / 3))
	yflip_copy()
	back(wall/2)
	attach(FRONT, FRONT, inside=true)
	ycyl(h=(wall/2 + 0.01), d1=(card_size.x / 3), d2=(card_size.x / 3 + 2 * wall));
}

$fn = 64;

xdistribute(spacing=100) {
	card_box(a8, 26);
	card_box(a8, 8);
}
