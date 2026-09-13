////////////////////////////////////////////////////////////////////////////////
// Louver Lid Riser - https://github.com/myname-random/louver-lid-riser/
// Louver gear module
// © 2026 by Morgan Conner
// Licensed under CC BY-NC-SA 4.0
// To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/4.0/ 
// 
////////////////////////////////////////////////////////////////////////////////

include <iConfig.scad>
use <mRoundedPeg.scad>

module louverGear() {
    spur_gear(
        mod = gearMod,
        teeth = gearTeeth,
        thickness = gearHeight,
    )
    attach( TOP, BOTTOM )
        roundedPeg(units = 2);
}

//Print according to louver count required. K2 Plus count is 42 with default values.
louverGear();