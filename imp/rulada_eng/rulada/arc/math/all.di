/******************************************************************************* 

	AllFile Generated by AllDGenerator

	Authors:		ArcLib team, see AUTHORS file
	Maintainer:		Clay Smith (clayasaurus at gmail dot com)
	License:		zlib/libpng license: $(LICENSE) 
	Copyright:		ArcLib team 

	Description:    
		AllFile Module imports all files below subdirectory

*******************************************************************************/

module arc.math.all;

public import
	arc.math.angle,
	arc.math.arcfl,
	arc.math.collision,
	arc.math.matrix,
	arc.math.point,
	arc.math.rect,
	arc.math.routines,
	arc.math.size;

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}