////////////////////////////////////////////////////////////////////////////////
// Louver Lid Riser - https://github.com/myname-random/louver-lid-riser/
// Configuration and Settings for all modules
// © 2026 by Morgan Conner
// Licensed under CC BY-NC-SA 4.0
// To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/4.0/ 
// 
////////////////////////////////////////////////////////////////////////////////

// https://github.com/BelfrySCAD/BOSL2
include <BOSL2/std.scad>
include <BOSL2/gears.scad>
include <BOSL2/joiners.scad>

$fa=$preview?1:.1;
$fs=$preview?2:.05;

printMath = true;

rackHandle = "wedge"; // ["wedge":"Wedge", "rib":"Rib", "none":"None"]

baseWall = 3;

lidWidth = 404;
lidDepth = 428;
lidHeight = 3;
lidCornerRadius = 5;
lidLipDepth = 15;
lidLipInnerCornerRadius = 10;
cornerChannelInset = 8;

lidPressureLift = 0.4;

dovetailRounding = 1;

gearHeight = 6;
gearPadding = 0.3;
rackBottom = 3;

louverThickness = 4;
louverHeight = 30;
louverWidthStart = 30;
louverOverlap = 4;

channelLengthFront = lidWidth - ((lidLipDepth + lidLipInnerCornerRadius) * 2);
channelLengthSide = lidDepth - ((lidLipDepth + lidLipInnerCornerRadius) * 2);
channelLength = channelLengthFront;

spacerHeight = lidHeight;
spacerWidth = louverThickness + 2;
spacerTolerance = 0.4;
spacerWidthMask = louverThickness + 2 + (spacerTolerance * 2);

// Gear Math
teethN = 10;
gearM = louverWidthStart / (teethN * PI);
gearMod = max(0.75, round(gearM * 2) / 2);
louverCenterWidth = gearMod * teethN * PI;
gearTeeth = 12;
gearOuter = outer_radius(mod=gearMod, teeth=gearTeeth);
gearOuterPadded = gearOuter + (gearPadding / 2);
gearRackDist = gear_dist(mod=gearMod, teeth1=gearTeeth, teeth2 = 0 );
rackDepth = gearOuter - root_radius(mod=gearMod, teeth=gearTeeth) + rackBottom + gearPadding;
//Need half a rotation of the gear plus space for the handle at either side.
rackHandleCutout = rackHandle == "none" ? 0 : (gearOuterPadded * PI) + (gearHeight * 2);

// Louver Math
louverCountFront = louverCount( channelLengthFront );
louverPaddingFront = channelPadding( channelLengthFront, louverCountFront );

louverCountSide = louverCount( channelLengthSide );
louverPaddingSide = channelPadding( channelLengthSide, louverCountSide );

// Gear channel sizing
channelHeight = gearHeight + (gearPadding * 2);
channelDepthOutside = gearRackDist + rackBottom + gearPadding;
channelDepthInside = gearOuter + gearPadding;

// Gear box sizing
// The wall thickness at the top of the box must equal the spacer height.
gearBoxHeight = baseWall + channelHeight + spacerHeight;
gearBoxDepth = channelDepthOutside + channelDepthInside + (baseWall * 2);
gearBoxDepthOutside = channelDepthOutside + baseWall;
gearBoxDepthInside = channelDepthInside + baseWall;
gearBoxLengthFront = channelLengthFront + (cornerChannelInset * 2);
gearBoxLengthSide = channelLengthSide + (cornerChannelInset * 2);

linkWidth = gearBoxDepthOutside + gearBoxDepthInside + spacerTolerance;

frameHeight = gearBoxHeight + louverHeight + spacerHeight + spacerTolerance;
cornerSize = gearBoxDepthOutside + gearBoxDepthInside + spacerTolerance + (baseWall * 2) + lidLipInnerCornerRadius;

if (printMath) {

echo( str_join(
    [
    "",
    "-- Gear Math & Louver Sizing --",
    format("{}: {:i}", ["Distance between gear centers in Teeth", teethN]),
    format("{}: {:.4f}", ["Initial mod value for gears", gearM]),
    format("{}: {:.4f}", ["Rounded mod value for gears", gearMod]),
    format("{}: {:.2f}", ["Initial louver width preference", louverWidthStart]),
    format("{}: {:.4f}", ["Computed louver width", louverCenterWidth]),
    format("{}: {:i}", ["Number of gear teeth", gearTeeth]),
    format("{}: {:.4f}", ["Gear outer radius", gearOuter]),
    format("{}: {:.4f}", ["Gear to rack distance", gearRackDist]),
    format("{}: {:i}", ["Channel length for front and rear", channelLengthFront]),
    format("{}: {:i}", ["Count of louvers for front or rear", louverCountFront]),
    format("{}: {:.4f}", ["Padding to cover between corner and front louvers", louverPaddingFront]),
    format("{}: {:i}", ["Channel length for each side", channelLengthSide]),
    format("{}: {:i}", ["Count of louvers for each side", louverCountSide]),
    format("{}: {:.4f}", ["Padding to cover between corner and side louvers", louverPaddingSide]),
    "-- Channel Sizing --",
    format("{}: {:.4f}", ["Channel height", channelHeight]),
    format("{}: {:.4f}", ["Channel depth outside", channelDepthOutside]),
    format("{}: {:.4f}", ["Channel depth inside", channelDepthInside]),
    "-- Gear Box Sizing --",
    format("{}: {:.4f}", ["Gear box height", gearBoxHeight]),
    format("{}: {:.4f}", ["Gear box depth outside", gearBoxDepthOutside]),
    format("{}: {:.4f}", ["Gear box depth inside", gearBoxDepthInside]),
    format("{}: {:.4f}", ["Gear box length for front and rear", gearBoxLengthFront]),
    format("{}: {:.4f}", ["Gear box length for each side", gearBoxLengthSide]),
    format("{}: {:.4f}", ["Gear box link size", linkWidth]),
    "-- Corner & Frame Sizing --",
    format("{}: {:.4f}", ["Frame height", frameHeight]),
    format("{}: {:.4f}", ["Corner size", cornerSize]),
    "-- End Print Math --",
    ""
    ],
    "\n"
));
}

function channelPadding( channelLength, count ) = 
    (channelLength - ((louverCenterWidth * count) + louverOverlap)) / 2;

function louverCount( channelLength ) = 
    let(count = floor((channelLength - louverOverlap) / louverCenterWidth))
    channelPadding(channelLength, count) < louverOverlap
        ? count - 1
        : count
    ;