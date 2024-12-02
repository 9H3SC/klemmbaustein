echo(version=version());

// count of nubs in X
noppen_cnt_x = 10;

// count of nubs in Y
noppen_cnt_y = 1;

// boolean, if nubs should be rendered or not
noppen_on_top = false; // [true, false]

// height of brick in lego-units (1=plate, 3=normal height
brick_height = 1; // [1,2,3,4,5,6]

// text (if wanted) on top surface - leave empty for no text
text_top = "hello world";

// text-size (12 suits best for noppen_cnt_y = 2)
text_size = 12;

// module for hiding variables in Customizer
module __Customizer_Limit__ () {}
lego_unit = 1.6;

grid_base = 8;
grid_offset = 0.2;
noppen_height = lego_unit; // 1.6
noppen_diameter = 3 * lego_unit; // 4.8
noppen_radius = noppen_diameter / 2;
brick_wall = 1.2;
brick_wall_top = 1;
cylinder_diameter_outer = 6.51;
cylinder_diameter_inner = 3 * lego_unit; // 4.8
brick_baseheight = 6 * lego_unit; //9.6

brick_height_crt = brick_baseheight / 3 * brick_height;
brick_x_crt = (noppen_cnt_x * grid_base) - grid_offset;
brick_y_crt = (noppen_cnt_y * grid_base) - grid_offset;
noppen_offset_outer = (grid_base - grid_offset) / 2;

$fa = 1;
$fs = 0.4;

color("red")
    difference() {
        translate([0,0,0]) {
            cube([brick_x_crt,brick_y_crt,brick_height_crt]);
        }
        translate([brick_wall,brick_wall,0]) {
            cube([brick_x_crt - (2*brick_wall), 
                    brick_y_crt - (2*brick_wall), 
                    brick_height_crt - brick_wall_top]);
        }
    }
    
    if (noppen_on_top) {
        for (x=[0:1:noppen_cnt_x - 1]) {
            for (y=[0:1:noppen_cnt_y - 1]) {
                translate([noppen_offset_outer + (x*grid_base), 
                            noppen_offset_outer + (y*grid_base), 
                            brick_height_crt]) {
                                cylinder(h=noppen_height,r=noppen_radius);
                            }
            }
        }
    }
    
    if (noppen_cnt_x > 1 && noppen_cnt_y == 1) {
        cylinder_diameter_outer = 2 * lego_unit;
        y = noppen_cnt_y / 2;
        for (x=[1:1:noppen_cnt_x - 1]) {
            translate([x*grid_base - grid_offset/2,y*grid_base - grid_offset/2,0]) {
                cylinder(h=brick_height_crt-brick_wall, r=cylinder_diameter_outer/2);
            }
            if (x%2 == 0) { 
                translate([(x*grid_base - grid_offset/2) - brick_wall_top / 2,0,0]) {
                    cube([brick_wall_top,brick_y_crt,brick_height_crt]);
                }
            }
        }
    }
    else if (noppen_cnt_x == 1 && noppen_cnt_y > 1) {
        cylinder_diameter_outer = 2 * lego_unit;
        x = noppen_cnt_x / 2;
        for (y=[1:1:noppen_cnt_y - 1]) {
            translate([x*grid_base - grid_offset/2,y*grid_base - grid_offset/2,0]) {
                cylinder(h=brick_height_crt-brick_wall, r=cylinder_diameter_outer/2);
            }
            if (y%2 == 0) { 
                translate([0,(y*grid_base - grid_offset/2) - brick_wall_top / 2,0]) {
                    cube([brick_x_crt,brick_wall_top,brick_height_crt]);
                }
            }
        }
    }
    else {
        for (x=[1:1:noppen_cnt_x - 1]) {
            for (y=[1:1:noppen_cnt_y - 1]) {
                translate([x*grid_base - grid_offset/2,y*grid_base - grid_offset/2,0])
                    difference() {
                        cylinder(h=brick_height_crt-brick_wall,
                                    r=cylinder_diameter_outer/2);
                        cylinder(h=brick_height_crt-brick_wall,
                                    r=cylinder_diameter_inner/2);
                    }
            }
        }
    }
if (text_top != "" && !noppen_on_top) {
    color("green")
        translate([brick_x_crt/2,brick_y_crt/2,brick_height_crt])
            linear_extrude(noppen_height)
                text(text_top, size=text_size, halign="center", valign="center", language="de");
}
    