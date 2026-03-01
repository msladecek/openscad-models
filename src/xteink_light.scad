include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <components.scad>

wall = 1.2;

$fn = 32;
$slop = 0.08;

lr44__diameter = 11.5;
lr44__height = 5.2;

module led_box(flare_angle=15, height=12, anchor=CENTER, spin=0, orient=UP, separation=0) {
	screen_length = xteink_x4__length - xteink_x4__top_margin - xteink_x4__bottom_margin;
	bottom_space = 1;

	inner_cavity_height = height - wall - bottom_space - get_slop();
	inner_cavity_flare = inner_cavity_height * tan(flare_angle);
	inner_cavity_length2 = screen_length;
	inner_cavity_length1 = screen_length - 2 * inner_cavity_flare;
	inner_cavity_width1 = led__body_diameter + 2 * get_slop();

	inner_hull_flare = (inner_cavity_height + wall/2) * tan(flare_angle);
	inner_hull_length2 = inner_cavity_length1 + wall + 2 * inner_hull_flare - 2 * get_slop();
	inner_hull_width2 = inner_cavity_width1 + wall + 2 * inner_hull_flare - 2 * get_slop();

	outer_cavity_height = height - wall/2;
	outer_cavity_flare = outer_cavity_height * tan(flare_angle);
	outer_cavity_length2 = inner_hull_length2 + 4 * get_slop();
	outer_cavity_width2 = inner_hull_width2 + 4 * get_slop();
	outer_cavity_length1 = outer_cavity_length2 - 1 * outer_cavity_flare;
	outer_cavity_width1 = outer_cavity_width2 - 2 * outer_cavity_flare;

	outer_hull_height = height;
	outer_hull_flare = outer_hull_height * tan(flare_angle);
	outer_hull_length2 = outer_cavity_length1 + wall + 1 * outer_hull_flare - 2 * get_slop();
	outer_hull_width2 = outer_cavity_width1 + wall + 2 * outer_hull_flare - 2 * get_slop();

	module inner_cavity(anchor=CENTER, spin=0, orient=UP)
	attachable(
		size=[
			inner_cavity_length1 + 2 * inner_cavity_flare,
			inner_cavity_width1 + 2 * inner_cavity_flare,
			inner_cavity_height
		],
		anchor=anchor, spin=spin, orient=orient
	) {
		down(inner_cavity_height/2)
		prismoid(
			size1=[inner_cavity_length1, inner_cavity_width1],
			xang=(90 + flare_angle),
			yang=(90 + flare_angle),
			height=inner_cavity_height,
		);
		children();
	}

	module inner_hull(anchor=CENTER, spin=0, orient=UP)
	attachable(
		size=[
			inner_hull_length2,
			inner_hull_width2,
			(inner_cavity_height + wall/2)
		],
		anchor=anchor, spin=spin, orient=orient
	) {
		down((inner_cavity_height + wall/2)/2)
		prismoid(
			size1=[inner_cavity_length1 + wall, inner_cavity_width1 + wall],
			xang=(90 + flare_angle),
			yang=(90 + flare_angle),
			height=(inner_cavity_height + wall/2),
		);
		children();
	}

	module outer_cavity(anchor=CENTER, spin=0, orient=UP)
	attachable(
		size=[
			outer_cavity_length2,
			outer_cavity_width2,
			outer_cavity_height
		],
		anchor=anchor, spin=spin, orient=orient
	) {
		down(outer_cavity_height/2)
		prismoid(
			size2=[outer_cavity_length2, outer_cavity_width2],
			xang=[90, (90 + flare_angle)],
			yang=(90 + flare_angle),
			height=outer_cavity_height,
		);
		children();
	}

	module outer_hull(anchor=CENTER, spin=0, orient=UP)
	attachable(
		size=[
			outer_hull_length2,
			outer_hull_width2,
			(outer_cavity_height + wall/2)
		],
		anchor=anchor, spin=spin, orient=orient
	) {
		down((outer_cavity_height + wall/2)/2)
		prismoid(
			size2=[outer_hull_length2, outer_hull_width2],
			xang=[90, (90 + flare_angle)],
			yang=(90 + flare_angle),
			height=(outer_cavity_height + wall/2),
			rounding=[1, 0, 0, 1]
		);
		children();
	}

	module bolt_holes()
	tag("remove")
	xcopies(spacing = screen_length / 3, n = 2)
	screw_hole("M2", length=(3 * wall));

	module bolt_spacers()
	tag_scope()
	diff() {
		xcopies(spacing = screen_length / 3, n = 2)
		zcyl(d=4, h=(bottom_space - get_slop()));

		bolt_holes();
	};

	module side_spacers()
	xcopies(spacing = (inner_cavity_length1 - inner_cavity_width1), n = 2)
	zcyl(d=4, h=(bottom_space - get_slop()));

	module led_holes()
	tag("remove")
	xcopies(spacing = inner_cavity_length1 / 3, n = 3)
	zcyl(d=(led__body_diameter + 2 * get_slop()), h=2*wall, anchor=CENTER);

	attachable(
		size=[
			outer_hull_width2,
			outer_hull_length2,
			(outer_cavity_height + wall/2)
		],
		anchor=anchor, spin, orient
	) {
		zrot(90)
		union() {
			tag_scope()
			diff()
			outer_hull() {
				attach(TOP, TOP, inside=true)
				tag("remove")
				down(0.01)
				outer_cavity()

				attach(BOTTOM, CENTER, inside=true)
				tag("remove")
				right(outer_hull_flare/2)
				bolt_holes();

				attach(BOTTOM, BOTTOM, inside=true)
				up(wall/2)
				right(outer_hull_flare/2)
				tag("keep") {
					bolt_spacers();
					side_spacers();
				}
			}

			up(separation)
			right(outer_hull_flare/2 - 3 / 2 * get_slop())
			up((wall/2 + bottom_space)/2)
			up(get_slop()/2)
			tag_scope()
			diff()
			inner_hull() {
				attach(TOP, TOP, inside=true)
				tag("remove")
				down(0.01)
				inner_cavity();

				attach(BOTTOM, CENTER, inside=true)
				tag("remove") {
					bolt_holes();
					led_holes();
				}
			}
		}

		children();
	}
}

module side_mount(anchor=CENTER, spin=0, orient=UP) {
	attachable(
		size=[6 + wall, xteink_x4__height + 2 * wall, xteink_x4__length + 2 * wall],
		anchor=anchor,
		spin=spin,
		orient=orient
	) {
		zrot(90)
		xrot(180)
		tag_scope()
		diff()
		cuboid([xteink_x4__length + 2 * wall, xteink_x4__height + 2 * wall, 6 + wall], except=[BOTTOM], rounding=(2 + wall))
		attach(TOP, RIGHT, inside=true)
		up(wall)
		tag("remove")
		cuboid([xteink_x4__width + 2 * get_slop(), xteink_x4__length + 2 * get_slop(), xteink_x4__height + 2 * get_slop()], rounding=2);

		children();
	}
}

module control_box() {
	tag_scope()
	diff()
	zcyl(h=(3 * lr44__height + 2 * wall), d=(lr44__diameter + 2 * wall), chamfer=wall/2) {
		attach(BOTTOM, BOTTOM, inside=true)
		tag("keep")
		tag_scope()
		diff()
		up(wall/2 + get_slop())
		intersection() {
			zrot(90 - 6)
			pie_slice(
				h=wall/2,
				d=(lr44__diameter + 2 * wall),
				ang=12
			);
			tube(
				h=wall/2,
				id=lr44__diameter,
				od=(lr44__diameter + 2 * wall),
			);
		}

		attach(BOTTOM, BOTTOM, inside=true)
		tag("remove")
		pie_slice(h=wall, d=(lr44__diameter + 2 * wall), ang=180);

		attach(BOTTOM, BOTTOM, inside=true)
		tag("remove")
		up(wall/2)
		zcyl(h=wall/2, d=(lr44__diameter + wall), chamfer1=wall/4)
		attach(CENTER, BACK, inside=true)
		xrot(90)
		cuboid(
			[
				smts_102__body_width + wall,
				smts_102__body_depth + wall/2 + lr44__diameter/2,
				wall/2,
			],
			chamfer=wall/4,
			edges=[TOP]
		);

		attach(BOTTOM, BOTTOM, inside=true)
		tag("remove")
		zcyl(d=lr44__diameter, h=(3 * lr44__height + wall));

		attach(FRONT, FRONT, inside=true)
		tag("remove")
		cuboid([smts_102__body_width, 7, 3 * lr44__height]);

		attach(FRONT, CENTER)
		rot(from=FRONT, to=TOP) {
			cuboid(
				size=[
					smts_102__body_width + 2 * wall,
					2 * smts_102__body_depth,
					3 * lr44__height + 2 * wall,
				],
				chamfer=wall/2,
			)
			attach(BOTTOM, BOTTOM, align=FRONT)
			down(wall)
			back(wall + 0.02)
			tag("remove")
			zcyl(d=smts_102__bolt_diameter, h=2*wall);

			tag("remove")
			down(wall)
			back(wall)
			cuboid(
				size=[
					smts_102__body_width,
					2 * smts_102__body_depth,
					3 * lr44__height + 2 * wall,
				],
			);
		}
	}
}

module control_box_lid() {
	extra_height = 1.5;
	tag_scope()
	diff() {
		zcyl(
			h=wall+extra_height,
			d=lr44__diameter,
			chamfer2=wall/2
		) {
			intersection() {
				position(BOTTOM)
				zcyl(
					h=(wall/2 - 2 * get_slop()),
					d=(lr44__diameter + wall - 2 * get_slop()),
					chamfer2=(wall/4 - get_slop()),
					anchor=BOTTOM,
				);

				zrot(180)
				position(BOTTOM)
				pie_slice(
					h=wall/2,
					d=(lr44__diameter + wall),
					ang=180,
					anchor=BOTTOM,
				);
			}

			position(BOTTOM)
			cuboid(
				[
					smts_102__body_width - 2 * get_slop(),
					smts_102__body_depth + lr44__diameter/2 - 2 * get_slop(),
					wall + extra_height,
				],
				anchor=BACK+BOTTOM,
				edges=[TOP],
				chamfer=wall/2,
			);

			position(BOTTOM)
			tag("remove")
			cuboid(
				[
					smts_102__body_width - 2 * get_slop() - wall,
					smts_102__body_depth + lr44__diameter/2 - 2 * get_slop() - wall/2,
					extra_height,
				],
				anchor=BACK+BOTTOM,
			);

			position(BOTTOM)
			cuboid(
				[
					smts_102__body_width + wall - 2 * get_slop(),
					smts_102__body_depth + wall/2 + lr44__diameter/2 - 2 * get_slop(),
					wall/2 - 2 * get_slop(),
				],
				chamfer=(wall/4 - get_slop()),
				edges=[TOP],
				anchor=BACK+BOTTOM,
			);

			position(BOTTOM)
			tag("remove")
			zcyl(
				h=extra_height,
				d=(lr44__diameter - wall),
				anchor=BOTTOM,
			);

			tag_scope()
			diff() {
				intersection() {
					position(BOTTOM)
					zcyl(
						h=wall,
						d=(lr44__diameter + 2 * wall),
						chamfer2=wall/2,
						anchor=BOTTOM
					);

					position(BOTTOM)
					pie_slice(
						h=wall,
						d=(lr44__diameter + 2 * wall),
						ang=180,
						anchor=BOTTOM
					);
				}

				position(BOTTOM)
				tag("remove")
				pie_slice(
					h=wall/2,
					d=(lr44__diameter + 3 * wall),
					anchor=BOTTOM,
					ang=12.5,
					spin=(90 - 12.5/2)
				);

				position(BOTTOM)
				tag("keep")
				pie_slice(
					h=wall/2,
					d=lr44__diameter,
					anchor=BOTTOM,
					ang=180,
				);
			}
		}
	}
}

module control_box_lid_flat() {
	tag_scope()
	diff() {
		zcyl(
			h=wall,
			d=lr44__diameter,
		) {
			intersection() {
				attach(TOP, TOP, overlap=wall)
				zcyl(
					h=(wall/2 - 2 * get_slop()),
					d=(lr44__diameter + wall - 2 * get_slop()),
					chamfer1=(wall/4 - get_slop()),
				);

				zrot(180)
				attach(TOP, TOP, overlap=wall)
				pie_slice(
					h=wall/2,
					d=(lr44__diameter + wall),
					ang=180,
				);
			}

			position(BOTTOM)
			cuboid(
				[
					smts_102__body_width - 2 * get_slop(),
					smts_102__body_depth + lr44__diameter/2 - 2 * get_slop(),
					wall,
				],
				anchor=BACK+BOTTOM,
			);

			position(BOTTOM)
			cuboid(
				[
					smts_102__body_width + wall - 2 * get_slop(),
					smts_102__body_depth + wall/2 + lr44__diameter/2 - 2 * get_slop(),
					wall/2 - 2 * get_slop(),
				],
				chamfer=(wall/4 - get_slop()),
				edges=[TOP],
				anchor=BACK+BOTTOM,
			);

			position(BOTTOM)
			tag("remove")
			zrot(180)
			cuboid(
				[wall, (lr44__diameter + smts_102__body_depth)/2, wall/2],
				chamfer=(wall/4 - get_slop()),
				edges=[TOP],
				anchor=FRONT+BOTTOM,
			);

			tag_scope()
			diff() {
				intersection() {
					attach(TOP, TOP, overlap=wall)
					zcyl(
						h=wall,
						d=(lr44__diameter + 2 * wall),
						chamfer1=wall/2,
					);

					attach(TOP, TOP, overlap=wall)
					pie_slice(
						h=wall,
						d=(lr44__diameter + 2 * wall),
						ang=180,
					);
				}

				position(BOTTOM)
				tag("remove")
				pie_slice(
					h=wall/2,
					d=(lr44__diameter + 3 * wall),
					anchor=BOTTOM,
					ang=12.5,
					spin=(90 - 12.5/2)
				);

				position(BOTTOM)
				tag("keep")
				pie_slice(
					h=wall/2,
					d=lr44__diameter,
					anchor=BOTTOM,
					ang=180,
				);
			}
		}
	}
}

module light() {
	screen_offset = (xteink_x4__bottom_margin - xteink_x4__top_margin)/2;
	side_mount(orient=RIGHT);

	diff()
	left(0.5)
	up(11)
	back(screen_offset)
	yrot(15)
	led_box(height=(lr44__diameter + wall), flare_angle=12, orient=RIGHT, separation=-30) {
		attach(BOTTOM, BOTTOM, align=FRONT, inside=true)
		up(wall/2)
		right(wall)
		tag("remove")
		prismoid(h=4, size1=[6 - 2 * wall, 2 * wall], yang=[90, 90], xang=[90 + 12, 90 + 12]);

		attach(FRONT, TOP)
		zrot(90 - 12)
		down(wall + 0.2)
		zrot(-25) {
			control_box();

			up(30)
			left(30)
			yrot(180)
			control_box_lid();
		}
	}
}

// TODO: verify that a line can come from he led box to the bottom of the switch compartment with battteries in place
// MAYBE: increase the switch body compartment size (distance from battery compartment)

*zrot(180)
xteink_x4();

*left(40)
light();

control_box_lid();
