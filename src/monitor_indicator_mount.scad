include <BOSL2/std.scad>
include <BOSL2/screws.scad>


$fn = 64;

// left_half()
cuboid([6, 2, 2], except=[TOP, BOTTOM], rounding=1)
attach(BOTTOM, TOP)
tag_scope()
diff()
zcyl(d=2, h=3)
attach(BOTTOM, TOP, align=FRONT)
cuboid([12, 4, 12], except=[FRONT, BACK], rounding=2) {
	attach(BACK, TOP, inside=true)
	screw_hole("M3", length=10);

	attach(BACK, TOP, inside=true)
	regular_prism(n=6, id=5.5, h=2);

	fwd(1)
	attach(FRONT, BACK, align=BOTTOM)
	cuboid([12, 24, 12]) {
		attach(FRONT, FRONT, inside=true)
		cuboid([8, 22, 13]);

		attach(FRONT, BACK, align=BOTTOM)
		cuboid([12, 2, 16]) {
			attach(BACK, FRONT, align=BOTTOM, inside=true)
			wedge([8, 6, 12]);

			attach(FRONT, FRONT, align=BOTTOM)
			wedge([12, 8, 16])
			attach("hypot", TOP)
			down(6)
			tag("remove") zcyl(d=5, h=8);
		}
	}
}
