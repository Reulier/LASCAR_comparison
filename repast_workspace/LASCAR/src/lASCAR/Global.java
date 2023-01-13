package lASCAR;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import repast.simphony.context.Context;
import repast.simphony.engine.schedule.ScheduledMethod;
import repast.simphony.essentials.RepastEssentials;
import repast.simphony.query.space.grid.GridCell;
import repast.simphony.query.space.grid.GridCellNgh;
import repast.simphony.space.grid.Grid;
import repast.simphony.space.grid.GridPoint;
import repast.simphony.util.ContextUtils;
import repast.simphony.util.collections.IndexedIterable;

public class Global {
	
	private Context<Object> context;
	private Grid<Object> grid;
	
	private long lastTime = 0;
	
	public List<Patch> patches = new ArrayList<Patch>();
	
	public Global(Context<Object> context, Grid<Object> grid) {
		this.context = context;
		this.grid = grid;
		
		context.add(this);
	}
	
	@ScheduledMethod(start = 0)
	public void start() {
		IndexedIterable<Object> patchesFromContext = context.getObjects(Patch.class);
		for (Object objPatch : patchesFromContext) {
			Patch patch = (Patch)objPatch;
			patches.add(patch);
		}

		System.out.println("tick;time;time_patch;time_drop;drops;");//time_patch_getLocation;time_patch_dropsHere;time_patch_actions;time_drop_getLocation;time_drop_patchHere;time_drop_remove;time_drop_move");
		lastTime = System.currentTimeMillis();
	}
	
	@ScheduledMethod(start = 1, interval = 1)
	public void step () {
		
		long start_timer_patch = System.nanoTime();
//		IndexedIterable<Object> patches = context.getObjects(Patch.class);
		
//		long total_timer_patch_getLocation = 0;
//		long total_timer_patch_dropsHere = 0;
//		long total_timer_patch_actions = 0;
		
		for (Patch patch : patches) {
//			long end_time_for_next_patch = System.nanoTime();
//			total_time_for_next_patch += (end_time_for_next_patch - start_time_for_next_patch);
			
//			long start_timer_patch_getLocation = System.nanoTime();
//			GridPoint point = grid.getLocation(patch);
//			long end_timer_patch_getLocation = System.nanoTime();
//			total_timer_patch_getLocation += (end_timer_patch_getLocation - start_timer_patch_getLocation);
			
//			long start_timer_patch_dropsHere = System.nanoTime();
			List<Drop> dropsHere = new ArrayList<Drop>();
//			List<Drop> dropsHere = patch.dropsHere;
			
//			for(Object objDrop : grid.getObjectsAt(point.getX(), point.getY())) {
			for(Object objDrop : grid.getObjectsAt(patch.x, patch.y)) {
				if (objDrop instanceof Drop) {
					dropsHere.add((Drop)objDrop);
				}
			}
//			long end_timer_patch_dropsHere = System.nanoTime();
//			total_timer_patch_dropsHere += (end_timer_patch_dropsHere - start_timer_patch_dropsHere);
			
//			long start_timer_patch_actions = System.nanoTime();
			if (dropsHere.size() > 0) {
				if (dropsHere.size() > 1) patch.mergeDrops();
				if (patch.isHollow) patch.waterAbsorption();
			}
//			long end_timer_patch_actions = System.nanoTime();
//			total_timer_patch_actions += (end_timer_patch_actions - start_timer_patch_actions);
			
//			start_time_for_next_patch = System.nanoTime();
		}
		long total_timer_patch = Math.round((System.nanoTime() - start_timer_patch) / 1000000);
//		total_timer_patch_getLocation = Math.round(total_timer_patch_getLocation );// / 1000000);
//		total_timer_patch_dropsHere = Math.round(total_timer_patch_dropsHere );// / 1000000);
//		total_timer_patch_actions = Math.round(total_timer_patch_actions );// / 1000000);
		
		long start_timer_drop = System.currentTimeMillis();
		List<Object> drops = new ArrayList<Object>();
		context.getObjects(Drop.class).iterator().forEachRemaining(drops::add);
		
//		long total_timer_drop_getLocation = 0;
//		long total_timer_drop_patchHere = 0;
//		long total_timer_drop_remove = 0;
//		long total_timer_drop_move = 0;
		
		ArrayList<Drop> dropToRemove = new ArrayList<Drop>();
		
		for (int i = 0; i < drops.size(); i++) {
			Drop drop = (Drop)drops.get(i);
			Patch patchHere = null;
			
//			long start_timer_drop_getLocation = System.nanoTime();
			GridPoint point = grid.getLocation(drop);
//			long end_timer_drop_getLocation = System.nanoTime();
//			total_timer_drop_getLocation += (end_timer_drop_getLocation - start_timer_drop_getLocation);
			
//			long start_timer_drop_patchHere = System.nanoTime();
			for(Object objPatch : grid.getObjectsAt(point.getX(), point.getY())) {
				if (objPatch instanceof Patch) {
					patchHere = (Patch)objPatch;
					break;
				}
			}
//			patchHere = drop.patchHere;
//			long end_timer_drop_patchHere = System.nanoTime();
//			total_timer_drop_patchHere += (end_timer_drop_patchHere - start_timer_drop_patchHere);
			
			
			if (patchHere.isBorder || drop.volume == 0) {
//				long start_timer_drop_remove = System.nanoTime();
//				context.remove(drop);
				dropToRemove.add(drop);
//				drop.die();
//				long end_timer_drop_remove = System.nanoTime();
//				total_timer_drop_remove += (end_timer_drop_remove - start_timer_drop_remove);
			}
			else {
				if (patchHere != patchHere.target) {
//					long start_timer_drop_move = System.nanoTime();
//					GridPoint targetLocation = grid.getLocation(patchHere.target);
//					grid.moveTo(drop, targetLocation.getX(), targetLocation.getY());
					drop.moveTo(patchHere.target);
//					long end_timer_drop_move = System.nanoTime();
//					total_timer_drop_move += (end_timer_drop_move - start_timer_drop_move);
				}
//				patches.add(drop.patchHere);
			}
		}
//		long start_timer_drop_remove = System.nanoTime();
		context.removeAll(dropToRemove);
//		long end_timer_drop_remove = System.nanoTime();
//		total_timer_drop_remove += (end_timer_drop_remove - start_timer_drop_remove);
		
		long total_timer_drop = System.currentTimeMillis() - start_timer_drop;
//		total_timer_drop_getLocation = Math.round(total_timer_drop_getLocation / 1000000);
//		total_timer_drop_patchHere = Math.round(total_timer_drop_patchHere / 1000000);
//		total_timer_drop_remove = Math.round(total_timer_drop_remove / 1000000);
//		total_timer_drop_move = Math.round(total_timer_drop_move / 1000000);
		
		long currentTime = System.currentTimeMillis();
		System.out.println((int)(RepastEssentials.GetTickCount()-1) + ";" + (currentTime - lastTime) + ";" + total_timer_patch + ";" + total_timer_drop + ";" + drops.size());// + ";" + total_timer_patch_getLocation + ";" + total_timer_patch_dropsHere + ";" + total_timer_patch_actions + ";" + total_timer_drop_getLocation + ";" + total_timer_drop_patchHere + ";" + total_timer_drop_remove + ";" + total_timer_drop_move);
		
		lastTime = currentTime;
	}
}
