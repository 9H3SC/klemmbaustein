echo(version=version());

$fa = 1;
$fs = 0.4;
$fn = 100;

//bloc(noppen_cnt_x = 10,noppen_cnt_y = 1,noppen_on_top = false,brick_height = 1,text_top = "hello world",text_size=12);
translate([35,0,0]) bloc(text_flan = "Patrick",spolice = 5.2,text_flanup = 2,pc=true);



module bloc(noppen_cnt_x = 4,noppen_cnt_y = 2,noppen_on_top = 1,brick_height = 3, text_top = "",text_size=12,text_flan="",spolice=12,text_flanup=0,pc=false,noppen_diameter_mod=0.2) {
    // count of nubs in X //noppen_cnt_x = 10;
    // count of nubs in Y //noppen_cnt_y = 1;
    // boolean, if nubs should be rendered or not //noppen_on_top = false; // [true, false]
    // height of brick in lego-units (1=plate, 3=normal height //brick_height = 1; // [1,2,3,4,5,6]
    // text (if wanted) on top surface - leave empty for no text //text_top = "hello world";
    // text-size (12 suits best for noppen_cnt_y = 2) //text_size = 12;
    
    lego_unit = 1.6;
    
    grid_base = 8;
    grid_offset = 0.2;
    noppen_height = lego_unit; // 1.6
    noppen_diameter = 3 * lego_unit+noppen_diameter_mod; // 4.8
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
 
    color("red")
        difference() {
            translate([0,0,0]) cube([brick_x_crt,brick_y_crt,brick_height_crt]);
            union() {
                translate([brick_wall,brick_wall,0]) 
                    cube([brick_x_crt - (2*brick_wall), 
                        brick_y_crt - (2*brick_wall), 
                        brick_height_crt - brick_wall_top]);
                    if(pc) {translate([brick_x_crt*0.85,brick_y_crt,brick_height_crt/2]) rotate([90,0,45])cylinder(brick_height_crt*5,1,1,center=true);}       
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
            color("blue") for (x=[1:1:noppen_cnt_x - 1]) {
                for (y=[1:1:noppen_cnt_y - 1]) {
                    translate([x*grid_base - grid_offset/2,y*grid_base - grid_offset/2,0])
                        difference() {
                            union() {
                                translate([0,0,brick_height_crt-brick_wall*4]) cube([brick_wall_top,brick_y_crt,brick_height_crt],center=true);
                                cylinder(h=brick_height_crt-brick_wall,r=cylinder_diameter_outer/2);
                            }
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
    if (text_flan != "") {
        color("green")
            rotate([90,0,0]) translate([brick_x_crt/2,spolice/2+text_flanup,-0.5])
            linear_extrude(noppen_height)
            text(text_flan, size=spolice, halign="center", valign="center", language="fr");
    }
} 
