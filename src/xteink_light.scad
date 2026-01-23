include <BOSL2/std.scad>
include <components.scad>

wall = 1.2;

$fn = 32;

module battery_box_holder(anchor=CENTER, spin=0, orient=UP) {
	spring_length = 30;
	spring_gap = 0.6;
	spring_width = 6;
	spring_tab = 4;

	inner_width = battery_box_2AAA__width;
	inner_length = battery_box_2AAA__length + 3 * wall;
	inner_height = battery_box_2AAA__height;

	size = [inner_width + 2 * wall, inner_length, inner_height + 2 * wall];
	attachable(anchor=anchor, spin, orient, size=size) {
		tag_scope()
		diff()
		cuboid(size, rounding=(4+wall), edges=[TOP+LEFT, TOP+RIGHT])
		{
			tag("remove")
			attach(FRONT, FRONT, inside=true)
			down(0.01)
			cuboid([inner_width, inner_length + 0.02, inner_height], rounding=4, edges=[TOP+LEFT, TOP+RIGHT]);

			tag("remove")
			attach(FRONT, UP, inside=true)
			up(2)
			cuboid([12, inner_height + wall, 2], except=[LEFT, RIGHT], rounding=(wall/2));
		}
		children();
	}
}

module battery_box_holder_lid() {
	inner_width = battery_box_2AAA__width;
	inner_height = battery_box_2AAA__height;

	size = [inner_width + 2 * wall, wall, inner_height + 2 * wall];

	down(11)
	fwd(15)

	cuboid(size, rounding=(4+wall), edges=[TOP+LEFT, TOP+RIGHT])
	{
		zflip_copy()
		attach(FRONT, TOP, align=TOP)
		fwd(2)
		cuboid([12, wall/2, 2])
		attach(BOTTOM, TOP, align=FRONT)
		cuboid([12, 2, 2], rounding=(wall/2), edges=[BACK]);

		attach(FRONT, TOP, align=TOP)
		fwd(wall)
		xflip_copy()
		right(7.5)
		cuboid([1.5, wall, wall]);

		attach(FRONT, TOP, align=BOTTOM)
		back(wall)
		xflip_copy()
		right(9)
		cuboid([5, wall, wall]);

		xflip_copy()
		attach(FRONT, TOP, align=LEFT)
		right(wall)
		fwd(inner_height/2 - 9/2)
		cuboid([wall, 9, wall]);
	}
}


// left_half(s = 200)
ydistribute(spacing=50)
{
diff()
{
	tag_scope()
	xteink_x4()
	{
		*attach(BOTTOM, BOTTOM)
		up(wall)
		recolor("black") battery_box_2AAA();

		{
			screen_width = 69 - 2 * 7;
			screen_height = xteink_x4__length - 6 - 17;

			width1 = battery_box_2AAA__width + 2 * wall;
			width2 = 40;

			attach(TOP, BOTTOM, align=FRONT, inside=true)
			down(wall)
			fwd(wall * 3 / 2)
			cuboid([69 + 2 * wall, 6 + wall, 6.3 + 2 * wall], except=[BACK], rounding=3)
			tag_scope()
			diff()
			attach(BACK, TOP, align=UP)
			prismoid(size1=[width1, wall], size2=[width2, wall], h=23)
			attach(BACK, BACK, align=BOTTOM)
			prismoid(
				size1=[battery_box_2AAA__width + 2 * wall,
				battery_box_2AAA__height + wall],
				size2=[20, 10],
				shift=[0, (battery_box_2AAA__height + wall - 10)/2],
				rounding=[0, 0, 4 + wall, 4 + wall],
				h=12
			) {
				*attach(TOP, TOP, inside=true)
				up(wall)
				recolor("lightskyblue") smts_102(angle = 0);

				tag("remove")
				attach(TOP, CENTER, inside=true)
				zcyl(d=5, h=2*wall);

				tag("remove")
				attach(LEFT, CENTER, align=BACK, inside=true)
				up(wall/2)
				cuboid([3, 8, 2*wall]);

				tag("remove")
				attach(BOTTOM, BOTTOM, inside=true)
				back(wall/2)
				prismoid(
					size1=[battery_box_2AAA__width, battery_box_2AAA__height],
					size2=[20 - 2 * wall, 10 - wall],
					shift=[0, (battery_box_2AAA__height + wall - 10)/2],
					rounding=[0, 0, 4, 4],
					h=(12 - wall)
				);

				tag("keep")
				recolor("grey")
				attach(BOTTOM, BACK, spin=180)
				fwd(wall/2)
				battery_box_holder();

				xflip_copy()
				attach(TOP, FRONT, align=LEFT+BACK, spin=180)
				down(4.8)
				skew(axz=14)
				wedge([wall, 20, 6]);
			}

			attach(FRONT, BOTTOM)
			xrot(-16)
			diff()
			down(6)
			back(4)
			prismoid(size1=[screen_width + 10, 20], size2=[screen_width, 10], shift=[0, 5], h=14, rounding=2)
			{
				attach(TOP, TOP, inside=true)
				tag("keep")
				tag_scope()
				diff()
				cuboid([screen_width, 10, wall], except=[TOP, BOTTOM], rounding=2)
				{
					attach(BOTTOM, TOP)
					cuboid([screen_width, 10, wall/2], except=[TOP, BOTTOM], rounding=2);

					tag("remove")
					xcopies(l = 40, n = 3)
					cuboid([3.5, 1, wall + 0.02], anchor=CENTER)
					attach(BOTTOM, TOP)
					zcyl(d=(led__base_diameter - 0.1), h=wall, anchor=CENTER);
				}

				attach(BOTTOM, BOTTOM, align=BACK, inside=true)
				fwd(wall)
				prismoid(size1=[screen_width + 10 - 2 * wall, 10 - 2 * wall], size2=[screen_width - 2 * wall, 10 - 2 * wall], shift=[0, 0], h=14, rounding=(2 + wall)/2)
				attach(BOTTOM, BOTTOM, inside=true)
				wedge([screen_width + 10, 10, 2.5]);

				attach(BOTTOM, BOTTOM, align=FRONT, inside=true)
				cuboid([screen_width + 10, 10, 4]);
			}
		}

	}
	tag("remove") scale(1.01) cuboid([68, 114, 6.3], rounding=2);
}

// battery_box_holder_lid();
}
