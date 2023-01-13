package lASCAR;

import repast.simphony.context.Context;
import repast.simphony.space.grid.Grid;

public class Drop {
	private Context<Object> context;
	private Grid<Object> grid;
		
	public double volume;
	public Patch patchHere;
	
	public Drop(Context<Object> context, Grid<Object> grid, int x, int y, double volume) {
		this.context = context;
		this.grid = grid;
		this.volume = volume;
		
		context.add(this);
		grid.moveTo(this, x, y);
		
		for(Object objPatch : grid.getObjectsAt(x, y)) {
			if (objPatch instanceof Patch) {
				patchHere = (Patch)objPatch;
				patchHere.dropsHere.add(this);
				break;
			}
		}
	}
	
	public void moveTo(Patch target) {
		grid.moveTo(this, target.x, target.y);
		patchHere.dropsHere.remove(this);
		patchHere = target;
		patchHere.dropsHere.add(this);
	}
	
	public void die() {
		patchHere.dropsHere.remove(this);
	}
}
