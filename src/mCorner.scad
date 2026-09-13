////////////////////////////////////////////////////////////////////////////////
// Louver Lid Riser - https://github.com/myname-random/louver-lid-riser/
// Corner components module
// © 2026 by Morgan Conner
// Licensed under CC BY-NC-SA 4.0
// To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/4.0/ 
// 
////////////////////////////////////////////////////////////////////////////////

include <iConfig.scad>

// Sliding insert to pad from the corner to the first / last louver
module padPanel( front = true, left = true, mask = false ) {
    zcyl(
        r = louverThickness + (mask ? 0.1 : 0),
        h = louverHeight + (mask ? 0.1 : 0)
    )
    attach( 
        (left ? RIGHT : LEFT),
        (left ? LEFT : RIGHT),
        align = BOTTOM,
        overlap = louverThickness
    )
        cuboid([
                louverThickness + (front ? louverPaddingFront : louverPaddingSide),
                louverThickness + (mask ? 0.15 : 0),
                louverHeight + (mask ? 0.1 : 0)
            ],
            rounding = louverThickness / 4,
            edges = (left ? [FRONT+RIGHT] : [BACK+LEFT])
        )
        attach(
            (left ? RIGHT : LEFT),
            (left ? LEFT : RIGHT),
            align = (left ? BACK : FRONT)
        )
            tag_diff(tag = "padPanel")
            cuboid([
                    louverOverlap,
                    louverThickness / 2,
                    louverHeight + (mask ? 0.1 : 0)
                ],
                rounding = louverThickness / 4,
                edges = (left ? [BACK+RIGHT, FRONT+RIGHT] : [FRONT+LEFT, BACK+LEFT])
            )
            tag(left && !mask ? "keep" : "remove")
            attach(
                (left ? FRONT : BACK),
                FRONT,
                overlap = (louverThickness / 6)
            )
                zcyl(
                    h = louverHeight,
                    d = (louverThickness / 3) + (left ? 0 : .1) 
                );
}

module frameCorner() {
    tag_diff( tag = "frameCorner", remove = "cornerCover cornerMask channelInset padPanel coverDove")
    cuboid(
        [cornerSize, cornerSize, frameHeight - spacerHeight - spacerTolerance ],
        rounding = lidCornerRadius,
        edges = [FRONT+LEFT, FRONT+RIGHT, BACK+LEFT]
    ) {
        tag_diff(tag="cornerCover", remove="chunk")
        cuboid(
            [cornerSize, cornerSize, frameHeight],
            rounding = lidCornerRadius,
            edges = [FRONT+LEFT, FRONT+RIGHT, BACK+LEFT]
        )
            tag("chunk")
            attach(BACK+RIGHT, BACK+RIGHT, inside = true, align = BOTTOM)
                cuboid([
                        cornerSize - baseWall,
                        cornerSize - baseWall,
                        frameHeight + 0.001
                    ],
                    rounding = lidCornerRadius - baseWall,
                    edges = [FRONT+LEFT, FRONT+RIGHT, BACK+LEFT]
                );
        tag("cornerMask")
        down(lidHeight / 2)
        attach( BACK+RIGHT, CENTER, inside = true ) 
            ycyl(
                r1 = lidLipInnerCornerRadius - baseWall,
                r2 = lidLipInnerCornerRadius,
                h = frameHeight + lidHeight + .002
            );
            
        tag("lidFiller")
        attach(BOTTOM, TOP, align = BACK+RIGHT)
            cuboid([
                    lidLipDepth + lidLipInnerCornerRadius,
                    lidLipDepth + lidLipInnerCornerRadius, 
                    lidHeight
                ], 
                rounding = lidCornerRadius,
                edges = [FRONT+LEFT]
            );
            
        tag("channelInset")
            down((frameHeight - spacerHeight - spacerTolerance - gearBoxHeight + lidHeight) / 2)
            attach(FRONT, FRONT, inside = true, align = RIGHT, overlap = -(baseWall * 2) )
            cuboid([
                cornerChannelInset,
                gearBoxDepth,
                gearBoxHeight + lidHeight
            ]) {
                tag( "padPanel" )
                attach(TOP, BOTTOM, align = BACK,
                    inset = gearOuterPadded - louverThickness - 0.1 + baseWall
                )
                    padPanel(mask=true);
            }
        
        tag("channelInset")
        down((frameHeight - spacerHeight - spacerTolerance - gearBoxHeight + lidHeight) / 2)
        attach(LEFT, LEFT, inside = true, align = BACK, overlap = -(baseWall * 2) )
            cuboid([
                gearBoxDepth,
                cornerChannelInset,
                gearBoxHeight + lidHeight
            ]) {
                tag( "padPanel" )
                attach(TOP, BOTTOM, align = RIGHT, spin = 90,
                    inset = gearOuterPadded - louverThickness - 0.1 + baseWall
                )
                    padPanel(mask=true);
            }
        
        tag_diff(tag = "coverDove")
        yrot(180)
        attach(FRONT, BOTTOM, align = BOTTOM, inside = true, overlap = -baseWall)
            dovetail("female",
                slide = frameHeight,
                width = 15,
                height = cornerChannelInset,
                radius = dovetailRounding, round = (dovetailRounding > 0),
                taper = 3
            );
    }
}

module cornerCover() {
    tag_diff(tag="cornerCover")
    cuboid(
        [cornerSize, cornerSize, frameHeight + lidHeight + lidPressureLift],
        rounding = lidCornerRadius,
        edges = [FRONT+LEFT, FRONT+RIGHT, BACK+LEFT]
    ) {
        // Mask out most of the block
        tag("remove")
        attach(BACK+RIGHT, BACK+RIGHT, inside = true, align = BOTTOM)
            cuboid([
                    cornerSize - baseWall,
                    cornerSize - baseWall,
                    frameHeight + 0.001
                ],
                rounding = lidCornerRadius - baseWall,
                edges = [FRONT+LEFT, FRONT+RIGHT, BACK+LEFT]
            );
        // Mask out the space for the lid
        tag("remove")
        attach(BACK+RIGHT, BACK+RIGHT, inside = true, align = TOP)
            cuboid([
                    lidLipDepth + lidLipInnerCornerRadius,
                    lidLipDepth + lidLipInnerCornerRadius, 
                    lidHeight + lidPressureLift
                ], 
                rounding = lidCornerRadius,
                edges = [FRONT+LEFT]
            );
        // Add dovetail to secure cover
        down(lidHeight / 2)
        tag("keep")
        yrot(180)
        attach(FRONT, BOTTOM, align = BOTTOM, inside = true, overlap = -baseWall, inset = lidHeight / 2)
            dovetail("male",
                slide = frameHeight,
                width = 15,
                height = cornerChannelInset,
                radius = dovetailRounding, round = (dovetailRounding > 0),
                taper = 3);
    }
}

module cornerLink() {
    tag_diff( tag = "cornerLink", remove = "cornerCover doves cornerCutout" )
    cuboid(
        [cornerSize, cornerSize, spacerHeight + spacerTolerance],
        rounding = lidCornerRadius,
        edges = [FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]
    ) {
        tag_diff(tag="cornerCover", remove="chunk")
        cuboid(
            [cornerSize, cornerSize, frameHeight],
            rounding = lidCornerRadius,
            edges = [FRONT+LEFT, FRONT+RIGHT, BACK+LEFT]
        )
            tag("chunk")
            attach(BACK+RIGHT, BACK+RIGHT, inside = true, align = TOP)
                cuboid([
                        cornerSize - baseWall,
                        cornerSize - baseWall,
                        frameHeight + 0.001
                    ],
                    rounding = lidCornerRadius - baseWall,
                    edges = [FRONT+LEFT, FRONT+RIGHT, BACK+LEFT]
                );
    
        // Corner cover dovetail
        tag_diff(tag = "doves")
        yrot(180)
        attach(FRONT, BOTTOM, inside = true, align = BOTTOM, overlap = -baseWall)
            dovetail("female",
                slide = frameHeight,
                width = 15,
                height = cornerChannelInset,
                radius = dovetailRounding, round = (dovetailRounding > 0),
                taper = 3
            );

        // Side louver cover dovetail
        tag_diff(tag = "doves")
        attach(RIGHT, BOTTOM, inside = true, align = FRONT,
            inset =  ((gearBoxDepthOutside + gearBoxDepthInside) / 4) + (baseWall * 2)
        )
            dovetail("female",
                slide = spacerHeight + spacerTolerance,
                width = (gearBoxDepthOutside + gearBoxDepthInside) / 2,
                height = cornerChannelInset,
                radius = dovetailRounding / 2, round = (dovetailRounding > 0)
            );

        // Back louver cover dovetail
        tag_diff(tag = "doves")
        attach(BACK, BOTTOM, inside = true, align = LEFT,
            inset =  ((gearBoxDepthOutside + gearBoxDepthInside) / 4) + (baseWall * 2)
        )
            dovetail("female",
                slide = spacerHeight + spacerTolerance,
                width = (gearBoxDepthOutside + gearBoxDepthInside) / 2,
                height = cornerChannelInset,
                radius = dovetailRounding / 2, round = (dovetailRounding > 0)
            );

        // Corner cutout
        tag("cornerCutout")
        attach(BACK+RIGHT, CENTER, inside = true)
            ycyl(h = spacerHeight + spacerTolerance + 0.1, r = lidLipInnerCornerRadius);

        // Lid Lif
        tag("lidSupport")
        up((spacerHeight + spacerTolerance + lidPressureLift) / 2)
        attach(BACK+RIGHT, CENTER, overlap = lidLipInnerCornerRadius * 1.75)
            ycyl(h = lidPressureLift, r = lidLipInnerCornerRadius / 2);
    }
}

//Generate each component individually for best results. Print each 4 times.
// Base corner component
frameCorner();
// Corner cover component
left(40) cornerCover();
// Corner link component
right(40) cornerLink();

// Padding Panels are sized for front and sides, positive and negative. Print 2 of each.
right(120) padPanel(front = true, left = true);
right(100) padPanel(front = true, left = false);
back(10) right(120) padPanel(front = false, left = true);
back(10) right(100) padPanel(front = false, left = false);