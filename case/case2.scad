$fn=80;

TOLERANCE = 0.5;

RPI_LENGTH = 85;
RPI_WIDTH = 56;
RPI_LEFT_PORTS_WIDTH = 2.5;
RPI_HEIGHT = 5;

RPI_HEIGHT_FULL = RPI_HEIGHT + 14;
RPI_LENGTH_FULL = RPI_LENGTH + TOLERANCE;
RPI_WIDTH_FULL = RPI_WIDTH + RPI_LEFT_PORTS_WIDTH + TOLERANCE;

//DISPLAY_HEIGHT = 5;
//DISPLAY_PIN_HEIGHT = 14;

//RPI_HEIGHT_WITH_DISPLAY = RPI_HEIGHT_FULL + DISPLAY_HEIGHT;

// TODO go over these

/*USB_PORT_WIDTH = 36; // TODO
USB_PORT_HEIGHT = 12.25;
USB_PORT_INDENT = 10;
USB_PORT_ARM_WIDTH = 6;
USB_PORT_SCREW_HOLE_DISTANCE = 15;
USB_PORT_SCREW_HOLE_RADIUS = 1.5 + 0.1;*/

USB_PORT_WIDTH = 42.5; 
USB_PORT_HEIGHT = 15;
USB_PORT_INDENT = 7.5;
USB_PORT_ARM_WIDTH = 6;
USB_PORT_SCREW_HOLE_DISTANCE = 15;
USB_PORT_SCREW_HOLE_RADIUS = 1.5;
USB_PORT_USB_WIDTH = 14;
USB_PORT_USB_HEIGHT = 9;

USB_PLUG_WITH_CABLE_LENGTH = 60;
USP_PLUG_WIDTH = 30; // approx.
USB_PLUG_HEIGHT = 5; // approx.


RPI_DISPLAY_BOARD_DISTANCE = 8;
DISPLAY_BOARD_HEIGHT = 1;
DISPLAY_BOARD_LENGTH = 66;

// values from https://www.raspberrypi.org/documentation/hardware/display/7InchDisplayDrawing-14092015.pdf
DISPLAY_BASE_LENGTH = 164.9;
DISPLAY_BASE_WIDTH = 100.6;
DISPLAY_BASE_THICKNESS = 2.5;
DISPLAY_BASE_OFF_BOARD_X = 48.45; 
DISPLAY_BASE_OFF_BOARD_Y = DISPLAY_BASE_WIDTH - RPI_WIDTH - 20.8; 

DISPLAY_LENGTH = 192.96;
DISPLAY_WIDTH = 110.76;
DISPLAY_THICKNESS = 1.4;

DISPLAY_ANCHOR_HEIGHT = 2;

DISPLAY_X_MISPLACEMENT_INNER = 5;
DISPLAY_X_MISPLACEMENT = -6.63 + DISPLAY_X_MISPLACEMENT_INNER;

SHELL_HEIGHT1 = 50;
SHELL_HEIGHT2 = 150 - SHELL_HEIGHT1;
SHELL_HEIGHT = SHELL_HEIGHT1 + SHELL_HEIGHT2;
SHELL_WIDTH = DISPLAY_BASE_WIDTH + 0.5 + DISPLAY_X_MISPLACEMENT_INNER;
SHELL_LENGTH = 135;
SHELL_THICKNESS = 4;

SHELL_ANGLE = -atan(SHELL_LENGTH/SHELL_HEIGHT2);
SHELL_TOP_LENGTH = sqrt(pow(SHELL_LENGTH, 2)+pow(SHELL_HEIGHT2,2));

/*RPI_POSITIONING = [(SHELL_WIDTH) / 2 - (RPI_WIDTH_FULL)/2,
                       0,
                       SHELL_TOP_LENGTH/6];
                       */
SHELL_TOP_TO_DISPLAY_BOTTOM = RPI_LENGTH * 1.2;
SHELL_BOTTOM_TO_DISPLAY = SHELL_TOP_LENGTH - SHELL_TOP_TO_DISPLAY_BOTTOM;
DISPLAY_POSITIONING = [(SHELL_WIDTH) / 2 - (RPI_WIDTH)/2,
                       0,
                       SHELL_TOP_LENGTH - SHELL_TOP_TO_DISPLAY_BOTTOM];

RUBBER_FOOT_DIAMETER = 17.5;
RUBBER_FOOT_HEIGHT = 9 - 0.5;


RUBBER_FEET_X1 = 0;
RUBBER_FEET_X2 = SHELL_WIDTH - RUBBER_FOOT_DIAMETER;
RUBBER_FEET_Y1 = 0;
RUBBER_FEET_Y2 = -SHELL_THICKNESS + SHELL_LENGTH/2;
RUBBER_FEET_Y3 = SHELL_LENGTH - RUBBER_FOOT_DIAMETER - SHELL_THICKNESS/2;

USB_PORT_X1 = SHELL_WIDTH/2-USB_PORT_WIDTH - SHELL_THICKNESS*0;
USB_PORT_X2 = SHELL_WIDTH/2 + SHELL_THICKNESS*0;
USB_PORT_Z = SHELL_HEIGHT1/2-USB_PORT_HEIGHT;

module prism(l, w, h){
    // from https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids
    polyhedron(
        points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

/*module rpi_with_display_small() {
    // small display
    import("raspberry_pi_Bplus.STL", convexity=10);
    
    translate([0, RPI_LEFT_PORTS_WIDTH, RPI_HEIGHT+DISPLAY_PIN_HEIGHT])
        cube([RPI_LENGTH, RPI_WIDTH, DISPLAY_HEIGHT]);
    
    // double usb plug
    translate([RPI_LENGTH-USB_PORT_LENGTH, RPI_WIDTH-USP_PLUG_WIDTH, 13])
        cube([USB_PLUG_WITH_CABLE_LENGTH, USP_PLUG_WIDTH, USB_PLUG_HEIGHT]);
}*/


module display_anchor() {
    translate([0, 0, DISPLAY_ANCHOR_HEIGHT*2])
    cube([10, 5, DISPLAY_ANCHOR_HEIGHT], center=true);
}

module rpi_with_display() {
    translate([27, 47, 0]) // XXX
    translate([RPI_WIDTH_FULL, RPI_LENGTH, -RPI_DISPLAY_BOARD_DISTANCE])
    rotate([0, 180, 90]) {
        color("gray")
        import("raspberry_pi_Bplus.STL", convexity=10);
        
        // double usb plug
        translate([RPI_LENGTH-USB_PORT_LENGTH, RPI_WIDTH-USP_PLUG_WIDTH, 13])
            cube([USB_PLUG_WITH_CABLE_LENGTH, USP_PLUG_WIDTH, USB_PLUG_HEIGHT]);
        
        translate([0, RPI_LEFT_PORTS_WIDTH, -RPI_DISPLAY_BOARD_DISTANCE])
        {
         display();
        }
    }
}


module display() {
    cube([DISPLAY_BOARD_LENGTH, RPI_WIDTH, DISPLAY_BOARD_HEIGHT]);
        translate([-DISPLAY_BASE_OFF_BOARD_X, -DISPLAY_BASE_OFF_BOARD_Y, -DISPLAY_BASE_THICKNESS - 2])
        {
            cube([DISPLAY_BASE_LENGTH, DISPLAY_BASE_WIDTH, DISPLAY_BASE_THICKNESS]);
            
            
            x1 = 20.0;
            x2 = 20.0 + 126.2;
            y1 = DISPLAY_BASE_WIDTH + 6.63 - 21.58;
            y2 = DISPLAY_BASE_WIDTH + 6.63 - 21.58 - 65.65;
            
            translate([x1, y1, -0.3])
                display_anchor();
            translate([x2, y1, -0.3])
                display_anchor();
            translate([x1, y2, -0.3])
                display_anchor();
            translate([x2, y2, -0.3])
                display_anchor();
            
            translate([-11.89, -(DISPLAY_WIDTH - DISPLAY_BASE_WIDTH - 6.63), - 0.3])
            cube([DISPLAY_LENGTH, DISPLAY_WIDTH, DISPLAY_THICKNESS]);
        }
}

module rpid() {
    color("gray")
    translate([0,0,RPI_LENGTH])
    rotate([90,90,0])
        rpi_with_display();
}


module rounded_rect(size, radius) {
    x = size[0];
    y = size[1];
    hull() {
        for (xp = [0, 1]) {
            for (yp = [0, 1]) {
                translate([(xp*x)+(xp-0.5)*-2*(radius/2),
                           (yp*y)+(yp-0.5)*-2*(radius/2), 0])
                    circle(r=radius);
            }
        }
    }
}


module rounded_cube(size, radius, thickness) {
    x = size[0];
    y = size[1];
    z = size[2];

    linear_extrude(height=z)
        difference() {
            rounded_rect(size, radius);
            if(thickness != -1) {
                translate([thickness/2, thickness/2, 0])
                rounded_rect([size[0]-thickness, size[1]-thickness], radius);
            }
        }
}

module rpi_support_prism() {
    w = RPI_WIDTH/4;
    h = tan(90+SHELL_ANGLE)*RPI_LENGTH-RPI_HEIGHT;
    l = sqrt(pow(RPI_LENGTH, 2) - pow(h, 2));
    prism(w,
        l,
        h);
    
    translate([0, 0, -SHELL_HEIGHT1])
        cube([w, l/5, SHELL_HEIGHT1]);
    
    translate([0, l - l/5, -SHELL_HEIGHT1])
        cube([w, l/5, SHELL_HEIGHT1]);
}

module rpi_support() {
    rpi_support_prism();
    translate([RPI_WIDTH - RPI_WIDTH/4, 0, 0])
        rpi_support_prism();
}

ANCHOR_SUPPORT_SIZE = 8;
ANCHOR_SUPPORT_DEPTH = 5.5;
ANCHOR_SUPPORT_SPOT_DEPTH = 5.5;
ANCHOR_SUPPORT_OFF_TOP = DISPLAY_ANCHOR_HEIGHT+4.5;

ANCHOR_SCREW_RADIUS = 1.5 + 0.1;

module shell_anchor_support() {
    translate([0, 0, -ANCHOR_SUPPORT_OFF_TOP - ANCHOR_SUPPORT_DEPTH])
    cube([SHELL_WIDTH + SHELL_THICKNESS, ANCHOR_SUPPORT_SIZE, ANCHOR_SUPPORT_DEPTH]);
}
module shell_anchor_extension() {
    translate([-ANCHOR_SUPPORT_SIZE/2, -ANCHOR_SUPPORT_SIZE/2, -ANCHOR_SUPPORT_OFF_TOP-ANCHOR_SUPPORT_SPOT_DEPTH])
    cube([ANCHOR_SUPPORT_SIZE, ANCHOR_SUPPORT_SIZE, ANCHOR_SUPPORT_SPOT_DEPTH]);
}

module shell_anchor_hole() {
    translate([0, 0, -ANCHOR_SUPPORT_OFF_TOP-ANCHOR_SUPPORT_SPOT_DEPTH])
    cylinder(h=ANCHOR_SUPPORT_SPOT_DEPTH, r=ANCHOR_SCREW_RADIUS);
}

// XXX TODO calculate this properly
ANCHOR_SUPPORT_PRISM_WIDTH = ANCHOR_SUPPORT_SIZE * 1.22;

module shell_anchor_prism(length, mirror=false) {
    height = 30;
    translate([0, mirror ? ANCHOR_SUPPORT_PRISM_WIDTH : 0, -height])
    rotate([90, 0, mirror ? 270 : 90])
        prism(ANCHOR_SUPPORT_PRISM_WIDTH, height, length-1);
}

USB_PORT_INDENT_PILLAR_HEIGHT = USB_PORT_Z + USB_PORT_HEIGHT*1;

module usb_port_indent_pillar(right=0) {
    translate([0, -SHELL_THICKNESS, -USB_PORT_Z])
        cube([USB_PORT_ARM_WIDTH, USB_PORT_INDENT + SHELL_THICKNESS*2, USB_PORT_INDENT_PILLAR_HEIGHT]);
    
    translate([-SHELL_THICKNESS/2 + right*SHELL_THICKNESS*2, -SHELL_THICKNESS, -USB_PORT_Z])
        cube([SHELL_THICKNESS/2, USB_PORT_INDENT + SHELL_THICKNESS*2, USB_PORT_INDENT_PILLAR_HEIGHT]);
}

module usb_port_indent(right=0) {
    if(right==0)
        usb_port_indent_pillar(right=0);
    
    if(right==1)
        translate([USB_PORT_WIDTH-USB_PORT_ARM_WIDTH, 0])
            usb_port_indent_pillar(right=1);
}

module usb_port_screw_hole() {
    rotate([90, 0, 0])
        cylinder(h=ANCHOR_SUPPORT_SPOT_DEPTH, r=USB_PORT_SCREW_HOLE_RADIUS);
}

module usb_port_hole() {
    // hole for front
    translate([USB_PORT_WIDTH / 2 - USB_PORT_USB_WIDTH / 2,
                -SHELL_THICKNESS,
                USB_PORT_HEIGHT / 2 - USB_PORT_USB_HEIGHT / 2])
            cube([USB_PORT_USB_WIDTH, USB_PORT_INDENT + SHELL_THICKNESS, USB_PORT_USB_HEIGHT]);
    
    translate([0,
                -SHELL_THICKNESS*0.75,
                0])
            cube([USB_PORT_WIDTH, USB_PORT_INDENT*3 + SHELL_THICKNESS, USB_PORT_HEIGHT]);
      
    translate([USB_PORT_WIDTH/2 - USB_PORT_SCREW_HOLE_DISTANCE, 0, USB_PORT_HEIGHT/2])
        usb_port_screw_hole();
    
    translate([USB_PORT_WIDTH/2 + USB_PORT_SCREW_HOLE_DISTANCE, 0, USB_PORT_HEIGHT/2])
        usb_port_screw_hole();
    /*
    translate([0, USB_PORT_INDENT]) {
        // hole for usb port
        translate([(SHELL_WIDTH) / 2 - USB_PORT_HOLE_DISTANCE_MIDDLE,
                -SHELL_THICKNESS,
                SHELL_HEIGHT1/2-USB_PORT_HOLE[2]])
            cube(USB_PORT_HOLE);
        
        // holes for screws for usb port
        // TODO check the length on these
        
        translate([(SHELL_WIDTH) / 2 - USB_PORT_HOLE_DISTANCE_MIDDLE - USB_PORT_SCREW_HOLE_DISTANCE,
                -SHELL_THICKNESS,
                SHELL_HEIGHT1/2-(USB_PORT_HOLE[2]/2)])
        rotate([90, 0, 0])
            cylinder(h=ANCHOR_SUPPORT_SPOT_DEPTH, r=USB_PORT_SCREW_HOLE_RADIUS);
        
        translate([(SHELL_WIDTH) / 2 + USB_PORT_HOLE_DISTANCE_MIDDLE + USB_PORT_SCREW_HOLE_DISTANCE,
                -SHELL_THICKNESS,
                SHELL_HEIGHT1/2-(USB_PORT_HOLE[2]/2)])
        rotate([90, 0, 0])
            cylinder(h=ANCHOR_SUPPORT_SPOT_DEPTH, r=USB_PORT_SCREW_HOLE_RADIUS);
    }
    */
}

module rubber_feet_indent() {
    translate([-SHELL_THICKNESS/2, -SHELL_THICKNESS/2, 0]) {
        cube([RUBBER_FOOT_DIAMETER+SHELL_THICKNESS, RUBBER_FOOT_DIAMETER+SHELL_THICKNESS, RUBBER_FOOT_HEIGHT+SHELL_THICKNESS]);
        // screw
        translate([SHELL_THICKNESS/2 + RUBBER_FOOT_DIAMETER/2, SHELL_THICKNESS/2 + RUBBER_FOOT_DIAMETER/2, RUBBER_FOOT_HEIGHT])
            cylinder(h=10+TOLERANCE, r=USB_PORT_SCREW_HOLE_RADIUS+SHELL_THICKNESS/5);
    }
}

module rubber_feet_indent_hole() {
    translate([-TOLERANCE, -TOLERANCE, -TOLERANCE]) {
        cube([RUBBER_FOOT_DIAMETER + TOLERANCE*2, RUBBER_FOOT_DIAMETER + TOLERANCE*2, RUBBER_FOOT_HEIGHT]);
        // screw
        translate([(RUBBER_FOOT_DIAMETER+TOLERANCE*2)/2, (RUBBER_FOOT_DIAMETER+TOLERANCE*2)/2, RUBBER_FOOT_HEIGHT])
            cylinder(h=10, r=USB_PORT_SCREW_HOLE_RADIUS);
    }
}


module shell() {
    //rounded_cube([SHELL_WIDTH, SHELL_LENGTH, SHELL_HEIGHT1], SHELL_THICKNESS, SHELL_THICKNESS);
    difference() {
        union() {
            difference() {
                minkowski() {
                    prism(SHELL_WIDTH, SHELL_LENGTH, SHELL_HEIGHT2);
                    cylinder(r=SHELL_THICKNESS,h=SHELL_HEIGHT1+SHELL_THICKNESS);
                }
                translate([0, 0, 0])
                minkowski() {
                    prism(SHELL_WIDTH, SHELL_LENGTH, SHELL_HEIGHT2);
                    cylinder(r=1,h=SHELL_HEIGHT1+SHELL_THICKNESS);
                }
            }
            
            // floor
            translate([SHELL_WIDTH/2 - SHELL_WIDTH/8, -SHELL_THICKNESS, 0])
                cube([SHELL_WIDTH/4, SHELL_LENGTH + SHELL_THICKNESS*2, SHELL_THICKNESS]);
            translate([-SHELL_THICKNESS, -SHELL_THICKNESS + SHELL_LENGTH/2, 0])
                cube([SHELL_WIDTH + SHELL_THICKNESS*2, SHELL_LENGTH/8, SHELL_THICKNESS]);
            
            // prism to back wall
            
            translate([-SHELL_THICKNESS*0.5, SHELL_LENGTH-SHELL_THICKNESS*2+1, 0])
                prism(SHELL_WIDTH+SHELL_THICKNESS, SHELL_THICKNESS*2, SHELL_THICKNESS*2);
            
            // prism to sides
            translate([SHELL_THICKNESS*1.5, -SHELL_THICKNESS/2, 0])
            rotate([0, 0, 90])
                prism(SHELL_LENGTH+SHELL_THICKNESS, SHELL_THICKNESS*2, SHELL_THICKNESS*2);
            
            translate([SHELL_WIDTH - SHELL_THICKNESS*1.5, SHELL_LENGTH+SHELL_THICKNESS/2, 0])
            rotate([0, 0, 270])
                prism(SHELL_LENGTH+SHELL_THICKNESS, SHELL_THICKNESS*2, SHELL_THICKNESS*2);
            
            
            
            translate([RUBBER_FEET_X1, RUBBER_FEET_Y1, 0])
                rubber_feet_indent();
            translate([RUBBER_FEET_X2, RUBBER_FEET_Y1, 0])
                rubber_feet_indent();
            translate([RUBBER_FEET_X1, RUBBER_FEET_Y3, 0])
                rubber_feet_indent();
            translate([RUBBER_FEET_X2, RUBBER_FEET_Y3, 0])
                rubber_feet_indent();
            
            
            translate([USB_PORT_X1, 0, USB_PORT_Z])
                usb_port_indent();
            
            translate([USB_PORT_X2, 0, USB_PORT_Z])
                usb_port_indent(right=1);
            
            // join the two middle pillars to save on filament
            // XXX hope this isn't in the way of any cables
            USB_PORT_MIDDLE_PILLAR_WIDTH = SHELL_THICKNESS*2;
            //translate([SHELL_WIDTH/2-USB_PORT_MIDDLE_PILLAR_WIDTH/2, -SHELL_THICKNESS, 0])
            //    cube([USB_PORT_MIDDLE_PILLAR_WIDTH, USB_PORT_INDENT+SHELL_THICKNESS*2, USB_PORT_INDENT_PILLAR_HEIGHT]);
                
        }
        // holes
        union() {
            // hole for display
            translate([0, 0, SHELL_HEIGHT1+SHELL_THICKNESS*2])
            rotate([SHELL_ANGLE, 0, 0])
            translate([-TOLERANCE, 0, -TOLERANCE])
                cube([SHELL_WIDTH,
                    SHELL_THICKNESS,
                    SHELL_TOP_LENGTH]);
            
            translate([USB_PORT_X1, 0, USB_PORT_Z])
                usb_port_hole();
            translate([USB_PORT_X2, 0, USB_PORT_Z])
                usb_port_hole();
            
            // we'll do without the back wall
            
            translate([0, SHELL_LENGTH, SHELL_THICKNESS*12])
            cube([SHELL_WIDTH, SHELL_THICKNESS, SHELL_HEIGHT+SHELL_THICKNESS]);
            
            // hole for the power cable!
            translate([SHELL_WIDTH*0.9, SHELL_LENGTH+SHELL_THICKNESS, SHELL_THICKNESS*6])
            rotate([90, 0, 0])
                cylinder(h=SHELL_THICKNESS*2, r=6);
            
            // rubber feet indent holes
            
            
            
            translate([RUBBER_FEET_X1, RUBBER_FEET_Y1, 0])
                rubber_feet_indent_hole();
            translate([RUBBER_FEET_X2, RUBBER_FEET_Y1, 0])
                rubber_feet_indent_hole();
            translate([RUBBER_FEET_X1, RUBBER_FEET_Y3, 0])
                rubber_feet_indent_hole();
            translate([RUBBER_FEET_X2, RUBBER_FEET_Y3, 0])
                rubber_feet_indent_hole();
        }
    }
    /*
    translate([-SHELL_THICKNESS/4, SHELL_LENGTH-SHELL_THICKNESS/2, SHELL_HEIGHT-SHELL_THICKNESS+SHELL_THICKNESS])
        cube([SHELL_WIDTH+SHELL_THICKNESS/2, SHELL_THICKNESS, SHELL_THICKNESS]);
    */
    
    // front display hold
    translate([0, -SHELL_THICKNESS*0.5, SHELL_HEIGHT1])
    minkowski() {
        cube([SHELL_WIDTH, 0.01, SHELL_HEIGHT1*0.175]);
        cylinder(r=SHELL_THICKNESS*0.5,h=0.001);
    }
    
    
    // anchor supports
    DISPLAY_ANCHOR_X1 = SHELL_THICKNESS + DISPLAY_LENGTH - (12.54 + 20.0 + 126.2);
    DISPLAY_ANCHOR_X2 = DISPLAY_ANCHOR_X1 + 126.2;
    DISPLAY_ANCHOR_Y1 = DISPLAY_X_MISPLACEMENT + 21.58;
    DISPLAY_ANCHOR_Y2 = DISPLAY_X_MISPLACEMENT + 21.58 + 65.65;
    //y1 = DISPLAY_BASE_WIDTH + 6.63 - 21.58;
    //y2 = DISPLAY_BASE_WIDTH + 6.63 - 21.58 - 65.65;
    translate([0, 0, SHELL_HEIGHT1+SHELL_THICKNESS])
    rotate([90+SHELL_ANGLE, 0, 0])
    {
        translate([0, 0, DISPLAY_THICKNESS])
        difference() {
            union() {
                translate([-SHELL_THICKNESS/2, DISPLAY_ANCHOR_X1 - ANCHOR_SUPPORT_SIZE/2, 0])
                    shell_anchor_support();
                translate([-SHELL_THICKNESS/2, DISPLAY_ANCHOR_X2 - ANCHOR_SUPPORT_SIZE/2, 0])
                    shell_anchor_support();
                translate([DISPLAY_ANCHOR_Y1, DISPLAY_ANCHOR_X1, 0])
                    shell_anchor_extension();
                translate([DISPLAY_ANCHOR_Y1, DISPLAY_ANCHOR_X2, 0])
                    shell_anchor_extension();
                translate([DISPLAY_ANCHOR_Y2, DISPLAY_ANCHOR_X1, 0])
                    shell_anchor_extension();
                translate([DISPLAY_ANCHOR_Y2, DISPLAY_ANCHOR_X2, 0])
                    shell_anchor_extension();
            }
            translate([DISPLAY_ANCHOR_Y1, DISPLAY_ANCHOR_X1, 0])
                shell_anchor_hole();
            translate([DISPLAY_ANCHOR_Y1, DISPLAY_ANCHOR_X2, 0])
                shell_anchor_hole();
            translate([DISPLAY_ANCHOR_Y2, DISPLAY_ANCHOR_X1, 0])
                shell_anchor_hole();
            translate([DISPLAY_ANCHOR_Y2, DISPLAY_ANCHOR_X2, 0])
                shell_anchor_hole();
            
        }
    }
    
    // prism supports for anchor arms
    // +0.001 is a workaround for https://github.com/openscad/openscad/issues/1458
    SHELL_ANCHOR_PRISM_X1 = -SHELL_THICKNESS/2+0.001;
    SHELL_ANCHOR_PRISM_X2 = SHELL_WIDTH+SHELL_THICKNESS/2;
    SHELL_ANCHOR_PRISM_Z1 = SHELL_HEIGHT1 + DISPLAY_ANCHOR_X1*cos(SHELL_ANGLE) - ANCHOR_SUPPORT_OFF_TOP - TOLERANCE + ANCHOR_SUPPORT_SIZE*cos(SHELL_ANGLE);
    SHELL_ANCHOR_PRISM_Z2 = SHELL_HEIGHT1 + DISPLAY_ANCHOR_X2*cos(SHELL_ANGLE) - ANCHOR_SUPPORT_OFF_TOP - TOLERANCE + ANCHOR_SUPPORT_SIZE*cos(SHELL_ANGLE);
    translate([SHELL_ANCHOR_PRISM_X1, DISPLAY_ANCHOR_X1*-sin(SHELL_ANGLE),
         SHELL_ANCHOR_PRISM_Z1])
        shell_anchor_prism(DISPLAY_ANCHOR_Y1 - ANCHOR_SCREW_RADIUS + SHELL_THICKNESS/2);
    translate([SHELL_ANCHOR_PRISM_X1, DISPLAY_ANCHOR_X2*-sin(SHELL_ANGLE),
        SHELL_ANCHOR_PRISM_Z2])
        shell_anchor_prism(DISPLAY_ANCHOR_Y1 - ANCHOR_SCREW_RADIUS + SHELL_THICKNESS/2);
    
    // -0.17 is to prevent support
    translate([SHELL_ANCHOR_PRISM_X2, DISPLAY_ANCHOR_X1*-sin(SHELL_ANGLE)-0.17,
         SHELL_ANCHOR_PRISM_Z1])
        shell_anchor_prism((SHELL_WIDTH-DISPLAY_ANCHOR_Y2) - ANCHOR_SCREW_RADIUS + SHELL_THICKNESS/2, mirror=true);
    translate([SHELL_ANCHOR_PRISM_X2, DISPLAY_ANCHOR_X2*-sin(SHELL_ANGLE)-0.17,
        SHELL_ANCHOR_PRISM_Z2])
        shell_anchor_prism((SHELL_WIDTH-DISPLAY_ANCHOR_Y2) - ANCHOR_SCREW_RADIUS + SHELL_THICKNESS/2, mirror=true);
    
    /*translate([-120, 0, 0])
    for (i = [0 : 50])
        translate([18*(i % 6), 0, 10 * floor(i / 6)])
        cube([17.5, 17.5, 9]);
    */
    //21.58 - 6.63 + SHELL_THICKNESS + ANCHOR_SUPPORT_SIZE
}


//translate(DISPLAY_POSITIONING)
//translate([-RPI_LEFT_PORTS_WIDTH, 0, RPI_LENGTH])
//

//translate([0, -SHELL_BOTTOM_TO_DISPLAY*sin(SHELL_ANGLE), SHELL_BOTTOM_TO_DISPLAY*cos(SHELL_ANGLE)])
//translate([0, 0, SHELL_HEIGHT1+SHELL_THICKNESS])
//rotate([SHELL_ANGLE, 0, 0])
//translate([0, 0, RPI_LENGTH])
//rotate([90, 90, 0])

translate([DISPLAY_X_MISPLACEMENT, 0, 0])
translate([0, 0, SHELL_HEIGHT1+SHELL_THICKNESS])
rotate([90+SHELL_ANGLE, 0, 0])
translate([0, SHELL_THICKNESS, 0])
//%rpi_with_display();


translate([200, 0, 0])// -RPI_HEIGHT_WITH_DISPLAY])
%rpi_with_display();


FRONT_TO_RPI = 50;
GROUND_TO_RPI =
    SHELL_HEIGHT
    - (SHELL_TOP_TO_DISPLAY_BOTTOM / SHELL_TOP_LENGTH) * SHELL_HEIGHT2
    - (SHELL_LENGTH/SHELL_TOP_LENGTH)*RPI_HEIGHT_WITH_DISPLAY;

/*
translate([(SHELL_WIDTH) / 2 - (RPI_WIDTH)/2,
    FRONT_TO_RPI,
    GROUND_TO_RPI])
rpi_support();*/

//shell();

difference() {
    shell();
    union() {
        // XXX make it printable in lulzbot mini
        translate([-10, SHELL_LENGTH + SHELL_THICKNESS, 0])
        cube([300, 100, 800]);
        
        /*
        translate([-10, 20, -10])
        cube([200, 200, 200]);
        translate([-10, -10, 30])
        cube([200, 200, 200]);
        translate([55, -10, 0])
        cube([200, 200, 200]);
        translate([-5, -5, 0])
        cube([11, 200, 200]);*/
        
        /*
        translate([-10, -10, 0])
        cube([200, 200, 48]);
        translate([-10, 40, 0])
        cube([200, 200, 70]);
        translate([-10, 60, 0])
        cube([200, 200, 85]);
        translate([-10, 80, 0])
        cube([200, 200, 400]);
        */
        /*
        translate([-10, -10, -10])
        cube([200, 200, 60]);
        rotate([90+SHELL_ANGLE, 0, 0])
        translate([-10, 0, -62])
        cube([200, 200, 100]);
        */
    }
}
