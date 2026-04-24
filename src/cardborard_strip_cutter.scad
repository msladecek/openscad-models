include <BOSL2/std.scad>
include <BOSL2/joiners.scad>

clearance = 1;

cardboard_thickness = 5;
strip_width = 60;

blade_thickness = 1;
blade_width = 22;
blade_length = 18;
blade_angle = 45;

handle_length = 80;

two_blades = false;

$slop = 0.04;

module blade() {
	prismoid(
		size1=[blade_thickness, blade_width],
		size2=[blade_thickness, blade_width],
		yang=[90, blade_angle],
		height=blade_length,
		anchor=CENTER,
	);
}

module handle(second_blade=false) {
	height = (blade_length - cardboard_thickness)/2 + clearance;

	tag_scope()
	diff() {
		left(3)
		cuboid([6 + strip_width, handle_length, height], anchor=BOTTOM+LEFT)
		position(RIGHT+BOTTOM)
		down(clearance + cardboard_thickness/2)
		yrot(180)
		ycopies(n=2, l=handle_length/2)
		joiner(l=handle_length/2, w=6, base=(height + clearance + cardboard_thickness/2));

		tag("remove")
		up(height - 3)
		right(strip_width + 6)
		yrot(-90)
		rot(from=LEFT, to=FRONT)
		wedge([handle_length, 6, 6], anchor=BOTTOM);

		tag("remove")
		down(clearance + cardboard_thickness/2)
		right(blade_thickness/2)
		ycopies(n=2, l=(handle_length/2)) {
			blade();

			if (second_blade)
			left(blade_thickness)
			yrot(180)
			blade();
		}

		tag("remove")
		right(3)
		cuboid(
			[strip_width - 3, handle_length, cardboard_thickness/2 + clearance],
			edges=[TOP+LEFT, TOP+RIGHT],
			chamfer=3,
			anchor=BOTTOM+LEFT,
		);
	}
}

up(cardboard_thickness/2)
up(clearance)
up(10)
handle(second_blade=two_blades);

#recolor("red")
fwd(handle_length/4) {
	right(blade_thickness/2)
	blade();

	if (two_blades)
	left(blade_thickness/2)
	yrot(180)
	blade();
}

down(cardboard_thickness/2)
down(clearance)
down(10)
xrot(180)
handle(second_blade=two_blades);
