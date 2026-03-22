include <BOSL2/std.scad>
include <BOSL2/screws.scad>

wall = 1.2;
offset = 4;
seg_gap = 0.2;

screw_distance = 42;
screw_size = "M2";
handle_size = [70, 35, 10];
cutout_size = [12, 35, 7];

module mount() {
	tag_scope()
	diff()
	cuboid(handle_size, chamfer=1) {
		tag("remove")
		attach(BOTTOM, BOTTOM, inside=true)
		cuboid(cutout_size, chamfer=1, edges=[TOP+LEFT, TOP+RIGHT]);

		tag("remove")
		attach(BOTTOM, BOTTOM, inside=true)
		cuboid([cutout_size.x, cutout_size.y, 1], chamfer=-1, edges=[BOTTOM+LEFT, BOTTOM+RIGHT]);

		attach(BOTTOM, BOTTOM, inside=true)
		xcopies(n=2, spacing=screw_distance) {
			up(wall)
			zcyl(d=8, h=(handle_size.z - wall), chamfer1=1, chamfer2=-1);

			zcyl(d=3, h=handle_size.z);
		}
	}
}

$fn = 64;

mount();
