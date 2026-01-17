include <BOSL2/std.scad>

wall = 2;

tweezers_width = 10;
tweezers_depth = 15;
tweezers_height = 60;

shelf_wall_thickness = 1.5;
shelf_wall_height = 39;

shelf_edge_thickness = 2.7;
shelf_edge_height = 4.5;

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
	attachable(anchor, spin, orient, size=[w, wall + shelf_edge_thickness, h]) {
		diff("cutout")
		cuboid([w, wall+ shelf_edge_thickness, h], chamfer=1, edges=[TOP+BACK, BOTTOM+BACK], orient=orient, spin=spin)
		attach(FRONT, BACK, align=BOTTOM, inside=true)
		tag("cutout") cuboid([w + 0.02, shelf_wall_thickness, h - wall])
		attach(FRONT, FRONT, align=TOP)
		cuboid([w + 0.02, shelf_edge_thickness - shelf_wall_thickness, shelf_edge_height], chamfer=1, edges=[TOP+BACK, BOTTOM+BACK]);
		children();
	}
}

module backstop(width, wall=wall, orient=UP, anchor=TOP, spin=0) {
	full_height = 2 * wall;
	attachable(anchor, spin, orient, size=[width, shelf_wall_thickness + wall, full_height]) {
		cuboid([width, shelf_wall_thickness + wall, full_height], edges=[BOTTOM+BACK], chamfer=wall, orient=orient, spin=spin, anchor=anchor);
		children();
	}
}

module tool_slot_with_clip_and_label(lines, w, d, h, text_size=10, orientation="horizontal", wall=wall, anchor=BOTTOM, orient=UP, spin=0) {
	full_width = w + 2 * wall;
	attachable(anchor=anchor, spin=spin, orient=orient, size=[full_width, d + 2 * wall + shelf_edge_thickness, h + wall]) {
		diff()
		{
			tool_slot(w, d, h, anchor=BACK)
			{
				attach(BACK, FRONT, align=TOP)
				clip(full_width, wall=wall);

				if (h > shelf_wall_height + 2 * wall) {
					attach(BACK, FRONT, align=TOP)
					fwd(shelf_wall_height)
					backstop(full_width, wall=wall);
				}

				tag("remove")
				position(FRONT)
				down(d / 2 + wall)
				up(h /2)
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
		children();
	}
}

xdistribute(spacing=100) {
	tool_slot_with_clip_and_label(["Caliper"], 94, 24, 100, text_size=20);

	tool_slot_with_clip_and_label(["KNIPEX"], 51, 14, 50);

	tool_slot_with_clip_and_label(["Pro'sKit", "Green"], 53, 12, 50);

	tool_slot_with_clip_and_label(["Pro'sKit", "Yellow"], 46, 8, 50);

	tool_slot_with_clip_and_label(["knife"], 33, 18, 80, text_size=12, orientation="vertical");

	// tweezers set
	tool_slot_with_clip_and_label(["curved"], 10, 16, 60, text_size=8, orientation="vertical")
	attach(RIGHT, LEFT)
	down(0.5 * wall)
	tool_slot_with_clip_and_label(["sprung"], 10, 16, 60, text_size=8, orientation="vertical")
	attach(RIGHT, LEFT)
	down(0.5 * wall)
	tool_slot_with_clip_and_label(["straight"], 10, 16, 60, text_size=8, orientation="vertical")
	attach(RIGHT, LEFT)
	down(0.5 * wall)
	tool_slot_with_clip_and_label(["spade"], 10, 16, 60, text_size=8, orientation="vertical");


	tool_slot_with_clip_and_label(["knife"], 17, 8, 60, text_size=8, orientation="vertical", anchor=BACK+BOTTOM)
	attach(RIGHT, LEFT)
	down(0.5 * wall)
	tool_slot_with_clip_and_label(["marker"], 12, 12, 60, text_size=8, orientation="vertical", anchor=BACK+BOTTOM)
	attach(RIGHT, LEFT)
	down(0.5 * wall)
	tool_slot_with_clip_and_label(["marker"], 12, 12, 60, text_size=8, orientation="vertical", anchor=BACK+BOTTOM)
	attach(RIGHT, LEFT)
	down(0.5 * wall)
	tool_slot_with_clip_and_label(["marker"], 18, 18, 60, text_size=8, orientation="vertical", anchor=BACK+BOTTOM)
	attach(RIGHT, LEFT)
	down(0.5 * wall)
	tool_slot_with_clip_and_label(["pencil"], 11, 11, 60, text_size=8, orientation="vertical", anchor=BACK+BOTTOM);
}
