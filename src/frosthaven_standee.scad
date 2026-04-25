include <BOSL2/std.scad>

thickness = 1.2;

outer_diameter = 30;
lower_shaft_diameter = 4;
upper_shaft_diameter = 8;
foot_profile = [19, 39/2];
cardboard_thickness = 2.2;
text_size = outer_diameter/7;

$fn = 32;
$slop = 0.04;


module base() {
	diff()
	zcyl(d=outer_diameter, h=thickness, anchor=BOTTOM) {
		attach(BOTTOM, BOTTOM, inside=true)
		zcyl(d=(lower_shaft_diameter + 2 * get_slop()), h=2*thickness);

		attach(TOP, BOTTOM)
		zcyl(d=(upper_shaft_diameter - 2 * get_slop()), h=thickness);

		tag("remove")
		up(0.01)
		position(TOP)
		zrot_copies(n=10) {
			fwd(outer_diameter/2*0.9)
			text3d(str($idx), font=":style=bold", h=thickness/2, size=text_size, anchor=TOP);
		}
	}
}

module dial() {
	od = (outer_diameter - 0.2);
	diff() {
		tube(id=(upper_shaft_diameter + 2 * get_slop()), od=od, h=thickness, anchor=BOTTOM)
		position(TOP)
		xflip_copy()
		left(foot_profile.x/2)
		cuboid([thickness, foot_profile.y, thickness], anchor=BOTTOM+RIGHT);

		zrot(-90)
		zrot(-16)
		up(thickness/2)
		tag("remove")
		tag_scope()
		diff() {
			pie_slice(d=2*od, h=2*thickness, anchor=CENTER);
			tag("remove")
			pie_slice(d=od/2, h=2*thickness, ang=36, anchor=CENTER);
		}
	};
}

module expander() {
	zcyl(d=outer_diameter, h=thickness, anchor=BOTTOM)
	attach(TOP, BOTTOM)
	zcyl(d=(outer_diameter - 4 * 2), h=2)
	attach(TOP, BOTTOM)
	zcyl(d=(lower_shaft_diameter + 2 * get_slop()), h=(2 * thickness));
}

xdistribute(spacing=outer_diameter*1.5) {
	expander();
	base();
	dial();
}
