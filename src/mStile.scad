////////////////////////////////////////////////////////////////////////////////
// Louver Lid Riser - https://github.com/myname-random/louver-lid-riser/
// Top and bottom stile components
// © 2026 by Morgan Conner
// Licensed under CC BY-NC-SA 4.0
// To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/4.0/ 
// 
////////////////////////////////////////////////////////////////////////////////

include <iConfig.scad>

module bottomStileChannel(front = true) {
    difference() {

    diff()
    cuboid([
        (front ? gearBoxLengthFront : gearBoxLengthSide),
        gearBoxDepth,
        gearBoxHeight
    ]) {
        attach(BOTTOM, TOP, align = BACK)
            cuboid([(front ? gearBoxLengthFront : gearBoxLengthSide), lidLipDepth, lidHeight])
                edge_mask(edges=[BOTTOM+BACK])
                    chamfer_edge_mask(
                        l = (front ? gearBoxLengthFront : gearBoxLengthSide),
                        chamfer = 3
                    );
        if (rackHandleCutout > 0) {
            tag("remove")
            attach(FRONT, FRONT, align = TOP, inside = true,
                inset = spacerHeight, overlap = .001
            )
                cuboid([ rackHandleCutout , baseWall + 0.002, channelHeight ]);
        }
        tag("remove")
        attach(FRONT, FRONT, align = BOTTOM, inside = true, 
            overlap = -baseWall, inset = baseWall
        )
            cuboid([
                (front ? channelLengthFront : channelLengthSide),
                rackDepth,
                channelHeight
            ], rounding = dovetailRounding, edges = [FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT] );
        tag("remove")
        attach(BACK, BACK, align = BOTTOM, inside = true,
            overlap = -baseWall, inset = baseWall
        )
            xcopies(
                n = (front ? louverCountFront : louverCountSide),
                spacing = louverCenterWidth
            )
            cyl(r = gearOuterPadded, h = channelHeight) {
                fwd(gearOuterPadded + gearPadding - rackDepth)
                attach(RIGHT, LEFT)
                    rounding_edge_mask( r = 4, h = channelHeight, excess = 2, 
                        anchor = BOTTOM );
                
                fwd(gearOuterPadded + gearPadding - rackDepth)
                attach(LEFT, LEFT)
                    rounding_edge_mask( r = 4, h = channelHeight, excess = 2, 
                        spin = 180, anchor = BOTTOM );
            }
    }
    
    up( (gearBoxHeight - spacerHeight) / 2)
    bottomStileLid(front = front, mask = true);
    }

}

module bottomStileLid(front = true, mask = false) {
    diff()
    cuboid([
        (front ? channelLengthFront : channelLengthSide),
        channelDepthOutside + channelDepthInside,
        spacerHeight
        ],
        rounding = dovetailRounding, edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]
    ) {
        if (!mask) {
            tag("remove")
            attach(BACK, BACK, align = BOTTOM, inside = true, inset = -spacerTolerance,
            overlap = (spacerWidthMask / 2) - gearOuterPadded
            )
                xcopies(
                    n = (front ? louverCountFront : louverCountSide),
                    spacing = louverCenterWidth
                )
                cyl(d = spacerWidthMask, h = spacerHeight + (spacerTolerance * 2));
        }
        attach(BACK, BOTTOM)
            xcopies(
                    n = (front ? louverCountFront : louverCountSide) + 1,
                    spacing = louverCenterWidth
                )
            dovetail((mask ? "female" : "male"),
                slide = lidHeight,
                width = floor(gearOuter),
                height = baseWall, $slop=0.05
            );
        attach(FRONT, BOTTOM)
            xcopies(
                    n = (front ? louverCountFront : louverCountSide) + 1,
                    spacing = louverCenterWidth
                )
            dovetail((mask ? "female" : "male"),
                slide = lidHeight,
                width = floor(gearOuter),
                height = baseWall, $slop=0.05
            );
        if (rackHandleCutout > 0) {
            attach(FRONT, BOTTOM)
                dovetail((mask ? "female" : "male"),
                    slide = lidHeight,
                    width = (
                        (louverCenterWidth - 4) > rackHandleCutout 
                        ? louverCenterWidth 
                        : louverCenterWidth * 2
                    ),
                    height = baseWall, $slop=0.05
                );
        }
        attach(RIGHT, BOTTOM)
            dovetail((mask ? "female" : "male"),
                slide = lidHeight,
                width = linkWidth / 2,
                height = cornerChannelInset, $slop=0.05
            );
        attach(LEFT, BOTTOM)
            dovetail((mask ? "female" : "male"),
                slide = lidHeight,
                width = linkWidth / 2,
                height = cornerChannelInset, $slop=0.05
            );
    }
}

module upperStile(front = true) {
    lipDepth = cornerSize - lidLipDepth - lidLipInnerCornerRadius - (baseWall * 2);
    diff()
    cuboid([
        (front ? channelLengthFront : channelLengthSide),
        gearBoxDepth,
        spacerHeight + spacerTolerance
    ]) {
        tag("remove")
        attach(BACK, BACK, align = BOTTOM, inside = true, inset = -spacerTolerance,
        overlap = (spacerWidthMask / 2) - gearOuterPadded - baseWall
        )
            xcopies(
                n = (front ? louverCountFront : louverCountSide),
                spacing = louverCenterWidth
            )
            cyl(d = spacerWidthMask, h = spacerHeight + (spacerTolerance * 2));
        attach(LEFT, BOTTOM, align = TOP)
            dovetail("male",
                slide = spacerHeight + spacerTolerance,
                width = gearBoxDepth / 2,
                height = cornerChannelInset,
                radius = dovetailRounding / 2, round = (dovetailRounding > 0)
            );
        attach(RIGHT, BOTTOM, align = TOP)
            dovetail("male",
                slide = spacerHeight + spacerTolerance,
                width = gearBoxDepth / 2,
                height = cornerChannelInset,
                radius = dovetailRounding / 2, round = (dovetailRounding > 0)
            );
        attach(TOP, BOTTOM, align=FRONT)
            cuboid([
                    (front ? channelLengthFront : channelLengthSide),
                    lipDepth,
                    lidHeight + lidPressureLift
                ],
                rounding = 1,
                edges = [TOP+FRONT, TOP+BACK] 
            );
    }
}

//For best results, render each component separately. Print each piece twice.
//Print bottom stile channel on its chamfered edge
back(gearBoxDepth) 
bottomStileChannel(front = true);

back(gearBoxDepth * 2.25) 
bottomStileLid(front = true, mask = false);

back(gearBoxDepth * 3.5) 
upperStile(front = true);

fwd(gearBoxDepth) 
bottomStileChannel(front = false);

fwd(gearBoxDepth * 2.25) 
bottomStileLid(front = false, mask = false);

fwd(gearBoxDepth * 3.5) 
upperStile(front = false);