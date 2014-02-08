module cube_round(size, center = false, r=0)
{
    sx = size[0] - 2 * r;
    sy = size[1] - 2 * r;
    sz = size[2] - 2 * r;
    translate([r, r, r]) hull() {
        for (offset=[[0, 0, 0],
                     [0, 0, sz],
                     [0, sy, sz],
                     [0, sy, 0],
                     [sx, sy, 0],
                     [sx, sy, sz],
                     [sx, 0, sz],
                     [sx, 0, 0]])
        {
            translate(offset) sphere(r);
        }
    }
}

module expand(r) {
    minkowski() {
        child();
        sphere(r);
    }
}

// broken
module contract(r) {
    difference() {
        cube([100000,100000,100000], center=true);
        minkowski() {
            difference() {
                cube([100000,100000,100000], center=true);
                child();
            }
            sphere(r);
        }
    }
}

module hexr(radius)
{
    cos30 = cos(30);
    // Rotating the hex puts it at an angle that's more convenient for printing
    // the parts --- easier to just apply it to every hex here than per-piece
    scale([radius, radius]) rotate(30, [0, 0, 1]) polygon(
        points=[[-cos30, .5],
                [0, 1],
                [cos30, .5],
                [cos30, -.5],
                [0, -1],
                [-cos30, -.5]],
        paths=[[0, 1, 2, 3, 4, 5, 0]]
    );
}

module hexa(apothem)
{
    cos30 = cos(30);
    hexr(apothem / cos30);
}

module hexa_prz(apothem, height)
{
    linear_extrude(height = height, center = true, convexity = 2, twist = 0) {
        hexa(apothem);
    }
}

module clearance_hull(clearance) {
    hull() {
        for (x = [-clearance, clearance]) for (y = [-clearance, clearance]) for (z = [-clearance, clearance]) {
            translate([x, y, z]) child();
        }
    }
}

module rz(theta) {
    rotate(theta, [0, 0, 1]) {
        child();
    }
}
