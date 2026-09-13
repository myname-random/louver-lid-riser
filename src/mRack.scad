////////////////////////////////////////////////////////////////////////////////
// Louver Lid Riser - https://github.com/myname-random/louver-lid-riser/
// Louver control rack module
// © 2026 by Morgan Conner
// Licensed under CC BY-NC-SA 4.0
// To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/4.0/ 
// 
////////////////////////////////////////////////////////////////////////////////

include <iConfig.scad>

module sliderWedge() {
    prismoid(
        size1 = [gearHeight, gearHeight],
        size2 = [gearHeight * (2/3), gearHeight],
        h = baseWall * 4,
        chamfer = 1
    );
}

module sliderRib() {
    rack(
        thickness = gearHeight,
        bottom = baseWall + 1,
        mod = gearMod, 
        teeth = 3
    );
}

module stileRack(front = true, slider = "wedge") {
    rack(
        thickness = gearHeight,
        bottom = rackBottom,
        mod = gearMod, 
        teeth = floor(
            ((front ? channelLengthFront : channelLengthSide) - louverCenterWidth)
            / (gearMod * PI)
        )
    ) {
        if (slider == "none") {
        } else if (slider == "rib") {
            attach(BOTTOM, BOTTOM, overlap = 0.2) sliderRib();
        } else {
            attach(BOTTOM, BOTTOM, overlap = 0.2) sliderWedge();
        }
    }
}

// Print two of each for the full build.
back(gearHeight * 2) stileRack(front = false, slider = rackHandle);
stileRack(front = true, slider = rackHandle);

// Uncomment to generate sample of each handle
//back(25)xrot(90) stileRack(slider="wedge");
//back(10) xrot(90) stileRack(slider="rib");
//xrot(90) stileRack(slider="none");


