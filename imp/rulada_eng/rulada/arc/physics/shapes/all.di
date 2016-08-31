/******************************************************************************* 

	AllFile Generated by AllDGenerator

	Authors:		ArcLib team, see AUTHORS file
	Maintainer:		Clay Smith (clayasaurus at gmail dot com)
	License:		zlib/libpng license: $(LICENSE) 
	Copyright:		ArcLib team 

	Description:    
		AllFile Module imports all files below subdirectory

*******************************************************************************/

module arc.physics.shapes.all;

public import
	arc.physics.shapes.box,
	arc.physics.shapes.circle,
	arc.physics.shapes.line;

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
