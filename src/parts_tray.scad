include <BOSL2/std.scad>

wall = 2;
spacing = wall;
compartment_height = 2 * wall;

main_compartment_length = 120;
main_compartment_width = 160;

top_compartment_count = 5;

top_compartment_length = (main_compartment_width - (top_compartment_count - 1) * spacing) / top_compartment_count;
top_compartment_width = top_compartment_length;

module compartment(size) {
    prismoid(size1=[size[0]-2*wall, size[1]-2*wall], size2=[size[0], size[1]], h=compartment_height);
}

diff()
cuboid([main_compartment_width + 2 * wall, main_compartment_length + spacing + top_compartment_length + 2 * wall, compartment_height + wall], anchor=BOTTOM)
    tag("remove")
    back((main_compartment_length + top_compartment_length) / 4)
    fwd(top_compartment_length / 2)
    down(wall / 2)
    ydistribute(spacing=spacing, sizes=[main_compartment_length, top_compartment_length]) {
            compartment([main_compartment_width, main_compartment_length]);
            xcopies(n=top_compartment_count, l=(main_compartment_width - top_compartment_width)) {
                    compartment([top_compartment_width, top_compartment_length]);
            }
    }
