include <BOSL2/std.scad>

module smts_102(angle=0) {
	body_depth = 5.2;
	body_width = 8.2;
	body_height = 7.1;

	lever_diameter = 2.5;
	lever_height = 9.5;
	lever_core_height = lever_height - lever_diameter;

	cube([body_width, body_depth, body_height], anchor=TOP)
	{
		attach(TOP, BOTTOM)
		cylinder(d=5, h=6)
			attach(TOP, BOTTOM)
			down(3)
			yrot(constrain(angle, -12, 12))
			cylinder(d=lever_diameter, h=(lever_core_height + 3))
				attach(TOP)
				sphere(d=lever_diameter);

		attach(BOTTOM, TOP)
		{
			cube([0.5, 1.5, 4.8]);

			xflip_copy()
			left(5 / 2)
			cube([0.5, 1.5, 3.3]);
		}
	}
}

module msw_13(active=false) {
	width = 19.8;
	depth = 6.4;
	contact_offset_left = 8.8;
	contact_offset_right = 7.3;
	contact_offset = (19.8 - contact_offset_left - contact_offset_right) / 2;
	hole_offset_side = 5.1;
	hole_offset_bottom = 2.5;
	hole_offset_inner = 9.5;
	wheel_diameter = 19.8 - 17.5;

	diff()
	cube([width, depth, 10.2], anchor=TOP)
	{
		attach(BOTTOM, TOP)
		position(LEFT)
		{
			right(contact_offset)
			cube([0.5, 3.3, 4], anchor=BOTTOM);

			right(contact_offset + contact_offset_left)
			cube([0.5, 3.3, 4], anchor=BOTTOM);

			right(contact_offset + contact_offset_left + contact_offset_right)
			cube([0.5, 3.3, 4], anchor=BOTTOM);
		}

		attach(BACK, BOTTOM, align=BOTTOM, inside=true, shiftout=0.01)
		left(width / 2)
		back(2.5 - 2.5 / 2)
		{
			right(5.1)
			cylinder(h=(depth + 0.02), d=2.5);

			right(5.1 + 9.5)
			cylinder(h=(depth + 0.02), d=2.5);
		}

		align(TOP, RIGHT)
		left(2.8)
		yrot(active ? 6 : 0)
		cube([0.5, 5, 1])
			attach(TOP, BOTTOM, align=RIGHT)
			cube([17 + 1 / 2, 5, 0.5])
				attach(TOP, BOTTOM, align=LEFT)
				cube([1, 5, 4.6])
					attach(TOP, LEFT)
					down(wheel_diameter/ 2)
					cylinder(h=5, d=wheel_diameter);
	}
}

module mot1n() {
	down(8.3)
	cylinder(h=27, d=23.8, anchor=TOP)
	{
		attach(TOP)
		{
			cylinder(h=8.3, d=2);

			cylinder(h=1.6, d=6.15);
		}

		attach(BOTTOM, TOP)
		{
			xflip_copy()
			left(17.5 / 2)
			cube([0.3, 3.1, 5]);
		}
	}
}

module mts_223(position="center") {
	lever_tilt = position == "left" ? -12 : position == "right" ? 12 : 0;

	cube([13.2, 12.7, 9.5], anchor=TOP)
	{
		attach(TOP, BOTTOM)
		cyl(h=8.8, d=6)
			attach(TOP, BOTTOM)
			down(4.4)
			yrot(lever_tilt)
			cyl(h=(11 + 4.4),  d=2.4)
				attach(TOP, CENTER)
				sphere(d=2.4);

		attach(BOTTOM, TOP)
		grid_copies(n=[3, 2], spacing=[4.7, 4.8])
		cube([0.8, 2, 4], anchor=TOP);
	}
}

module pbs_10b(position="up") {
	lip = 2.5;
	neck = position == "up" ? 2.3 : 2.3 / 2;

	cyl(h=lip, d=9.5, chamfer1=1, anchor=TOP)
	{
		attach(TOP, BOTTOM)
		cyl(h=7, d=7, rounding2=1, anchor=BOTTOM)
			attach(TOP, BOTTOM)
			cyl(h=neck, d=5, anchor=BOTTOM)
				attach(TOP, BOTTOM)
				cyl(h=3.6, d=6, rounding2=1, anchor=BOTTOM);

		attach(BOTTOM, TOP)
		cyl(h=(8.2  - lip), d=7.2, anchor=TOP)
			attach(BOTTOM, TOP)
			xcopies(n=2, spacing=3.5)
			cube([0.5, 2, 6.4], anchor=TOP);
	}
}

xteink_x4__width = 68;
xteink_x4__length = 114;
xteink_x4__height = 6.3;

module xteink_x4(anchor=CENTER, spin=0, orient=UP) {
	size = [xteink_x4__width, xteink_x4__length, xteink_x4__height];

	top_margin = 6;
	bottom_margin = 17;
	side_margin = 7;

	attachable(anchor, spin, orient, size=size) {
		tag_scope()
		diff()
		cuboid(size, rounding=2)
		attach(TOP, TOP, align=FRONT, inside=true)
		down(0.01)
		back(top_margin)
		tag("remove") cuboid([xteink_x4__width - 2 * side_margin, xteink_x4__length - top_margin - bottom_margin, 0.1], except=[TOP, BOTTOM], rounding=1);

		children();
	}
}

battery_box_2AAA__width = 24.5;
battery_box_2AAA__length = 54.2;
battery_box_2AAA__height = 13.5;

module battery_box_2AAA() {
	rounding_top = 4;
	size = [battery_box_2AAA__width, battery_box_2AAA__length, battery_box_2AAA__height];
	cuboid(size, rounding=rounding_top, edges=[TOP+LEFT, TOP+RIGHT]);
}

led__base_diameter = 5.5;
led__body_diameter = 5;

module led() {
	$fn = 32;
	zcyl(h=0.5, d=led__base_diameter)
	{
		attach(TOP, BOTTOM)
		zcyl(h=8.2, d=led__body_diameter, rounding2=2.5);

		attach(BOTTOM, TOP)
		xdistribute(spacing=2.5) {
			cuboid([0.2, 0.2, 10]);
			cuboid([0.2, 0.2, 12]);
		}
	}
}

