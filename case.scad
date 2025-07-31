/*
  Case with snap-on top for easy-nrf52-pro-micro_e22 DIY Meshtastic pocket node
  Copyright (c) 2025 Bradley Bosch
  This prints and fits well for me, but may still needs some parameterization improvement.
  If you change a parameter, you might want to double check it didn't have an unexpected
  effect before you print.
*/
$fn = 50; // Change default faces to something reasonable
top=0.0;
thick=5; // The walls are thick/2 thick // Bug: other numbers still depend on this
ledge=3; // depth of ledge // increasing this is likely to interfere with holes
diameter=4; // Bug
lid_d=2.5;
ledge_off=lid_d/2+0.3; // increase for tighter lid
box_x=102;
box_y=27;
box_z=11.3; // 9 minimum for SMA
stay_drop=7.0; // Bug: needs to depend on box_z
pipe_length=5; // Bug: needs to depend on box_z
ant_x=19 + diameter;
ant_y=12;
mount_y=49.2;
mount_w=2.5;
mount_h=2.75;
sma_d=7.2;
switch_l=18;
switch_d=7;
switch_hole=5.7;
switch_loc=1;
usb_h=3.8;
usb_l=2.0;
usb_w=9.4;
usb_x=-4.85;
usb_z=5.68;
module bottom(extra=0) {
    difference () {

        minkowski() {
            union() {
                translate([(box_x + (ant_x - diameter))/2-.001,(box_y-ant_y)/2,0])
                cube([ant_x+thick-diameter,ant_y+thick-diameter,box_z+thick-diameter],center = true);
                cube([box_x+thick-diameter,box_y+thick-diameter,box_z+thick-diameter],center = true);
            }
            sphere(d=diameter+extra);
        }

        // chopp off top
        translate([0,0,box_z-top]) cube([(box_x+thick+diameter+ant_x)*2,box_y+thick+diameter*2+1,box_z],center = true);

        // cut out ledge for snap lid
        translate([0,0,box_z/2-top-ledge_off]) {
            minkowski() {
                union() {
                    cube([box_x+thick/2-lid_d,box_y+thick/2-lid_d,ledge-lid_d+.75],center = true);
                    translate([(box_x+(ant_x - diameter))/2,(box_y-ant_y)/2,0])
                    cube([ant_x+thick/2-lid_d,ant_y+thick/2-lid_d,ledge-lid_d+.75],center = true);
                }
                sphere(d=lid_d);
            }
        }
        
        // hollow inside
        translate([0,0,0]) {
            cube([box_x,box_y,box_z],center = true);
            translate([(box_x+(ant_x - diameter))/2,(box_y-ant_y)/2,0])
                cube([ant_x+.001,ant_y,box_z+.001],center = true);
        }   
    }
}

module top() {
    rotate([180,0,0])  {
        difference () {

            minkowski() {
                union() {
                    translate([(box_x+(ant_x - diameter))/2,(box_y-ant_y)/2,0])
                    cube([ant_x+thick-diameter,ant_y+thick-diameter,box_z+thick-diameter],center = true);
                    cube([box_x+thick-diameter,box_y+thick-diameter,box_z+thick-diameter],center = true);
                }
                sphere(d=diameter);
            }

            // reverse ledge
            bottom(extra=1);

            // chopp off bottom
            #translate([0,0,-top-ledge-.2]) cube([(box_x+thick+diameter+ant_x)*2,box_y+thick+diameter+1,box_z],center = true);

            // hollow inside
            union() {
                cube([box_x,box_y,box_z],center = true);
                translate([(box_x+(ant_x - diameter))/2,(box_y-ant_y)/2,0])
                cube([ant_x+.002,ant_y+.002,box_z+.002],center = true);
            }

            // led holes
            translate([-box_x/2 + 8, box_y/2 - 3.5, box_z/2])
                #cylinder(thick-.4, d=3, center=true);
                translate([-box_x/2 + 8, -.5, box_z/2])
                #cylinder(thick-.4, d=3, center=true);
                }
        // led light guides
        difference () {
            translate([-box_x/2 + 8, box_y/2 - 3.5, box_z/2-2])
                cylinder(pipe_length, d=4, center=true);
            translate([-box_x/2 + 8, box_y/2 - 3.5, box_z/2-2-.001])
                #cylinder(pipe_length, d=3, center=true);
                }
        difference () {
            translate([-box_x/2 + 8, -.5, box_z/2-2])
                cylinder(pipe_length, d=4, center=true);
            translate([-box_x/2 + 8, -.5, box_z/2-2-.001])
                #cylinder(pipe_length, d=3, center=true);
                }
        // stay to keep boards in place
        translate([-15, 0, box_z/2 - stay_drop/2]) cube([2, box_y/3, stay_drop], center=true);
    }
}
module usb() {
    translate([0, -usb_l, -box_z/2])
        rotate([0,90,0])
        hull() {
        cylinder(thick+1, d=usb_h);
        translate([0,usb_w-usb_h,0]) cylinder(thick+1, d=usb_h);
    }
}

module mount() {
    translate([mount_w/2+mount_y-box_x/2, 0,-box_z/2+mount_h/2-.01]) {
        cube([mount_w, box_y/2, mount_h], center=true);
    }
}

module ufl_stay() {
    translate([mount_w/2+mount_y-box_x/2-3, box_y/2-4,-box_z/2-.001]) {
        cube([4, 4, .65], center=true);
    }
}

module sma() {
    translate([(box_x+diameter)/2 + (ant_x-diameter) - sma_d/2-1.5, box_y/2 - ant_y-1.5, -1])
        rotate([110,0,0])
        cylinder(thick+1, d=sma_d, center=true);
}

module sw() {
    translate([(box_x+diameter)/2 + switch_d/2 + switch_loc, box_y/2 - ant_y, -0.5])
        //translate([box_x/2+.001, -box_y/2+switch_d/2+switch_loc, -0.5])
        rotate([0,-90,0])
        {
            difference() {
                cylinder(switch_l+thick, d=switch_d+thick);
                translate([0,0,-.001]) cylinder(switch_l, d=switch_d);
                translate([0,0,switch_l-.002]) cylinder(thick+1, d=switch_hole);
            }
        }
}

module sw_hole() {
    translate([(box_x+diameter)/2 + switch_d/2 + switch_loc, box_y/2 - ant_y+1.5, +0.5])
    //translate([box_x/2-switch_loc-.001, -box_y/2+thick/2, -0.5])
        rotate([110,0,0])
        {
                cylinder(thick+2, d=switch_hole);
        }
}

module case() {
    difference() {
        bottom();
        translate([-box_x/2 - thick,box_y/2-usb_w/2+usb_x, usb_z]) usb();
        #sma();
        #sw_hole();
    }
    mount();
    ufl_stay();
    translate([box_x/3,-box_y/2-thick/2+.001,box_z/2-lid_d]) rotate ([90,180,0]) linear_extrude(.25) text ("Meshtastic", size=8);
    translate([-box_x/2-thick/2+0.001,-.8,0]) rotate ([90,0,-90]) linear_extrude(.3) text ("ANT", size=4.9);
    translate([-box_x/2-thick/2+0.001,.5,-box_z/2]) rotate ([90,0,-90]) linear_extrude(.3) text ("First!", size=4.9);
    //sw();
}

use <threads.scad>;

// A knob you can screw on to the SMA to lock the power switch in the off position.
width1=19;
width2=14;
height=7.5;
module switch_lock() {
    ScrewHole(6.6, height+diameter, position=[0,0,-height+diameter+.5], pitch=25.4/36) {
        minkowski() {
            cylinder(height-diameter, width1/2-diameter/2, width2/2-diameter/2, center=true);
            sphere(d=diameter);
        }
    }
}

// A switch lock you can pop a 50 ohm load in and out of.  Might be useful if threads don't work for you.
module term_switch_lock() {
    difference() {
        switch_lock();
        translate([0,0,-2]) cylinder($fn=6,height, d=9.5, center=true);
        translate([0,0,.5]) cylinder(height, d=7.85, center=true);
    }
}

/*
  Uncomment the parts you want to print below.
  The translations move things to avoid overlap allign bottoms.
 */
case();
translate([0,-box_y-thick-4,0]) top();
translate ([box_x/2+ant_x/2+thick,-box_y/2-thick, -box_z/2-thick/2+height/2]) switch_lock();
//translate ([-box_x/2-diameter*2-thick-2,-box_y/2-thick, -box_z/2-thick/2+height/2]) term_switch_lock();
