# OpenSCAD Models

Collection of useful printable models built with OpenSCAD.

The examples pictured here were printed using Elegoo Centauri Carbon with Elegoo PLA filament unless noted otherwise.

Only the base openscad files are included, in case a model needed extra supports for printing, they were generated using Orca Slicer

## IKEA VATTENKAR Tool Holders

A simple 3d model for tool holders that clip onto the ikea vattenkar mini-shelves.

The tool holder model is defined using [openscad](https://openscad.org/) and can be easily adjusted for various tools by changing the width, depth and height parameters as well as the label.

![screenshot from the openscad viwer showing an example tool holder box](/images/tool_holder_screenshot.png)
![screenshot from the openscad viwer showing an example tool holder box from its side, revealing a clip that mates up with the rim of the shelf](/images/tool_holder_side_screenshot_side.png)

![photo of multiple 3d printed tool holders mounted on the shelf](/images/tool_holder_photo.jpeg)

## ESP32-WROOM Enclosure

A small box with a removable lid for an ESP32-WROOM dev board with cutouts for a USB-C port, the devboard's IO pins and push-through buttons.

Includes a mockup of the dev board itself.

![screenshot of the open esp32 box](/images/esp32_box_open.png)
![screenshot of the bottom of the esp32 box](/images/esp32_box_bottom.png)
![screenshot of the esp32 dev board mockup](/images/esp32.png)
![photo of the esp32 dev board mounted in the box](/images/esp32_box_photo.jpeg)

## Solight Multimeter Cable Clamp

A simple clamp to hold the probe cables of a multimeter for easier storage.

![screenshot of the cable clamp model](/images/multimeter_clamp.png)
![photo of the clamp holding cables of the multimeter](/images/multimeter_photo.jpeg)

## License

The `src/*.scad` source code is licensed under [BSD-3-Clause](https://opensource.org/license/BSD-3-Clause) license.

Many of the files rely on the Belfry OpenScad Library (BOSL2) which is included as a git submodule.
BOSL2 itself is licensed under [BSD-2-Clause](https://opensource.org/license/BSD-2-Clause).
