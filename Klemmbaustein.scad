echo(version=version());

// -------------------------------------------------------------------------------------------------------------------
/*
initial parameters
change these to create your brick
*/
nubs_cnt_x = 8; // count of nubs in X
nubs_cnt_y = 2; // count of nubs in Y
nubs_on_top = true; // boolean, if nubs should be rendered or not [true, false]
nubs_diameter_mod = 0; // increases the nub-diameter for 3D-Printing reasons (i.e. 0.2)

brick_height = 3; // height of brick in lego-units (1=plate, 3=normal height) [1,2,3,4,5,6]
text_on_brick = "Hello"; // text (if wanted) on top surface - if text on top set nubs_on_top = false (otherwise no text)!
text_size = 7; // text-size (12 suits best for top text and count of nubs in y = 2)
text_position = "frontback"; // where to extrude the text ["top", "front", "frontback"]
text_language = "de"; // which language for the text (use two letter code) [i.e. "de", "fr", etc.]
text_offset_y = 1.5; // text offset in text-up/down-direction
keyring_diameter = 0; // want a keyring-hole ? sets diameter of keyring (bigger than 0)

//Circle resolution
// $fa the minimum angle for a fragment. see https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#$fs
$fa = $preview ? 12 : 1; 
// $fs the minimum size of a fragment. see https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#$fs
$fs = $preview ? 2 : 0.4; 
// -------------------------------------------------------------------------------------------------------------------

/* 
calling module with parameters
*/
brick(nubs_cnt_x, nubs_cnt_y, nubs_on_top, brick_height, text_on_brick, text_size, text_position, text_language, text_offset_y, nubs_diameter_mod, keyring_diameter);

/*
module brick

- count of nubs in X // nubs_cnt_x = 10;
- count of nubs in Y // nubs_cnt_y = 1;
- boolean, if nubs should be rendered or not // nubs_on_top = false; // [true, false]
- height of brick in lego-units (1=plate, 3=normal height) // brick_height = 1; // [1,2,3,4,5,6]
- text (if wanted) on top surface - leave empty for no text // text_on_brick = "hello world";
- text-size (12 suits best top - 2 nubs in y) // text_size = 12;
- text-position (top or front) // text_position = "top" ["top", "front"]
- text_language (for accents etc.) // (use two letter code) // [i.e. "de", "fr", etc.]
- text offset in text-up/down-direction // text_offset_y = 0
- keyring-diameter // keyring_diameter = 1
*/
module brick(nubs_cnt_x = 4, nubs_cnt_y = 2, nubs_on_top = true, brick_height = 3, text_on_brick = "",text_size = 12, text_position = "", text_language = "de", text_offset_y = 0, nubs_diameter_mod = 0, keyring_diameter = 1) {
    
    lego_unit = 1.6;
    
    grid_base = 8;
    grid_offset = 0.2;
    nubs_height = lego_unit; // 1.6
    nubs_diameter = 3 * lego_unit+nubs_diameter_mod; // 4.8
    nubs_radius = nubs_diameter / 2;
    brick_wall = 1.2;
    brick_wall_top = 1;
    cylinder_diameter_outer = 6.51;
    cylinder_diameter_inner = 3 * lego_unit; // 4.8
    brick_baseheight = 6 * lego_unit; //9.6
    
    brick_height_crt = brick_baseheight / 3 * brick_height;
    brick_x_crt = (nubs_cnt_x * grid_base) - grid_offset;
    brick_y_crt = (nubs_cnt_y * grid_base) - grid_offset;
    nubs_offset_outer = (grid_base - grid_offset) / 2;    
 
    difference() { // for keyring-hole to get through whole brick
        color("red") {
            difference() {
                translate([0,0,0]) cube([brick_x_crt,brick_y_crt,brick_height_crt]);
                union() {
                    translate([brick_wall,brick_wall,0]) 
                        cube([brick_x_crt - (2*brick_wall), 
                            brick_y_crt - (2*brick_wall), 
                            brick_height_crt - brick_wall_top]);
                               
                }
            }
            
            if (nubs_on_top) {
                for (x=[0:1:nubs_cnt_x - 1]) {
                    for (y=[0:1:nubs_cnt_y - 1]) {
                        translate([nubs_offset_outer + (x*grid_base), 
                                    nubs_offset_outer + (y*grid_base), 
                                    brick_height_crt]) {
                                        cylinder(h=nubs_height,r=nubs_radius);
                                    }
                    }
                }
            }
            
            if (nubs_cnt_x > 1 && nubs_cnt_y == 1) {
                cylinder_diameter_outer = 2 * lego_unit;
                y = nubs_cnt_y / 2;
                for (x=[1:1:nubs_cnt_x - 1]) {
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
            else if (nubs_cnt_x == 1 && nubs_cnt_y > 1) {
                cylinder_diameter_outer = 2 * lego_unit;
                x = nubs_cnt_x / 2;
                for (y=[1:1:nubs_cnt_y - 1]) {
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
                for (x=[1:1:nubs_cnt_x - 1]) {
                    if (x%2 == 0) { 
                        translate([x*grid_base - brick_wall/2, 0, 0]) {
                            difference() {
                                cube([brick_wall_top, brick_y_crt, brick_height_crt]);
                                for (y=[1:1:nubs_cnt_y - 1]) {
                                    translate([brick_wall_top/2,y*grid_base - grid_offset/2,0]) {
                                        cylinder(h=brick_height_crt-brick_wall, r=cylinder_diameter_inner/2);
                                    }
                                }
                            }
                        }
                    }
                    for (y=[1:1:nubs_cnt_y - 1]) {
                        translate([x*grid_base - grid_offset/2,y*grid_base - grid_offset/2,0]) {
                            difference() {
                                cylinder(h=brick_height_crt-brick_wall, r=cylinder_diameter_outer/2);
                                cylinder(h=brick_height_crt-brick_wall, r=cylinder_diameter_inner/2);
                            }
                        }
                    }
                }
                
            }
        }
        if(keyring_diameter > 0) {
                translate([brick_x_crt*0.85,brick_y_crt,brick_height_crt/2]) {
                    rotate([90,0,45])cylinder(brick_height_crt*5,keyring_diameter,keyring_diameter,center=true);
                }
        }
    }
    if (text_position == "top" && !nubs_on_top) {
        color("green")
            translate([brick_x_crt/2,brick_y_crt/2+text_offset_y,brick_height_crt])
                linear_extrude(nubs_height)
                    text(text_on_brick, size=text_size, halign="center", valign="center", language=text_language);
    }
    if (text_position == "front" || text_position == "frontback") {
        color("green") {
            rotate([90,0,0]) {
                translate([brick_x_crt/2,text_size/2+text_offset_y,-0.5]) {
                    linear_extrude(nubs_height)
                    text(text_on_brick, size=text_size, halign="center", valign="center", language=text_language);
                }
            }
            if (text_position == "frontback") {
                rotate([90,0,180]) {
                    translate([(brick_x_crt/2)*-1, text_size/2+text_offset_y, brick_y_crt]) {
                        linear_extrude(nubs_height)
                        text(text_on_brick, size=text_size, halign="center", valign="center", language=text_language);
                    }
                }
            }
        }
    }
}