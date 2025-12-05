include <BOSL2/std.scad>

wall = 2;

tweezers_width = 10;
tweezers_depth = 15;
tweezers_height = 60;

shelf_wall_thickness = 1.5;
shelf_wall_height = 37.3;

shelf_edge_thickness = 2.7;
shelf_edge_height = 4.5;

clip_thickness = shelf_wall_thickness + wall;

module base_tray() {
	cuboid([30, 30, 10], except=[TOP, BOTTOM], rounding=3, anchor=BOTTOM);
}

module tool_slot(w, d, h, skew=0, wall=wall, anchor=BOTTOM, spin=0, orient=UP) {
	total_size = [w + 2 * wall, d + 2 * wall, h + wall];
	attachable(anchor, spin, orient, size=total_size) {
		down(total_size[2] / 2)
		cube([w + 2 * wall, d + 2 * wall, wall], anchor=BOTTOM)
			attach(TOP, BOTTOM)
			rect_tube(isize=[w, d], h=(h - wall), wall=wall, ichamfer=0, anchor=BOTTOM)
				attach(TOP, BOTTOM)
				rect_tube(isize1=[w, d], isize2=[w + wall, d + wall], size2=[w + 2 * wall, d + 2 * wall], wall=wall, h=wall, ichamfer=0, anchor=BOTTOM);
		children();
	}
}

module clip(w, wall=wall, orient=UP, anchor=CENTER, spin=0) {
	h = shelf_wall_height / 2;
	attachable(anchor, spin, orient, size=[w + 2 * wall, shelf_wall_thickness + wall, h]) {
		diff()
		back(shelf_wall_thickness / 2)
		cuboid([w + 2 * wall, wall, h], chamfer=1, edges=[TOP+BACK, BOTTOM+BACK], orient=orient, anchor=CENTER, spin=spin)
			tag("keep")
			attach(FRONT, BACK, align=TOP)
			cuboid([w + 2 * wall, shelf_wall_thickness, wall])
				tag("remove")
				attach(BOTTOM, TOP, align=FRONT)
				cuboid([w + 2 * wall, shelf_edge_thickness, shelf_edge_height], chamfer=1, edges=[TOP+BACK, BOTTOM+BACK]);
		children();
	}
}
module tool_slot_with_clip_and_label(lines, w, d, h, text_size=10, orientation="horizontal", wall=wall) {
	difference () {
		tool_slot(w, d, h)
		attach(BACK, FRONT, align=TOP) clip(w);

		up(h)
		fwd(d / 2 + wall)
		rot(from=UP, to=FRONT)
		for (i = [0: len(lines)]) {
			fwd(i * text_size * 1.2)
			if (orientation == "vertical") {
				fwd(text_size)
				text3d(lines[i], h=1, spin=90, size=text_size, atype="ycenter", anchor=RIGHT);
			}
			else {
				fwd(text_size * 2)
				text3d(lines[i], h=1, size=text_size, anchor=CENTER);
			}
		}
	}
}

tool_slot_with_clip_and_label(["KNIPEX"], 51, 14, 50);

right(100)
tool_slot_with_clip_and_label(["Pro'sKit", "Green"], 53, 11, 50);

right(200)
tool_slot_with_clip_and_label(["Pro'sKit", "Yellow"], 46, 8, 50);

right(300)
tool_slot_with_clip_and_label(["knife"], 33, 18, 80, text_size=12, orientation="vertical");

// tweezers set
right(400)
{
	tool_slot_with_clip_and_label(["curved"], 10, 16, 60, text_size=8, orientation="vertical");

	right(1 * (10 + 1.5 * wall))
	tool_slot_with_clip_and_label(["sprung"], 10, 16, 60, text_size=8, orientation="vertical");

	right(2 * (10 + 1.5 * wall))
	tool_slot_with_clip_and_label(["straight"], 10, 16, 60, text_size=8, orientation="vertical");

	right(3 * (10 + 1.5 * wall))
	tool_slot_with_clip_and_label(["spade"], 10, 16, 60, text_size=8, orientation="vertical");
}
