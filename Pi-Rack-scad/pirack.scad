// =========================================================
// Modular 4-Post Open-Frame Rack: 7x Pi Sleds + PoE Switch
// (Symmetrical 2 cm Pitch Rack Rails + Outer Side Handles)
// =========================================================

// --- EXPORT SELECTION ---
// "all"          -> Preview complete assembled 4-post rack
// "rack_post"    -> Print 4x (Symmetrical top/bottom 2 cm pitch rails — stackable on either end)
// "handle_bar"   -> Print 2x (Outer side handle bars connecting front & rear posts on left & right)
// "bottom_shelf" -> Print 1x (Base + 1cm vents + rear switch stop)
// "mid_shelf"    -> Print 1x (Divider shelf + 1cm vents + bottom sled tracks + rear stop)
// "top_shelf"    -> Print 1x (Flat support-free top roof + upper sled tracks + vertical M3 holes)
// "top_raiser"   -> Print 1x (Separate rear raiser lip with 3.9mm x 5mm vertical screw holes)
// "sled"         -> Print 7x (Detachable Pi mounting sleds)
part_to_render = "all"; 

// --- CUSTOMIZABLE PARAMETERS (in mm) ---
num_pis = 7;
pi_slot_pitch = 23;        // Center-to-center spacing (increase to 25-26 for wider switches/HATs)

switch_depth = 105;        // Front-to-back depth of the shelves
wall_thick = 5;            // 5mm thickness for sturdy M3 edge screws
raiser_height = 10;        // 10 mm height of the separate top rear raiser lip

// --- RACK RAIL POST SPECS & SYMMETRICAL 2 CM GRID ---
post_depth = 30;           // Front-to-back width of each individual corner rail post
rail_hole_pitch = 20;      // 2 cm (20 mm) vertical center-to-center spacing between shelf mounting holes
rail_end_margin = rail_hole_pitch / 2; // 10 mm at BOTH ends so stacking posts keeps a 20 mm seam pitch

num_post_holes = 8;        // 8 holes * 20mm = 160.0mm total post length (Z = 10, 30, 50, 70, 90, 110, 130, 150)
bot_shelf_hole_idx = 0;    // Bottom shelf mounts at hole #0 (Z = 10.0mm -> 7.5mm bottom leg clearance)
switch_grid_steps = 2;     // Bottom-to-middle shelf spacing in 20mm steps (40mm pitch -> 35mm switch bay)
pi_grid_steps = 4;         // Middle-to-top shelf spacing in 20mm steps (80mm pitch -> 75mm Pi bay)
handle_hole_idx = 7;       // Top hole (#7 at Z = 150.0mm) connects the front & rear posts on the outside

// --- OUTER SIDE HANDLE SPECS ---
handle_bar_h = 20;         // Vertical height of the outer crossbar handle (Z = 140..160mm)

// --- VENTILATION HOLE SPECS (Bottom, Middle & Top Shelves) ---
vent_hole_dia = 10;        // 1 cm (10 mm) diameter holes
vent_edge_gap = 5;         // 5 mm solid gap between adjacent holes
vent_pitch_y = vent_hole_dia + vent_edge_gap; // 15 mm center-to-center spacing
vent_start_y = 12;         // Front margin before first hole center
vent_end_y = switch_depth - wall_thick - 10; // Stops safely clear of rear stop-bar

// --- FASTENER SPECS (M3 Screws - Side Rails, Handle & Top Raiser) ---
m3_through_dia = 3.4;      // Clearance hole through posts, outer handles & top shelf
shelf_hole_dia = 3.9;      // Hole diameter in shelf edges & top raiser (for M3 heat-set inserts)
screw_depth = 5;           // Depth of holes into shelf edges & top raiser (in mm)
screw_y_offsets = [18, switch_depth - 18]; // 2 screws per side (front = 18mm, rear = 87mm)

// --- SLED & RAIL TOLERANCE PARAMETERS ---
sled_thick = 3;            // Thickness of each removable Pi tray
rail_height = 3.5;         // Height of the guide rails
tolerance = 0.35;          // Sliding clearance (bump to 0.45 if tight)

// --- RASPBERRY PI MOUNTING HOLE SPECS ---
hole_offset_y = 14;        // Distance from front of sled to first mounting hole
hole_spacing_y = 58;       // Standard Pi 3/4/5 front-to-back hole spacing
hole_offset_z = 9.5;       // Distance from bottom of sled to bottom hole
hole_spacing_z = 49;       // Standard Pi 3/4/5 bottom-to-top hole spacing
m25_hole_dia = 2.7;        // M2.5 screw clearance/tapping diameter

// --- CALCULATED DIMENSIONS ---
side_margin = 2.0;                                  // 2mm margin at left & right posts
track_total_w = 4.0 + sled_thick + (tolerance * 2); // 7.7mm total width of one U-channel track

// Full 7 pitches + left & right margins (7 * 23 + 4 = 165.0mm inner width)
exact_inner_width = (num_pis * pi_slot_pitch) + (side_margin * 2);
total_width = exact_inner_width + (wall_thick * 2); // 175.0mm total outer width

// 3 evenly spaced vertical screw X positions for the top rear raiser (clear of side screws & tracks)
raiser_screw_x_offsets = [25, exact_inner_width / 2, exact_inner_width - 25];
raiser_screw_y = switch_depth - (wall_thick / 2);

// Symmetrical post height & hole bounds (10mm bottom margin + 7*20mm + 10mm top margin = 160.0mm)
post_height  = num_post_holes * rail_hole_pitch;                             // 160.0mm total post length
rail_first_z = rail_end_margin;                                              // 10.0mm first hole center
rail_last_z  = post_height - rail_end_margin;                                // 150.0mm last hole center

// Grid-aligned vertical shelf & handle Z positions
bot_shelf_center_z = rail_first_z + (bot_shelf_hole_idx * rail_hole_pitch);  // 10.0mm
mid_shelf_center_z = bot_shelf_center_z + (switch_grid_steps * rail_hole_pitch); // 50.0mm
top_shelf_center_z = mid_shelf_center_z + (pi_grid_steps * rail_hole_pitch); // 130.0mm
handle_center_z    = rail_first_z + (handle_hole_idx * rail_hole_pitch);     // 150.0mm

bot_shelf_z = bot_shelf_center_z - (wall_thick / 2);                         // 7.5mm
mid_shelf_z = mid_shelf_center_z - (wall_thick / 2);                         // 47.5mm
top_shelf_z = top_shelf_center_z - (wall_thick / 2);                         // 127.5mm

// Resulting bay heights & taller sled height
switch_height     = mid_shelf_z - (bot_shelf_z + wall_thick);                // 35.0mm clear switch bay
pi_section_height = top_shelf_z - (mid_shelf_z + wall_thick);                // 75.0mm clear Pi bay
sled_height       = pi_section_height - (tolerance * 2);                     // 74.3mm sled height

$fn = 30; // Smooth circles

// --- MODULES ---

// 1. Guide Track Module
module guide_track(length) {
    slot_w = sled_thick + (tolerance * 2);
    rail_wall = 2.0;
    
    cube([rail_wall, length, rail_height]);
    translate([rail_wall + slot_w, 0, 0])
        cube([rail_wall, length, rail_height]);
}

// 2. Helper: Solid Shelf Base Plate with Edge Holes on Left & Right Edges
module shelf_blank() {
    difference() {
        cube([exact_inner_width, switch_depth, wall_thick]);
        
        // Edge holes on Left (x=0) and Right (x=exact_inner_width) edges
        for (y_pos = screw_y_offsets) {
            // Left edge hole
            translate([-0.5, y_pos, wall_thick / 2])
                rotate([0, 90, 0])
                cylinder(d = shelf_hole_dia, h = screw_depth + 0.5);
                
            // Right edge hole
            translate([exact_inner_width - screw_depth, y_pos, wall_thick / 2])
                rotate([0, 90, 0])
                cylinder(d = shelf_hole_dia, h = screw_depth + 0.5);
        }
    }
}

// 3. Helper: Ventilated Shelf Blank (Used by Bottom, Middle, and Top shelves)
module ventilated_shelf_blank() {
    open_bay_w = pi_slot_pitch - track_total_w; // 15.3mm open space in every single bay
    first_vent_x = side_margin + track_total_w + (open_bay_w / 2);

    difference() {
        shelf_blank();
        
        // All 7 columns of 1 cm (10 mm) holes centered in each equal 15.3mm bay
        for (col = [0 : num_pis - 1], vy = [vent_start_y : vent_pitch_y : vent_end_y]) {
            translate([first_vent_x + (col * pi_slot_pitch), vy, -1])
                cylinder(d = vent_hole_dia, h = wall_thick + 2);
        }
    }
}

// 4. Bottom Shelf (1 cm Vents + rear switch stop-lip)
module bottom_shelf() {
    union() {
        ventilated_shelf_blank();
        // Rear switch stop-lip
        translate([0, switch_depth - wall_thick, wall_thick])
            cube([exact_inner_width, wall_thick, 10]);
    }
}

// 5. Middle Divider Shelf (1 cm Vents + 7 Bottom Sled Tracks + Rear Stop-Bar)
module mid_shelf() {
    union() {
        ventilated_shelf_blank();
        
        // Rear stop-bar for Pi sleds
        translate([0, switch_depth - wall_thick, wall_thick])
            cube([exact_inner_width, wall_thick, 10]);
            
        // 7x Bottom Guide Tracks
        for (i = [0 : num_pis - 1]) {
            translate([side_margin + (i * pi_slot_pitch), 0, wall_thick])
                guide_track(switch_depth - wall_thick);
        }
    }
}

// 6. Top Roof Shelf (Flat support-free print + 7 Upper Sled Tracks + 3 Vertical M3 Holes)
module top_shelf() {
    union() {
        difference() {
            ventilated_shelf_blank();
            
            // 3x Vertical M3 Clearance + Countersink Holes along rear edge for top_raiser
            for (x_pos = raiser_screw_x_offsets) {
                // Vertical through hole (3.4mm)
                translate([x_pos, raiser_screw_y, -1])
                    cylinder(d = m3_through_dia, h = wall_thick + 2);
                    
                // Countersink on track side (underside of shelf when assembled, 2.5mm deep)
                translate([x_pos, raiser_screw_y, wall_thick - 2.0])
                    cylinder(d = 6.2, h = 2.5);
            }
        }
        
        // 7x Upper Guide Tracks
        for (i = [0 : num_pis - 1]) {
            translate([side_margin + (i * pi_slot_pitch), 0, wall_thick])
                guide_track(switch_depth - wall_thick);
        }
    }
}

// 7. Separate Top Rear Raiser Lip (Screws vertically onto top_shelf with 3x M3 screws)
module top_raiser() {
    difference() {
        cube([exact_inner_width, wall_thick, raiser_height]);
        
        // 3x Vertical Screw Holes on bottom face (3.9mm dia x 5mm deep, matching side hole rules)
        for (x_pos = raiser_screw_x_offsets) {
            translate([x_pos, wall_thick / 2, -0.5])
                cylinder(d = shelf_hole_dia, h = screw_depth + 0.5);
        }
    }
}

// 8. Symmetrical Vertical Rack Rail Post (10mm margins at BOTH ends -> 20mm pitch across stacked joints)
module rack_post() {
    hole_y = screw_y_offsets[0]; // 18 mm from outer end of post (aligns with both front & rear shelf holes)
    
    difference() {
        cube([wall_thick, post_depth, post_height]);
        
        // Vertical column of M3 mounting holes spaced every 2 cm (20 mm)
        for (z_pos = [rail_first_z : rail_hole_pitch : rail_last_z]) {
            // Through hole
            translate([-1, hole_y, z_pos])
                rotate([0, 90, 0])
                cylinder(d = m3_through_dia, h = wall_thick + 2);
                
            // Outer countersink / recess for screw head (2.5mm deep)
            translate([-0.5, hole_y, z_pos])
                rotate([0, 90, 0])
                cylinder(d = 6.2, h = 2.5);
        }
    }
}

// 9. Outer Side Handle Crossbar (Single uniform 5mm thickness; mounts on outside of front & rear posts)
module handle_bar() {
    difference() {
        // Single uniform 5mm-thick bar spanning the full depth of both posts
        cube([wall_thick, switch_depth, handle_bar_h]);
        
        // 2x Counterbored M3 Through-Holes aligned with existing front (Y=18) & rear (Y=87) post holes
        for (y_pos = screw_y_offsets) {
            // Clearance through-hole (3.4mm)
            translate([-1, y_pos, handle_bar_h / 2])
                rotate([0, 90, 0])
                cylinder(d = m3_through_dia, h = wall_thick + 2);
                
            // Outer countersink for M3 screw head (2.5mm deep on X=0 outer face)
            translate([-0.5, y_pos, handle_bar_h / 2])
                rotate([0, 90, 0])
                cylinder(d = 6.2, h = 2.5);
        }
    }
}

// 10. Detachable Raspberry Pi Sled (74.3mm height, flush front finger pull tab)
module pi_sled() {
    sled_len = switch_depth - wall_thick - 1;
    
    union() {
        difference() {
            cube([sled_thick, sled_len, sled_height]);
            
            // 4x M2.5 Raspberry Pi Mounting Holes (58mm x 49mm spacing preserved)
            for (y_pos = [hole_offset_y, hole_offset_y + hole_spacing_y],
                 z_pos = [hole_offset_z, hole_offset_z + hole_spacing_z]) {
                translate([-1, y_pos, z_pos])
                    rotate([0, 90, 0])
                    cylinder(d = m25_hole_dia, h = sled_thick + 2);
            }
            
            // Center Airflow Cutout (scales cleanly with sled height)
            translate([-1, 26, 15])
                cube([sled_thick + 2, 40, sled_height - 31]);
        }
        
        // Front Finger Pull Tab (flush with both sides of the sled)
        translate([0, -10, (sled_height / 2) - 12])
            cube([sled_thick, 10, 24]);
    }
}

// --- RENDER LOGIC (Auto-oriented flat on build plate for support-free export) ---
if (part_to_render == "rack_post") {
    rotate([0, -90, 0]) rack_post();
} else if (part_to_render == "handle_bar") {
    // Completely flat 5mm bar -> prints flat on build plate with zero supports
    rotate([0, -90, 0]) handle_bar();
} else if (part_to_render == "bottom_shelf") {
    bottom_shelf();
} else if (part_to_render == "mid_shelf") {
    mid_shelf();
} else if (part_to_render == "top_shelf") {
    // Completely flat on build plate with tracks pointing straight up -> zero supports needed
    top_shelf();
} else if (part_to_render == "top_raiser") {
    // Prints flat on build plate with vertical screw holes facing straight up -> zero supports needed
    translate([0, wall_thick, raiser_height]) rotate([180, 0, 0]) top_raiser();
} else if (part_to_render == "sled") {
    rotate([0, -90, 0]) pi_sled();
} else {
    // Preview Complete 4-Post Open-Frame Rack
    // Front-Left & Front-Right Posts
    color("DimGray") rack_post();
    translate([total_width, 0, 0]) mirror([1, 0, 0]) color("DimGray") rack_post();
    
    // Rear-Left & Rear-Right Posts (mirrored in Y so countersinks face outward & holes align at Y=87mm)
    translate([0, switch_depth, 0]) mirror([0, 1, 0]) color("DimGray") rack_post();
    translate([total_width, switch_depth, 0]) mirror([1, 0, 0]) mirror([0, 1, 0]) color("DimGray") rack_post();
    
    // Outer Left & Right Side Handle Crossbars (mounted on the OUTSIDE of the front & rear posts at Z = 150.0mm)
    translate([-wall_thick, 0, handle_center_z - (handle_bar_h / 2)])
        color("SlateGray") handle_bar();
    translate([total_width + wall_thick, 0, handle_center_z - (handle_bar_h / 2)])
        mirror([1, 0, 0]) color("SlateGray") handle_bar();
    
    // Shelves (aligned at Z = 10.0mm, 50.0mm, and 130.0mm post holes)
    translate([wall_thick, 0, bot_shelf_z]) color("Silver") bottom_shelf();
    translate([wall_thick, 0, mid_shelf_z]) color("Silver") mid_shelf();
    
    // Flip top_shelf upside down so its tracks point downward and countersinks face downward
    translate([wall_thick, 0, top_shelf_z + wall_thick]) 
        mirror([0, 0, 1]) color("Silver") top_shelf();
        
    // Separate Top Rear Raiser mounted on top rear edge of top_shelf
    translate([wall_thick, switch_depth - wall_thick, top_shelf_z + wall_thick])
        color("LightSlateGray") top_raiser();
        
    // 7x Raspberry Pi Sleds
    for (i = [0 : num_pis - 1]) {
        translate([wall_thick + side_margin + 2.0 + tolerance + (i * pi_slot_pitch), 0, mid_shelf_z + wall_thick + tolerance])
            color("SteelBlue") pi_sled();
    }
}