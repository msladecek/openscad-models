include <BOSL2/std.scad>

thickness = 1.2;

outer_diameter = 30;
lower_shaft_width = 4;
upper_shaft_diameter = 8;
upper_shaft_stopper_diameter = upper_shaft_diameter + 0.5;

foot_profile = [19, 39/2];
cardboard_thickness = 2.2;
text_size = outer_diameter/6;

$fn = 32;
$slop = 0.02;


module base() {
	diff()
	zcyl(d=outer_diameter, h=thickness, anchor=BOTTOM) {
		attach(BOTTOM, BOTTOM, inside=true)
		cuboid([lower_shaft_width, lower_shaft_width, 3 * thickness]);

		attach(TOP, BOTTOM)
		zcyl(d=(upper_shaft_diameter - 2 * get_slop()), h=(1.6 * thickness + get_slop()))
		attach(TOP, BOTTOM)
		down(thickness/2)
		zrot_copies(n=6)
		fwd(upper_shaft_diameter/2)
		sphere(thickness/4);

		position(TOP)
		zrot_copies(n=10) {
			fwd(outer_diameter/2*0.9)
			text3d(str($idx), font=":style=bold", h=thickness/2, size=text_size, anchor=BOTTOM);
		}
	}
}

module dial() {
	od = (outer_diameter - 1);
	diff() {
		tube(id=(upper_shaft_diameter + 2 * get_slop()), od=od, h=(3 * thickness), anchor=BOTTOM, ichamfer=thickness/4)
		attach(TOP, TOP, inside=true)
		tag("remove")
		down(0.01)
		cuboid([foot_profile.x, outer_diameter, 2 * thickness])
		attach(BOTTOM, TOP)
		zcyl(d=(upper_shaft_stopper_diameter + 2 * get_slop()), h=thickness/2);

		zrot(-90)
		zrot(-16)
		up(thickness/2)
		tag("remove")
		tag_scope()
		diff() {
			pie_slice(d=2*od, h=3*thickness, anchor=CENTER);
			tag("remove")
			pie_slice(d=od/2, h=3*thickness, ang=36, anchor=CENTER);
		}
	};
}

module expander() {
	zcyl(d=outer_diameter, h=thickness, anchor=BOTTOM)
	attach(TOP, BOTTOM)
	zcyl(d=(outer_diameter - 4 * 2), h=2)
	attach(TOP, BOTTOM)
	cuboid([lower_shaft_width, lower_shaft_width, 2.5 * thickness]);
}

xdistribute(spacing=outer_diameter*1.5) {
	expander();
	base();
	dial();
}
