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
 *
 * If your mill bit does not intersect the origin, results may be odd.
**/
module antiminkowski(huge=4000000000) {
    echo ($children, "children in antiminkowski");
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
        cube([12, 4, 4], center=true);
    }
}

module antiminkowski_example() {
    antiminkowski_example_part();
    translate([15, 0, 0]) sphere(r=2);
    translate([15, 0, 0]) antiminkowski() {
        sphere(r=2);
        antiminkowski_example_part();
    }
}

render() antiminkowski_example();
