include <BOSL2/std.scad>
include <BOSL2/joiners.scad>

clearance = 2;

cardboard_thickness = 4;
strip_width = 30;

blade_thickness = 1;
blade_width = 18;
blade_length = 20;
blade_bevel = 2;
blade_angle = 30;
blade_tilt = 10;

roller_diameter = 6;
roller_count = 4;

handle_length = 80;

$slop = 0.04;

module blade() {
	xrot(-blade_tilt)
	left(blade_thickness/2)
	back(blade_width/2)
	xrot(-blade_angle)
	xrot(90)
	prismoid(
		size1=[0.1, blade_length],
		size2=[blade_thickness, blade_length],
		yang=[90-blade_angle, blade_angle],
		height=blade_bevel,
		anchor=BOTTOM,
	)
	attach(TOP, BOTTOM)
	prismoid(
		size1=[blade_thickness, blade_length],
		size2=[blade_thickness, blade_length],
		yang=[90-blade_angle, blade_angle],
		height=(blade_width - blade_bevel),
		anchor=CENTER,
	);
}

module rollers(roller_diameter=roller_diameter, length=blade_length) {
	right(roller_diameter/2)
	right(strip_width)
	ycopies(n=roller_count, spacing=(handle_length/4))
	zcyl(d=roller_diameter, h=length, chamfer=1, $fn=64);
}

module handle(strip_width_label=true) {
	height = (blade_length - cardboard_thickness)/2 + clearance;
	roller_offset = roller_diameter + 3/2;
	inner_chamfer = 3;
	outer_chamfer = 3;
	joiner_width = 6;

	tag_scope()
	diff() {
		left(3)
		cuboid(
			[6 + strip_width + roller_offset, handle_length, height],
			anchor=BOTTOM+LEFT,
			chamfer=outer_chamfer,
			edges=[TOP+LEFT, TOP+FRONT, TOP+BACK],
		) {
			if (strip_width_label)
			tag("remove")
			position(TOP+LEFT+FRONT)
			back(3 + outer_chamfer)
			right(3 + outer_chamfer)
			text3d(str(strip_width), size=12);

			position(TOP+RIGHT)
			cuboid(
				[6, handle_length, outer_chamfer],
				anchor=TOP,
				chamfer=outer_chamfer,
				edges=[TOP],
				except=[LEFT]
			)
			attach(BOTTOM, BOTTOM)
			ycopies(n=2, l=handle_length/2)
			joiner(l=handle_length/2, w=joiner_width, base=(height + clearance + cardboard_thickness/2 - outer_chamfer));

			yflip_copy(handle_length/2 - 10)
			attach(BOTTOM, BOTTOM, align=LEFT)
			cuboid([6, 20, clearance], chamfer=clearance, edges=[TOP]);
		}

		tag("remove")
		down(clearance + cardboard_thickness/2)
		right(blade_thickness/2)
		xrot_copies(n=2)
		fwd(handle_length/4)
		blade();

		tag("remove")
		right(inner_chamfer)
		yflip_copy(offset=handle_length/8)
		cuboid(
			[strip_width - inner_chamfer + roller_offset, handle_length/4, cardboard_thickness/2 + clearance],
			edges=[TOP],
			chamfer=inner_chamfer,
			anchor=BOTTOM+LEFT,
		)
		attach(BACK, FRONT)
		cuboid(
			[strip_width - inner_chamfer + roller_offset, handle_length/4, cardboard_thickness/2 + clearance],
			edges=[TOP],
			except=[BACK],
			chamfer=inner_chamfer,
			anchor=BOTTOM+LEFT,
		);

		tag("remove")
		down(cardboard_thickness/2)
		down(clearance)
		rollers(roller_diameter + 4 * $slop, blade_length + 4 * $slop);
	}
}

explode_distance = 20;

recolor("darkgreen")
rollers();

up(cardboard_thickness/2)
up(clearance)
up(explode_distance)
handle();

#recolor("red")
fwd(handle_length/4) {
	right(blade_thickness/2)
	blade();
}

down(cardboard_thickness/2)
down(clearance)
down(explode_distance)
xrot(180)
handle();
