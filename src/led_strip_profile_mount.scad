include <BOSL2/std.scad>

length = 20;
opening_width = 6;
internal_width = 15;
internal_width2 = 12;
internal_height = 3;
internal_height2 = 4 - 0.2;
stem_height = 4;
plate_height = 2;
total_width = 20;
screw_diameter = 5;
plate_width = 2.4 * total_width;


$fn = 64;

diff()
cuboid([length, internal_width, internal_height], except=[LEFT, RIGHT], rounding=(internal_height/2))
attach(BOTTOM, TOP)
cuboid([length, internal_width2, internal_height2 - internal_height])
attach(BOTTOM, TOP)
cuboid([length, opening_width, stem_height], edges=[BOTTOM+BACK, BOTTOM+FRONT], rounding=(-plate_height/2))
attach(BOTTOM, TOP)
cuboid([length, plate_width, plate_height], except=[TOP, BOTTOM], rounding=(length/2))
attach(TOP, TOP, inside=true)
yflip_copy()
fwd(plate_width/2 - min(plate_width/2, length/2))
zcyl(d=screw_diameter, h=plate_height, chamfer2=(1 - min(screw_diameter/2, plate_height)));
