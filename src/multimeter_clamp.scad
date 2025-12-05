include <BOSL2/std.scad>

inner_width = 69;
inner_height = 28;
inner_length = 125;

inner_radius = 1; // TODO: verify

probe_handle_diameter = 9;

clamp_width = 20;
clamp_thickness = 2;
clamp_overhang = 2 * clamp_thickness;
clearance = 0.1;

cable_clamp_diameter = inner_height;
cable_clamp_slot_angle = 45;

outer_width = inner_width + 2 * (clamp_thickness + clearance);

module multimeter() {
	cube([inner_width, inner_length, inner_height], anchor=BOTTOM);
}

module clamp() {
	down(clearance)
	cuboid([outer_width, clamp_width, clamp_thickness], anchor=TOP)
	{
		position(TOP + LEFT)
		diff()
		cuboid([clamp_thickness, clamp_width, inner_height + 2 * clearance], anchor=BOTTOM+LEFT)
		{
			position(TOP + LEFT)
			cuboid([clamp_thickness + clamp_overhang + clearance, clamp_width, clamp_thickness], anchor=BOTTOM+LEFT);

			scale([1, 1.1, 1])
				attach(LEFT, RIGHT)
				tag("remove") cuboid([10, clamp_width, inner_height + 2 * clearance], anchor=RIGHT)
					attach(LEFT)
					zrot(90)
					rot(from=UP, to=FRONT)
					{
						pie_slice(h=clamp_width, r=(inner_height / 2 + clearance), ang=180, anchor=CENTER);

						rot(90 - cable_clamp_slot_angle/2)
						pie_slice(h=clamp_width, r=(inner_height / 2 + clamp_thickness + 2 * clearance), ang=cable_clamp_slot_angle, anchor=CENTER);
					}

			attach(LEFT, RIGHT)
			cuboid([10, clamp_width, inner_height + 2 * clearance + 2 * clamp_thickness], anchor=RIGHT)
			attach(LEFT)
			zrot(90)
			rot(from=UP, to=FRONT)
			pie_slice(h=clamp_width, r=(inner_height / 2 + clearance + clamp_thickness), ang=180, anchor=CENTER)
			;
		}

		position(TOP + RIGHT)
		cuboid([clamp_thickness, clamp_width, inner_height + 2 * clearance], anchor=BOTTOM+RIGHT)
		position(TOP + RIGHT)
		cuboid([clamp_thickness + clamp_overhang + clearance, clamp_width, clamp_thickness], anchor=BOTTOM+RIGHT);
	}
}

%multimeter();

clamp();
