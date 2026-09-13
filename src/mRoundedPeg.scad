////////////////////////////////////////////////////////////////////////////////
// Louver Lid Riser - https://github.com/myname-random/louver-lid-riser/
// Rounded Peg Module
// © 2026 by Morgan Conner
// Licensed under CC BY-NC-SA 4.0
// To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/4.0/ 
// 
////////////////////////////////////////////////////////////////////////////////
include <iConfig.scad>

module roundedPeg(units = 1, mask = false) {
    halfMask = (louverThickness / 2) + (mask ? spacerTolerance / 2 : 0);
    pegWidth = louverThickness + 2 + (mask ? spacerTolerance : 0);
    totalHeight = (spacerHeight * units) + (mask ? spacerTolerance : 0);
    
    tag_diff((mask ? "riserMask" : "riser"), "remove")
    front_half(y = halfMask)
    back_half(y = -halfMask)
    cyl( d = pegWidth, h = totalHeight );
}


// Do not independently print these. They are included elsewhere as needed.
right(louverThickness + 2)
    roundedPeg(units = 1, mask = false);
right(((louverThickness + 2 + spacerTolerance) * 2) + spacerTolerance)
    roundedPeg(units = 1, mask = true);
left(louverThickness + 2)
    roundedPeg(units = 2, mask = false);
left(((louverThickness + 2 + spacerTolerance) * 2) + spacerTolerance)
    roundedPeg(units = 2, mask = true);