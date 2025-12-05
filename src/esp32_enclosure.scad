include <BOSL2/std.scad>

wall = 1.5;

pcb_width = 28.7;
pcb_length = 52.1;
pcb_height = 1.9;

pcb_hole_diameter = 3;
pcb_hole_lengthwise_inner_offset = 44;
pcb_hole_widthwise_inner_offset = 20;

pcb_hole_lengthwise_offset = pcb_hole_lengthwise_inner_offset + pcb_hole_diameter;
pcb_hole_widthwise_offset = pcb_hole_widthwise_inner_offset + pcb_hole_diameter;

port_height = 5 - pcb_height;
port_width = 9;
port_length = 6.2;
port_overhang = 2;

button_height = 3.6 - pcb_height;
button_spacing = 15;
button_offset_from_front = 3.2;

module esp32() {
	chip_width = 16;
	chip_length = 18;
	chip_height = 5 - pcb_height;

	chip_offset_from_back = 25 - chip_length;

	pin_width = 0.5;
	pin_height = 8.3;
	pin_footer_height = 2.5;
	pin_footer_size = 2.5;

	pins_offset_from_side = 1 + pin_footer_size / 2;
	pins_offset_from_front = 10;
	pin_count_per_side = 15;

	diff()
	recolor("steelblue")
	cuboid([pcb_width, pcb_length, pcb_height], chamfer=1, except=[TOP, BOTTOM], anchor=BOTTOM)
	{
		ycopies(n=2, spacing=pcb_hole_lengthwise_offset)
		xcopies(n=2, spacing=pcb_hole_widthwise_offset)
		tag("remove") cyl(d=pcb_hole_diameter, h=(1.1 * pcb_height), center=true);

		position(TOP+BACK)
		fwd(chip_offset_from_back)
		recolor("silver")
		cuboid([chip_width, chip_length, chip_height], anchor=BOTTOM+BACK);

		position(TOP+FRONT)
		fwd(port_overhang)
		recolor("silver")
		cuboid([port_width, port_length, port_height], except=[FRONT, BACK], rounding=(port_height/2), anchor=BOTTOM+FRONT);

		position(TOP+FRONT)
		xcopies(n=2, spacing=button_spacing)
		back(button_offset_from_front)
		{
			recolor("silver")
			cuboid([2.5, 4, 1], anchor=BOTTOM);

			recolor("black")
			cyl(d=2, h=button_height, anchor=BOTTOM);
		}

		xflip_copy()
		ycopies(n=pin_count_per_side, spacing=pin_footer_size, sp=0)
		position(BOTTOM+FRONT+LEFT)
		orient(DOWN)
		back(pins_offset_from_front)
		left(pins_offset_from_side)
		{
			recolor("gold")
			cuboid([pin_width, pin_width, pin_height], anchor=BOTTOM);
			recolor("black")

			cuboid([pin_footer_size, pin_footer_size, pin_footer_height], anchor=BOTTOM);
		}
	}
}

module enclosure(open=false) {
	yflip_copy()
	xflip_copy()
	fwd(pcb_hole_lengthwise_offset/2)
	left(pcb_hole_widthwise_offset/2)
	cyl(d=(pcb_hole_diameter - 0.1), h=(1.1 * pcb_height), anchor=BOTTOM)
		position(BOTTOM)
		right(pcb_hole_diameter/2)
		back(pcb_hole_diameter/2)
		cuboid([5, 5, 9], rounding=(pcb_hole_diameter/2), edges=[BACK+RIGHT], anchor=TOP+BACK+RIGHT);

	diff()
	down(9)
	rect_tube(isize=[pcb_width + 0.2, pcb_length + 0.2], chamfer=1, h=15, wall=wall, anchor=BOTTOM)
	{
		position(FRONT+TOP)
		tag("remove") cuboid([port_width + 0.4, port_length, port_height + 1.2], except=[TOP, FRONT, BACK], rounding=((port_height + 0.2)/2), anchor=TOP);

		position(BOTTOM)
		cuboid([pcb_width + 2 * wall + 0.2, pcb_length + 2 * wall + 0.2, wall], except=[TOP, BOTTOM], chamfer=1, anchor=TOP);

		position(BOTTOM)
		xflip_copy()
		left(12)
		back(1.5)
		down(0.1)
		tag("remove") cuboid([4, 40, wall * 2], anchor=CENTER);

		xflip_copy()
		attach_part("inside")
		attach(LEFT, RIGHT, align=UP)
		fwd(2.6)
		down(wall/2)
		cuboid([wall, 10, wall], rounding=(wall/2));

		xflip_copy()
		attach_part("inside")
		attach(LEFT, RIGHT, align=UP)
		down(wall/2)
		cuboid([wall, 10, wall], rounding=(wall/2));

		position(TOP)
		up(open ? 10 : 0)
		cuboid([pcb_width + 2 * wall + 0.2, pcb_length + 2 * wall + 0.2, wall], except=[TOP, BOTTOM], chamfer=1, anchor=BOTTOM)
		{
			xflip_copy()
			position(BOTTOM+LEFT)
			right(2.8)
			tag("keep")
			cuboid([1, 9, 2], except=[TOP, BOTTOM], rounding=0.5, anchor=TOP)
				position(BOTTOM+RIGHT)
				cuboid([wall*1.2, 10, wall], rounding=(wall/2), anchor=RIGHT);

			attach(BOTTOM, TOP)
			rect_tube(size=[pcb_width + 0.1, pcb_length + 0.1], h=2.8, wall=1);

			attach(BOTTOM, TOP)
			up(0.1)
			tag("remove") cuboid([pcb_width + 0.2, 11, 3]);

			attach(BOTTOM, TOP)
			up(1 - 0.2)
			fwd(pcb_length/2)
			tag("remove") cuboid([port_width + 0.4, 3, port_height + 0.4], rounding=((port_height + 0.2)/2), edges=[TOP+LEFT, TOP+RIGHT]);

			lever_width = 2;
			lever_length = 6;
			attach(BOTTOM, TOP)
			xcopies(n=2, spacing=button_spacing)
			fwd(21)
			down(2)
			tag("remove") cuboid([lever_width + 2 * gap, lever_length + gap, 3], anchor=TOP);

			gap = 0.3;
			attach(BOTTOM, TOP)
			xcopies(n=2, spacing=button_spacing)
			fwd(21)
			down(wall)
			back(gap / 2)
			tag("keep") cuboid([lever_width, lever_length, 1], anchor=TOP)
				position(FRONT)
				cuboid([2, 2, 3.2], anchor=TOP+FRONT);

			attach(TOP)
			tag("remove") text3d("ESP-32", font="monospace", spin=90, h=wall, center=true);
		}
	}
}

$fn = 100;

%esp32();

enclosure(open=true);
