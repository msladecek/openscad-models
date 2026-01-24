include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <components.scad>

wall = 1.2;

$fn = 32;

module battery_box_holder(anchor=CENTER, spin=0, orient=UP) {
	spring_length = 30;
	spring_gap = 0.6;
	spring_width = 6;
	spring_tab = 4;

	inner_width = battery_box_2AAA__width;
	inner_length = battery_box_2AAA__length + 2 * wall;
	inner_height = battery_box_2AAA__height;

	size = [inner_width + 2 * wall, inner_length, inner_height + 2 * wall];
	attachable(anchor=anchor, spin, orient, size=size) {
		tag_scope()
		diff()
		cuboid(size, rounding=(4+wall), edges=[TOP+LEFT, TOP+RIGHT])
		tag("remove")
		cuboid([inner_width, inner_length + 0.02, inner_height], rounding=4, edges=[TOP+LEFT, TOP+RIGHT]);
		children();
	}
}


// left_half(s=200)
xdistribute(spacing=50)
{

diff()
battery_box_holder()
{
	attach(FRONT, BOTTOM, spin=180)
	prismoid(
		size1=[battery_box_2AAA__width + 2 * wall, battery_box_2AAA__height + 2 * wall],
		size2=[20, 10],
		shift=[0, (battery_box_2AAA__height + 2 * wall - 10)/2],
		rounding=[0, 0, 4 + wall, 4 + wall],
		h=12
	)
	tag("remove")
	attach(BOTTOM, BOTTOM, inside=true)
	down(0.01)
	prismoid(
		size1=[battery_box_2AAA__width, battery_box_2AAA__height],
		size2=[20 - 2 * wall, 10 - 2 * wall],
		shift=[0, (battery_box_2AAA__height  - 10 + 2 * wall)/2],
		rounding=[0, 0, 4, 4],
		h=(12 - wall + 0.01)
	)
	{
		tag("remove")
		attach(RIGHT, CENTER, align=BACK, inside=true)
		down(wall/2)
		cuboid([3, 8, 2*wall]);

		attach(TOP, CENTER, inside=true)
		zcyl(d=5, h=2*wall);

		*tag("keep")
		attach(TOP, TOP, inside=true)
		up(wall)
		recolor("lightskyblue") smts_102(angle = 0);
	}

	screw_head_height = 2;

	attach(LEFT, BOTTOM, align=BOTTOM)
	cuboid([battery_box_2AAA__length + 2 * wall, 10, screw_head_height], edges=[RIGHT+TOP, BACK+TOP]);

	tag("remove")
	down((battery_box_2AAA__height + 2 * wall - 12)/2)
	ycopies(spacing=(battery_box_2AAA__length / 3), n=2)
	xflip_copy()
	attach(LEFT, "head_bot")
	up(screw_head_height - wall)
	screw("M3", length=3*wall, head="socket", thread=false);
}


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
			screen_length = xteink_x4__length - 6 - 17;

			width1 = battery_box_2AAA__length + 2 * wall;
			width2 = battery_box_2AAA__length + 20;

			attach(RIGHT, TOP, inside=true)
			down(wall)
			cuboid([xteink_x4__length + 2 * wall, xteink_x4__height + 2 * wall, 6 + wall], except=[BOTTOM], rounding=(2 + wall))
			tag_scope()
			diff()
			attach(BOTTOM, TOP, align=FRONT)
			prismoid(size1=[width1, wall], size2=[width2, wall], h=(18 - 2 * wall))
			attach(BOTTOM, BOTTOM, align=BACK)
			cuboid([width1, 12, wall])
			{
				tag("remove")
				xcopies(spacing=(battery_box_2AAA__length / 3), n=2)
				attach(BOTTOM)
				screw_hole("M3", length=2*wall, anchor=TOP);


				xflip_copy()
				attach(BOTTOM, FRONT, spin=180, align=BACK+RIGHT)
				skew(axz=29.4)
				back(wall)
				wedge([wall, 18, 12 - wall]);
			}

			*attach(BOTTOM, BOTTOM)
			recolor("grey")
			battery_box_holder()
			{
				attach(FRONT, BOTTOM, spin=180)
				diff()
				prismoid(
					size1=[battery_box_2AAA__width + 2 * wall, battery_box_2AAA__height + 2 * wall],
					size2=[20, 10],
					shift=[0, (battery_box_2AAA__height + 2 * wall - 10)/2],
					rounding=[0, 0, 4 + wall, 4 + wall],
					h=12
				)
				tag("remove")
				attach(BOTTOM, BOTTOM, inside=true)
				prismoid(
					size1=[battery_box_2AAA__width, battery_box_2AAA__height],
					size2=[20 - 2 * wall, 10 - 2 * wall],
					shift=[0, (battery_box_2AAA__height  - 10 + 2 * wall)/2],
					rounding=[0, 0, 4, 4],
					h=(12 - wall)
				)
				{
					tag("remove")
					attach(RIGHT, CENTER, align=BACK, inside=true)
					down(wall/2)
					cuboid([3, 8, 2*wall]);

					attach(TOP, CENTER, inside=true)
					zcyl(d=5, h=2*wall);

					*tag("keep")
					attach(TOP, TOP, inside=true)
					up(wall)
					recolor("lightskyblue") smts_102(angle = 0);
				}

				yflip_copy()
				attach(LEFT, FRONT, align=BOTTOM+FRONT)
				skew(axz=29.4)
				back(wall)
				wedge([wall, 18, 8]);
			}

			attach(RIGHT, BOTTOM)
			right(6/2)
			left(17/2)
			xrot(-14)
			diff()
			down(6)
			back(4)
			prismoid(size1=[screen_length + 10, 20], size2=[screen_length, 10], shift=[0, 5], h=14, rounding=2)
			{
				attach(TOP, TOP, inside=true)
				tag("keep")
				tag_scope()
				diff()
				cuboid([screen_length, 10, wall], except=[TOP, BOTTOM], rounding=2)
				{
					attach(BOTTOM, TOP)
					cuboid([screen_length, 10, wall/2], except=[TOP, BOTTOM], rounding=2);

					tag("remove")
					xcopies(spacing = screen_length / 3, n = 3)
					cuboid([3.5, 1, wall + 0.02], anchor=CENTER)
					attach(BOTTOM, TOP)
					zcyl(d=(led__base_diameter - 0.1), h=wall, anchor=CENTER);
				}

				attach(BOTTOM, BOTTOM, align=BACK, inside=true)
				fwd(wall)
				prismoid(size1=[screen_length + 10 - 2 * wall, 10 - 2 * wall], size2=[screen_length - 2 * wall, 10 - 2 * wall], shift=[0, 0], h=14, rounding=(2 + wall)/2)
				attach(BOTTOM, BOTTOM, inside=true)
				wedge([screen_length + 10, 10, 1.5]);

				attach(BOTTOM, BOTTOM, align=FRONT, inside=true)
				cuboid([screen_length + 10, 10, 4]);
			}
		}

	}
	tag("remove") scale(1.001) cuboid([xteink_x4__width, xteink_x4__length, xteink_x4__height], rounding=2);
}

}
