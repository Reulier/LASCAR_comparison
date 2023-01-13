model LASCAR_V1


global {
	
	/*
	 * Data for the La Lingevres
	 */
	 
	//grid_file altitude_file <- grid_file('../external/laLingevres/data/mnt.asc');
	//grid_file direction_file <- grid_file('../external/laLingevres/data/direction.asc');
	//grid_file occupation_file <- grid_file('../external/laLingevres/data/mos.asc');

	/*
	 * Data for the La Bouderie
	 */
	
	grid_file altitude_file <- grid_file('../external/laBouderie/data/mnt.asc');
	grid_file direction_file <- grid_file('../external/laBouderie/data/direction.asc');
	grid_file occupation_file <- grid_file('../external/laBouderie/data/mos.asc');

	geometry shape <- envelope(occupation_file, direction_file, altitude_file);

	/*
	 * Ditch height substracted to the altitude.
	 */
	float DITCH_HEIGHT <- 0.5;
	/*
	 * Hedge height added to the altitude.
	 */
	float HEDGE_HEIGHT <- 1.0;
	
	/*
	 * Colors for the interface.
	 */
	map<string, map<string, rgb>> COLOR <- map([
		"MOS"::[
			"ERROR"::#black,
			"PRAIRIE"::rgb("#7CB342"),
			"ZONE-URBAINE"::rgb('#424242'),
			"VERGER"::rgb("#42B379"),
			"CULTURE"::rgb("#FFDE03"),
			"BOIS"::rgb("#416D4C"),
			"CUVETTE"::rgb(195,230,230)
		],
		"DIRECTION"::[
			"EST"::rgb('#8802EE'),
			"SUD-EST"::rgb('#BB4578'),
			"SUD"::rgb('#EE8802'),
			"SUD-OUEST"::rgb('#ABBB02'),
			"OUEST"::rgb('#68EE02'),
			"NORD-OUEST"::rgb('#35AB78'),
			"NORD"::rgb('#0267EE'),
			"NORD-EST"::rgb('#4535EE')
		],
		"LINEAIRE"::[
			"FOSSE"::rgb("#6D4C41"),
			"HAIE"::rgb(41,87,33)
		]
	]);
	
	init {
		ask Patch parallel:true {
			do computeHollow;
		}
		
		ask Patch parallel:true {
			do computeTarget;
		}
		
		loop patch over: (Patch where (!each.isBorder)) {
			create Drop number:1 with:(patch_here:patch) returns:drop;
		
		}
	}
	
	string BILAN_PAR_CYCLE <- "tick;time;time_patch;time_drop;drops\n";
	string A_CYCLE;
	float timer_patch <- 0.0;
	float timer_drop <- 0.0;
	
	reflex go {
		//do pause;
		A_CYCLE  <- "" + cycle + ";" + duration + ";" + timer_patch + ";" + timer_drop + ";" + length(Drop) + "\n";
		BILAN_PAR_CYCLE <- BILAN_PAR_CYCLE + A_CYCLE;
		write A_CYCLE;
		//write length(Patch where (each.isHollow));
		
		float start_timer_patch <- machine_time;
		ask Patch where !empty(each.drops_here) parallel:true {
			
			/* Uncomment to activate the merge drop function */
			
			//if (length(drops_here) > 1) {
			//	do mergeDrops;
			//}
			
			do waterAbsorption;
		}
		timer_patch <- (machine_time - start_timer_patch);
		
		float start_timer_drop <- machine_time;
		ask Drop parallel:false {
			target_patch <- patch_here.target;
			
		if (patch_here.isBorder or volume=0) {
			do drop_die;
		}
		else {
			if (target_patch != patch_here) {
				do move;
			}
		}
		}
		timer_drop <- (machine_time - start_timer_drop);
	}
	
	reflex end_simulation when: cycle = 302 {
		save BILAN_PAR_CYCLE to:"GAMA_"+machine_time+".csv" type:"text";
		do pause;
	}
}

grid Patch files:[occupation_file, direction_file, altitude_file] neighbors:8 parallel:true schedules:[] use_individual_shapes:false {
	/*
	 * Target patch for the AgentDrops in the current patch.
	 */
	Patch target;
	/*
	 * Indicates if the patch is on a border.
	 */
	bool isBorder <- (length(neighbors) != 8);
	/*
	 * Indicates if the patch is a depression.
	 */
	bool isHollow <- false;
	/*
	 * Set of AgentDrops on the patch.
	 */
	list<Drop> drops_here;
	/*
	 * Virtual altitude: real altitude plus water level.
	 */
	float virtual_altitude <- bands[2];
	
	init {		
		switch(bands[0]) {
			match 10.0 	{
				color <- COLOR["LINEAIRE"]["HAIE"];
				virtual_altitude <- bands[2] + HEDGE_HEIGHT;
			}
			match 20.0 	{
				color <- COLOR["LINEAIRE"]["FOSSE"];
				virtual_altitude <- bands[2] - DITCH_HEIGHT;
			}
			match 100.0 {
				color <- COLOR["MOS"]["CUVETTE"];
				virtual_altitude <- bands[2] - 20;
			}
			match 1000.0{color <- COLOR["MOS"]["ZONE-URBAINE"];}
			match 3000.0{color <- COLOR["MOS"]["PRAIRIE"];}
			match 5000.0{color <- COLOR["MOS"]["CULTURE"];}
			default 	{color <- COLOR["MOS"]["ERROR"];isBorder<-true;virtual_altitude<-0.0;}
		}
		if (isBorder) 	{color <- #black;}
	}
	
	action mergeDrops {
		loop i from:1 to:length(drops_here)-1 {
			drops_here[0].volume <- drops_here[0].volume + drops_here[i].volume;
			drops_here[i].volume <- 0.0;
		}
	}

	action waterAbsorption {
		if (isHollow) {

			// Makes the experiment deterministic by ordering patches.
			
			float min_alt <- neighbors min_of (each.virtual_altitude);
			list<Patch> sorted_neighbors <- neighbors sort_by ((each.grid_x-grid_x)*10 + (each.grid_y-grid_y));
			Patch lowest_neighbor;
			loop neighbor over:sorted_neighbors {
				if (neighbor.virtual_altitude = min_alt) {
					lowest_neighbor <- neighbor;
					break;
				}
			}
			
			loop drop over:drops_here {
				if (!isHollow) {break;}
				
				float volume_to_absorb <- min([drop.volume, (lowest_neighbor.virtual_altitude-virtual_altitude)]);
				drop.volume <- drop.volume - volume_to_absorb;
				virtual_altitude <- virtual_altitude + volume_to_absorb;
				
				do computeHollow;
			}
			
			do computeTarget;
			ask neighbors parallel:true {
				do computeTarget;
			}
		}
		
	}
	
	/*
	 * Computes the target fo the AgentDrops.
	 */
	action computeTarget {
		if (!isHollow and !isBorder) {

			// Makes the experiment deterministic by ordering neighbors.
			
			float min_alt <- neighbors min_of ((each.virtual_altitude-virtual_altitude)/sqrt((grid_x-each.grid_x)^2 + (grid_y-each.grid_y)^2));
			list<Patch> sorted_neighbors <- neighbors sort_by ((each.grid_x-grid_x)*10 + (each.grid_y-grid_y));
			
			loop neighbor over:sorted_neighbors {
				if ((((neighbor.virtual_altitude-virtual_altitude)/sqrt((grid_x-neighbor.grid_x)^2 + (grid_y-neighbor.grid_y)^2)) = min_alt)) {
					target <- neighbor;
					break;
				}
			}
		}
		else {
			target <- self;
		}
	}
	
	/*
	 * Computes if the patch is a depression.
	 */
	action computeHollow {
		if (!isBorder) {
			isHollow<-(length(neighbors where (with_precision(each.virtual_altitude,5) < with_precision(virtual_altitude,5))) = 0);
		}
	}

}

species Drop parallel:true schedules:[] use_individual_shapes:false {
	float volume <- 0.4;
	Patch patch_here;
	Patch target_patch;
	
	init {
		add self to:patch_here.drops_here;
	}
	
	aspect default {
		location <- patch_here.location;
		float visibility <- min([0.5+(volume/0.4)*0.1, 1.0]);
		rgb drop_color <- ((volume <= 2.0) ? rgb("#427CB3") : ( (volume > 3.6)?rgb("#2C4F81"):rgb("#3A6CA1") )) ;
		draw circle(5) color:rgb(drop_color,visibility);
    }
    
    action move {
    	remove self from:patch_here.drops_here;
    	patch_here <- target_patch;
    	add self to: target_patch.drops_here;
    }
    
    action drop_die {
    	remove self from:patch_here.drops_here;
    	do die;
    }
}

species scheduler schedules:[];

experiment simulation type: gui /*benchmark: true*/ {
	output {
		display "Simulation" type: java2D refresh:true {
			grid Patch;
			species Drop;
		}
	} 
}
