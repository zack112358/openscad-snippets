/**
 * Library of minkowski-related tricks for OpenSCAD. They are all incredibly
 * slow.
**/

/* Select parts to display */
//render() antiminkowski_example();
//render() translate([0, 0, 15]) chamfer_convex_example();
render() translate([0, 0, 30]) chamfer_concave_example();

/**
 * A minkowski operation convolves two objects' set membership functions. Using
 * Minkowski with a sphere and a part shape gives you the shape of the void you
 * would get if a spherical mill bit followed a path that included every point
 * in the part.
 *
 * The antiminkowski I'm writing is a little different. I want the shape of the
 * material that would be left behind if the mill bit followed every surface on
 * the exterior surface of the part. Essentially, while the original Minkowski
 * expands the part, the antiminkowski will contract it.
 *
 * First child is the "mill bit", and second child is the part.
**/
module antiminkowski(huge=4000000000) {
    // Subtract the expanded mold from the original part
    difference() {
        cube([huge, huge, huge], center=true);
        // Expand the mold form around the part with the "mill bit".
        minkowski() {
            // The "mill bit"
            child(0);
            // Make a mold form around the part. We approximate the complement
            // of a finite part by subtracting the part from a very large box.
            difference() {
                cube([huge, huge, huge], center=true);
                child(1);
            }
        }
    }
}

module antiminkowski_example_part() {
    render() difference() {
        cube([12, 12, 12], center=true);
        cube([12, 5, 5], center=true);
    }
}

module antiminkowski_example() {
    antiminkowski_example_part();
    translate([0, 15, 0]) sphere(r=2);
    translate([0, 15, 0]) antiminkowski() {
        sphere(r=2);
        antiminkowski_example_part();
    }
}

/**
 * Does what you think scale([-1, -1, -1]) ought to do, but without crashing
 * OpenSCAD.
**/
module mirror3() {
    rotate(180, [1, 0, 0]) mirror([1, 0, 0]) child();
}

/**
 * Chamfer outside (convex) corners of a part. First child is shape of chamfer,
 * second child is part. If, for example, you want round chamfers everywhere,
 * use a spherical chamfer shape. If you want round chamfers only on the
 * up-sides of edges and not on bottom edges, you could use a hemisphere shape.
 *
 * Essentially, this will get you the shape of the void created by a mill bit in
 * the chamfer shape milling out as much material as possible while staying
 * entirely within the part volume.
 *
 * If your chamfer shape is larger than some of the details on the part, the
 * details may be obliterated --- if the details are smaller than your mill bit,
 * the mill bit can't get in there to make them.
**/
module chamfer_convex() {
    minkowski() {
        child(0);
        antiminkowski() {
            mirror3() child(0);
            child(1);
        }
    }
}

module chamfer_convex_example() {
    antiminkowski_example_part();
    translate([0, 15, 0]) sphere(r=2);
    translate([0, 15, 0]) chamfer_convex() {
        sphere(r=2);
        antiminkowski_example_part();
    }
}

/**
 * Chamfer inside (concave) corners of a part. First child is shape of chamfer,
 * second child is part. If, for example, you want round chamfers everywhere,
 * use a spherical chamfer shape.
 *
 * Essentially, this will get you the shape of the part left by a mill bit in
 * the chamfer shape milling away as much material as possible while staying
 * entirely outside the part volume.
 *
 * If your chamfer shape is larger than some of the details on the part, the
 * details may be obliterated --- if the details are smaller than your mill bit,
 * the mill bit can't get in there to make them.
**/
module chamfer_concave() {
   antiminkowski() {
       child(0);
       minkowski() {
           mirror3() child(0);
           child(1);
       }
   }
}

module chamfer_concave_example() {
    antiminkowski_example_part();
    //translate([0, 15, 0]) sphere(r=2);
    translate([0, 15, 0]) chamfer_concave() {
        sphere(r=2);
        antiminkowski_example_part();
    }
}
