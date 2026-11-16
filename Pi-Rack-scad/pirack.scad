// =========================================================
// Modular 4-Post Open-Frame Rack: 8x Pi Sleds + PoE Switch
// (Mirrored Assembly, 15mm Vents, 25mm Sled Gap, 15cm Depth)
// =========================================================

// --- EXPORT SELECTION ---
// "all"          -> Preview complete mirrored assembled 4-post rack
// "rack_post"    -> Print 4x (Identical Y & Z symmetrical 2 cm rails — fits any corner/orientation)
// "handle_bar"   -> Print 2x (Outer side handle bars connecting front & rear posts on left & right)
// "bottom_shelf" -> Print 1x (Base + 15mm vents + 5mm rear switch stop at 15cm back edge)
// "mid_shelf"    -> Print 1x (Divider shelf + 15mm vents + 100mm sled tracks + 5mm sled stop at Y=100mm)
// "top_shelf"    -> Print 1x (Flat support-free top roof + 15mm vents + 100mm upper tracks + M3 holes)
// "top_raiser"   -> Print 1x (Separate rear raiser lip with 3.9mm x 5mm vertical screw holes)
// "sled"         -> Print 8x (99mm x 94.3mm detachable Pi sleds with M3 Pi mounting holes)
part_to_render = "all"; 

// --- CUSTOMIZABLE PARAMETERS (in mm) ---
num_pis = 8;
sled_thick = 3;            // Thickness of each removable Pi tray
sled_face_gap = 25;        // Clear face-to-face distance between adjacent Pi sleds (25.0 mm)
pi_slot_pitch = sled_thick + sled_face_gap; // 28.0 mm center-to-center spacing

switch_depth = 150;        // 15 cm (150 mm) front-to-back depth of the shelves
sled_stop_y = 100;         // Front face of the Pi sled stop-bar (maintains 99mm sled length)
wall_thick = 5;            // 5mm thickness for sturdy M3 edge screws
bottom_stop_height = 5;    // 5mm height of the rear switch stop-lip on the bottom shelf
mid_stop_height = 5;       // 5mm height of the sled stop-bar on the middle shelf
raiser_height = 10;        // 10 mm height of the separate top rear raiser lip

// --- RACK RAIL POST SPECS & SYMMETRICAL 2 CM GRID ---
post_depth = 30;           // Front-to-back width of each individual corner rail post (holes centered at 15mm)
rail_hole_pitch = 20;      // 2 cm (20 mm) vertical center-to-center spacing between shelf mounting holes
rail_end_margin = rail_hole_pitch / 2; // 10 mm at BOTH ends so stacking posts keeps a 20 mm seam pitch

bot_shelf_hole_idx = 0;    // Bottom shelf mounts at hole #0 (Z = 10.0mm -> 7.5mm bottom leg clearance)
switch_grid_steps = 3;     // Bottom-to-middle shelf spacing in 20mm steps (3 * 20 = 60mm pitch -> 55mm switch bay)
pi_grid_steps = 5;         // Middle-to-top shelf spacing in 20mm steps (5 * 20 = 100mm pitch -> 95mm Pi bay)
num_post_holes = bot_shelf_hole_idx + switch_grid_steps + pi_grid_steps + 2; // 10 holes = 200.0mm total post length
handle_hole_idx = num_post_holes - 1; // Top hole (#9 at Z = 190.0mm) connects front & rear posts on the outside

// --- OUTER SIDE HANDLE SPECS ---
handle_bar_h = 20;         // Vertical height of the outer crossbar handle (Z = 180..200mm)

// --- VENTILATION HOLE SPECS (Bottom, Middle & Top Shelves) ---
vent_hole_dia = 15;        // 15 mm diameter holes
vent_edge_gap = 5;         // 5 mm solid gap between adjacent holes
vent_pitch_y = vent_hole_dia + vent_edge_gap; // 20 mm center-to-center spacing
vent_start_y = 14.5;       // Front margin before first hole center (7mm solid front border)
vent_end_y = switch_depth - wall_thick - (vent_hole_dia / 2) - 2.5; // Stops safely clear of rear shelf edge (135.0mm)

// --- FASTENER SPECS (M3 Screws - Centered on Symmetrical Posts) ---
m3_through_dia = 3.4;      // Clearance hole through posts, outer handles & top shelf
shelf_hole_dia = 3.9;      // Hole diameter in shelf edges, handle ends & top raiser (for M3 heat-set inserts)
screw_depth = 5;           // Depth of holes into shelf edges, handle ends & top raiser (in mm)
screw_y_offsets = [post_depth / 2, switch_depth - (post_depth / 2)]; // [15.0, 135.0] centered on front & rear posts

// --- RAIL TOLERANCE PARAMETERS ---
rail_height = 3.5;         // Height of the guide rails
tolerance = 0.35;          // Sliding clearance (bump to 0.45 if tight)

// --- RASPBERRY PI MOUNTING HOLE SPECS (M3 Clearance, 14.5 mm from Top Edge) ---
hole_offset_y = 14;        // Distance from front of sled to first mounting hole
hole_spacing_y = 58;       // Standard Pi 3/4/5 front-to-back hole spacing
top_hole_margin = 14.5;    // Distance from top edge of sled to top Pi mounting holes
hole_spacing_z = 49;       // Standard Pi 3/4/5 bottom-to-top hole spacing
pi_hole_dia = 3.4;         // M3 clearance diameter (matches m3_through_dia)

// --- CALCULATED DIMENSIONS ---
side_margin = 2.0;                                  // 2mm margin at left & right posts
track_total_w = 4.0 + sled_thick + (tolerance * 2); // 7.7mm total width of one U-channel track
sled_len = sled_stop_y - 1;                         // 99.0mm original sled length

// Full 8 pitches + left & right margins (8 * 28 + 4 = 228.0mm inner width)
exact_inner_width = (num_pis * pi_slot_pitch) + (side_margin * 2);
total_width = exact_inner_width + (wall_thick * 2); // 238.0mm total outer width

// 3 evenly spaced vertical screw X positions for the top rear raiser (clear of side screws & tracks)
raiser_screw_x_offsets = [25, exact_inner_width / 2, exact_inner_width - 25];
raiser_screw_y = switch_depth - (wall_thick / 2);

// Symmetrical post height & hole bounds (10mm bottom margin + 9*20mm + 10mm top margin = 200.0mm)
post_height  = num_post_holes * rail_hole_pitch;                             // 200.0mm total post length
rail_first_z = rail_end_margin;                                              // 10.0mm first hole center
rail_last_z  = post_height - rail_end_margin;                                // 190.0mm last hole center

// Grid-aligned vertical shelf & handle Z positions
bot_shelf_center_z = rail_first_z + (bot_shelf_hole_idx * rail_hole_pitch);  // 10.0mm
mid_shelf_center_z = bot_shelf_center_z + (switch_grid_steps * rail_hole_pitch); // 70.0mm
top_shelf_center_z = mid_shelf_center_z + (pi_grid_steps * rail_hole_pitch); // 170.0mm
handle_center_z    = rail_first_z + (handle_hole_idx * rail_hole_pitch);     // 190.0mm

bot_shelf_z = bot_shelf_center_z - (wall_thick / 2);                         // 7.5mm
mid_shelf_z = mid_shelf_center_z - (wall_thick / 2);                         // 67.5mm
top_shelf_z = top_shelf_center_z - (wall_thick / 2);                         // 167.5mm

// Resulting bay heights & sled height
switch_height     = mid_shelf_z - (bot_shelf_z + wall_thick);                // 55.0mm clear switch bay
pi_section_height = top_shelf_z - (mid_shelf_z + wall_thick);                // 95.0mm clear Pi bay
sled_height       = pi_section_height - (tolerance * 2);                     // 94.3mm sled height

// Vertical Z coordinates for Pi mounting holes on sled
pi_top_hole_z = sled_height - top_hole_margin;                               // 79.8mm
pi_bot_hole_z = pi_top_hole_z - hole_spacing_z;                              // 30.8mm
sled_cutout_margin_z = 10;                                                   // 1 cm (10 mm) top & bottom border around airflow cutout

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
        
        // Edge holes on Left (x=0) and Right (x=exact_inner_width) edges at Y = 15.0 & 135.0mm
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
module ventilated_shelf_blank(avoid_mid_stop = false) {
    open_bay_w = pi_slot_pitch - track_total_w; // 20.3mm open space in every single bay
    first_vent_x = side_margin + track_total_w + (open_bay_w / 2);
    stop_clearance = (vent_hole_dia / 2) + 2.5; // Keep at least 2.5mm solid wall around mid_shelf stop-bar

    difference() {
        shelf_blank();
        
        // All 8 columns of 15 mm holes centered in each equal 20.3mm bay
        for (col = [0 : num_pis - 1], vy = [vent_start_y : vent_pitch_y : vent_end_y]) {
            if (!avoid_mid_stop || (vy < sled_stop_y - stop_clearance || vy > sled_stop_y + wall_thick + stop_clearance)) {
                translate([first_vent_x + (col * pi_slot_pitch), vy, -1])
                    cylinder(d = vent_hole_dia, h = wall_thick + 2);
            }
        }
    }
}

// 4. Bottom Shelf (15 mm Vents + 5 mm rear switch stop-lip at Y=145..150mm)
module bottom_shelf() {
    union() {
        ventilated_shelf_blank();
        // Rear switch stop-lip (5mm tall)
        translate([0, switch_depth - wall_thick, wall_thick])
            cube([exact_inner_width, wall_thick, bottom_stop_height]);
    }
}

// 5. Middle Divider Shelf (15 mm Vents + 8x 100mm Bottom Sled Tracks + 5 mm Sled Stop-Bar at Y=100mm)
module mid_shelf() {
    union() {
        ventilated_shelf_blank(avoid_mid_stop = true);
        
        // Sled stop-bar positioned at Y = 100.0mm (leaving 45mm rear cable/accessory space)
        translate([0, sled_stop_y, wall_thick])
            cube([exact_inner_width, wall_thick, mid_stop_height]);
            
        // 8x Bottom Guide Tracks (100.0mm long, terminating flush at the sled stop-bar)
        for (i = [0 : num_pis - 1]) {
            translate([side_margin + (i * pi_slot_pitch), 0, wall_thick])
                guide_track(sled_stop_y);
        }
    }
}

// 6. Top Roof Shelf (Flat support-free print + 15 mm Vents + 8x 100mm Upper Sled Tracks + 3 Vertical M3 Holes)
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
        
        // 8x Upper Guide Tracks (100.0mm long, matching the lower tracks and sled length)
        for (i = [0 : num_pis - 1]) {
            translate([side_margin + (i * pi_slot_pitch), 0, wall_thick])
                guide_track(sled_stop_y);
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

// 8. Fully Symmetrical Vertical Rack Rail Post (Centered in Y at 15mm & 10mm margins at both ends in Z)
module rack_post() {
    hole_y = post_depth / 2; // 15.0 mm exact centerline in Y
    
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
        // Single uniform 5mm-thick bar spanning the full 150mm depth of both posts
        cube([wall_thick, switch_depth, handle_bar_h]);
        
        // 2x Counterbored M3 Through-Holes aligned with centered front (Y=15) & rear (Y=135) post holes
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

// 10. Detachable Raspberry Pi Sled (94.3mm height, 99.0mm length, M3 Pi holes 14.5mm from top)
module pi_sled() {
    union() {
        difference() {
            cube([sled_thick, sled_len, sled_height]);
            
            // 4x M3 Raspberry Pi Mounting Holes (58mm x 49mm spacing, 14.5mm from top edge)
            for (y_pos = [hole_offset_y, hole_offset_y + hole_spacing_y],
                 z_pos = [pi_bot_hole_z, pi_top_hole_z]) {
                translate([-1, y_pos, z_pos])
                    rotate([0, 90, 0])
                    cylinder(d = pi_hole_dia, h = sled_thick + 2);
            }
            
            // Center Airflow Cutout (1 cm = 10 mm from both top and bottom edges of the sled)
            translate([-1, 26, sled_cutout_margin_z])
                cube([sled_thick + 2, 40, sled_height - (sled_cutout_margin_z * 2)]);
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
    // Preview Complete Mirrored 4-Post Open-Frame Rack
    translate([total_width, 0, 0]) mirror([1, 0, 0]) {
        // Front-Left & Front-Right Posts
        color("DimGray") rack_post();
        translate([total_width, 0, 0]) mirror([1, 0, 0]) color("DimGray") rack_post();
        
        // Rear-Left & Rear-Right Posts (Y-symmetric posts placed directly at Y = switch_depth - post_depth)
        translate([0, switch_depth - post_depth, 0]) color("DimGray") rack_post();
        translate([total_width, switch_depth - post_depth, 0]) mirror([1, 0, 0]) color("DimGray") rack_post();
        
        // Outer Left & Right Side Handle Crossbars (mounted on the OUTSIDE of the front & rear posts at Z = 190.0mm)
        translate([-wall_thick, 0, handle_center_z - (handle_bar_h / 2)])
            color("SlateGray") handle_bar();
        translate([total_width + wall_thick, 0, handle_center_z - (handle_bar_h / 2)])
            mirror([1, 0, 0]) color("SlateGray") handle_bar();
        
        // Shelves (aligned at Z = 10.0mm, 70.0mm, and 170.0mm post holes)
        translate([wall_thick, 0, bot_shelf_z]) color("Silver") bottom_shelf();
        translate([wall_thick, 0, mid_shelf_z]) color("Silver") mid_shelf();
        
        // Flip top_shelf upside down so its tracks point downward and countersinks face downward
        translate([wall_thick, 0, top_shelf_z + wall_thick]) 
            mirror([0, 0, 1]) color("Silver") top_shelf();
            
        // Separate Top Rear Raiser mounted on top rear edge of top_shelf
        translate([wall_thick, switch_depth - wall_thick, top_shelf_z + wall_thick])
            color("LightSlateGray") top_raiser();
            
        // 8x Raspberry Pi Sleds (25.0mm face-to-face gap, 99mm long, 94.3mm tall)
        for (i = [0 : num_pis - 1]) {
            translate([wall_thick + side_margin + 2.0 + tolerance + (i * pi_slot_pitch), 0, mid_shelf_z + wall_thick + tolerance])
                color("SteelBlue") pi_sled();
        }
    }
}