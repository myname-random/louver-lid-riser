////////////////////////////////////////////////////////////////////////////////
// Louver Lid Riser - https://github.com/myname-random/louver-lid-riser/
// Louver module
// © 2026 by Morgan Conner
// Licensed under CC BY-NC-SA 4.0
// To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/4.0/ 
// 
////////////////////////////////////////////////////////////////////////////////

include <iConfig.scad>
use <mRoundedPeg.scad>

module louverOverlap(negative = false) {
    tag_diff("overlap", "remove")
    cuboid(
        [louverOverlap, louverThickness / 2, louverHeight],
        rounding = louverThickness / 4,
        edges = (negative ? [FRONT+LEFT, BACK+LEFT] : [BACK+RIGHT, FRONT+RIGHT])
    )
    attach(
        (negative ? BACK : FRONT),
        (negative ? FRONT : BACK),
        overlap = (louverThickness / 6)
    )
    tag((negative ? "remove" : "keep"))
    zcyl( h = louverHeight, d = (louverThickness / 3) + (negative ? 0.2 : 0) );
}

module louverPegCover() {
    xscale(1.4)
    zcyl(
        h = spacerHeight * 2,
        d1 = louverThickness * 2.5,
        d2 = louverThickness * 1.5,
        rounding2 = louverThickness * 0.75
    );
}

module louver() {
    tag_diff(tag = "louver", remove = "riserMask")
    cuboid(
        [louverCenterWidth - louverOverlap, louverThickness, louverHeight],
        rounding = louverThickness / 4,
        edges = [FRONT+RIGHT, BACK+LEFT]
    ) {
        attach(RIGHT, LEFT, align = BACK) louverOverlap();
        attach(LEFT, RIGHT, align = FRONT) louverOverlap(negative=true);
        attach(BOTTOM, BOTTOM, inside = true) louverPegCover();
        attach(TOP, BOTTOM, inside = true) louverPegCover();
        attach(BOTTOM, BOTTOM, inside = true) roundedPeg(units = 1, mask = true);
        attach(TOP, BOTTOM) roundedPeg(units = 1);
    }
}

// Print according to louver count required. K2 Plus count is 42 at default values.
louver();