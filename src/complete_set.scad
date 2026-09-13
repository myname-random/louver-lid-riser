////////////////////////////////////////////////////////////////////////////////
// Louver Lid Riser - https://github.com/myname-random/louver-lid-riser/
// Full Build File
// © 2026 by Morgan Conner
// Licensed under CC BY-NC-SA 4.0
// To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/4.0/ 
// 
////////////////////////////////////////////////////////////////////////////////

// **Note**: This will show all the components, but your slicer would probably
// much prefer to import one copy of each component and clone them there. It
// makes the 3MF file a lot smaller since it won't keep multiple copies of the
// same object. 

include <iConfig.scad>
use <mStile.scad>
use <mCorner.scad>
use <mRack.scad>
use <mLouver.scad>
use <mGear.scad>

up((gearBoxHeight / 2) + lidHeight) {
    bottomStileChannel(front = true);
    back(gearBoxDepth + 2) bottomStileChannel(front = true);
    back((gearBoxDepth + 2) * 2) bottomStileChannel(front = false);
    back((gearBoxDepth + 2) * 3) bottomStileChannel(front = false);
}

up(spacerHeight / 2) {
    back((gearBoxDepth + 2) * 4) bottomStileLid(front = true);
    back((gearBoxDepth + 2) * 5) bottomStileLid(front = true);
    back((gearBoxDepth + 2) * 6) bottomStileLid(front = false);
    back((gearBoxDepth + 2) * 7) bottomStileLid(front = false);
}

up((spacerHeight + spacerTolerance) / 2) {
    back((gearBoxDepth + 2) * 8) upperStile(front = true);
    back((gearBoxDepth + 2) * 9) upperStile(front = true);
    back((gearBoxDepth + 2) * 10) upperStile(front = false);
    back((gearBoxDepth + 2) * 11) upperStile(front = false);
}

right((gearBoxLengthSide + cornerSize + 10) / 2) {
    ycopies(n = 4, spacing = cornerSize + 2)
        up((frameHeight - spacerHeight - spacerTolerance) / 2)
        yrot(180) frameCorner();

    right(cornerSize + 2)
    ycopies(n = 4, spacing = cornerSize + 2)
        up((frameHeight + lidHeight) / 2)
        yrot(180) cornerCover();

    back((cornerSize + 2) * 3) {
        padPanel(front = true, left = true);
        right(louverPaddingFront * 2) padPanel(front = true, left = true);
        right(louverPaddingFront) back(louverThickness * 2) {
            padPanel(front = true, left = false);
            right(louverPaddingFront * 2) padPanel(front = true, left = false);
        }
        back(louverThickness * 4) {
            padPanel(front = false, left = true);
            right(louverPaddingFront * 2) padPanel(front = false, left = true);
        }
        right(louverPaddingFront) back(louverThickness * 6) {
            padPanel(front = false, left = false);
            right(louverPaddingFront * 2) padPanel(front = false, left = false);
        }
    }
    right((cornerSize + 2) * 2)
    ycopies(n = 4, spacing = cornerSize + 2)
        up((spacerHeight + spacerTolerance) / 2)
        yrot(180) cornerLink();
}

fwd(gearBoxDepth + 2) {
    up(gearHeight / 2) xrot(-90) stileRack(front = true, slider = "none");
    fwd(rackBottom * 2) up(gearHeight / 2) xrot(-90) stileRack(front = true, slider = "none");
    fwd(rackBottom * 4) up(gearHeight / 2) xrot(-90) stileRack(front = false, slider = "none");
    fwd(rackBottom * 6) up(gearHeight / 2) xrot(-90) stileRack(front = false, slider = "none");

    fwd(rackBottom * 8) {
        up(gearHeight / 2) xrot(-90) stileRack(front = true, slider = "rib");
        fwd(rackBottom * 3) up(gearHeight / 2) xrot(-90) stileRack(front = true, slider = "rib");
        fwd(rackBottom * 6) up(gearHeight / 2) xrot(-90) stileRack(front = false, slider = "rib");
        fwd(rackBottom * 9) up(gearHeight / 2) xrot(-90) stileRack(front = false, slider = "rib");
    }

    fwd(rackBottom * 20) {
        up(gearHeight / 2) xrot(-90) stileRack(front = true, slider = "wedge");
        fwd(((rackBottom * 2) + (baseWall * 4)))
            up(gearHeight / 2) xrot(-90) stileRack(front = true, slider = "wedge");
        fwd(((rackBottom * 2) + (baseWall * 4)) * 2) 
            up(gearHeight / 2) xrot(-90) stileRack(front = false, slider = "wedge");
        fwd(((rackBottom * 2) + (baseWall * 4)) * 3)
            up(gearHeight / 2) xrot(-90) stileRack(front = false, slider = "wedge");
    }
}

louverCount = (louverCountFront * 2) + (louverCountSide * 2);
louverGrid = floor(sqrt(louverCount));
louverRem = louverCount - (louverGrid * louverGrid);
bonusRows = floor(louverRem / (louverGrid / 2));
louverExtras = louverRem - (bonusRows * (louverGrid / 2));
louverXspace = louverCenterWidth + (louverOverlap * 2);
louverYspace = louverThickness * 3;

left(
        ((louverGrid / 4) * louverXspace)
        + ((gearBoxLengthSide + cornerSize) / 2)
    ) {
    back( (louverGrid + 1 + ceil(bonusRows/2)) * louverYspace )
        grid_copies(
            spacing = [louverXspace, louverYspace],
            n = [louverGrid / 2, (louverGrid * 2) + bonusRows]
        )
            up(louverHeight / 2) louver();

    xcopies(n = louverExtras, spacing = louverXspace)
        up(louverHeight / 2) louver();
}

gearCount = louverCount;
gearGrid = floor(sqrt(gearCount));
gearRem = gearCount - (gearGrid * gearGrid);
bonusRowsG = floor(gearRem / gearGrid);
gearExtras = gearRem - (bonusRows * gearGrid);
gearSpace = gearOuterPadded * 3;

left( ((gearGrid / 2) * gearSpace) + ((gearBoxLengthSide + cornerSize) / 2) ) {
    fwd( ceil((gearGrid + bonusRowsG + 1) / 2) * gearSpace )
        grid_copies(
            spacing = gearSpace,
            n = [gearGrid, gearGrid + bonusRowsG]
        )
            up(gearHeight / 2) louverGear();

    xcopies(n = gearExtras, spacing = gearSpace)
        up(gearHeight / 2) louverGear();
}