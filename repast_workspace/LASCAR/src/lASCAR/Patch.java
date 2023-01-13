package lASCAR;

import java.awt.Color;
import java.util.Comparator;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import repast.simphony.context.Context;
import repast.simphony.query.space.grid.GridCell;
import repast.simphony.query.space.grid.GridCellNgh;
import repast.simphony.space.grid.Grid;
import repast.simphony.space.grid.GridPoint;

public class Patch  implements Comparable<Patch> {
	static public double DITCH_HEIGHT = 0.5;
	static public double HEDGE_HEIGHT = 1.0;
	
	private Context<Object> context;
	private Grid<Object> grid;
	
	private int occupation_data;
	private double direction_data;
	private double altitude_data;
	public Patch target;
	public boolean isBorder;
	public boolean isHollow;
	public double virtual_altitude;
	
	public int x;
	public int y;
	public List<Patch> neighbors;
	public Color color;
	
	public List<Drop> dropsHere = new ArrayList<Drop>();
	
	public Patch(Context<Object> context, Grid<Object> grid, int x, int y, int occupation_data, double direction_data, double altitude_data) {
		this.context = context;
		this.grid = grid;
		this.x = x;
		this.y = y;
		this.occupation_data = occupation_data;
		this.direction_data = direction_data;
		this.altitude_data = altitude_data;
		
		context.add(this);
		grid.moveTo(this, x, y);
	}
	
	public void init() {
		grid.moveTo(this, x, y);
		
		isBorder = false;
		isHollow = false;
		
		switch (occupation_data) {
			case(5000):
				color = new Color(255, 222, 3);
				virtual_altitude = altitude_data;
				break;
			case(3000):
				color = new Color(124, 179, 66);
				virtual_altitude = altitude_data;
				break;
			case(1000):
				color = new Color(66, 66, 66);
				virtual_altitude = altitude_data;
				break;
			case(100):
				color = new Color(255, 222, 3);
				virtual_altitude = altitude_data - 20;
				break;
			case(20):
				color = new Color(109, 76, 65);
				virtual_altitude = altitude_data - DITCH_HEIGHT;
				break;
			case(10):
				color = new Color(41, 87, 33);
				virtual_altitude = altitude_data + HEDGE_HEIGHT;
				break;
			default:
				color = new Color(0, 0, 0);
				virtual_altitude = 0;
				isBorder = true;
		}
		
		GridCellNgh<Patch> nghCreator = new GridCellNgh<Patch>(grid, new GridPoint(x, y), Patch.class , 1, 1);
		List<GridCell<Patch>> gridNeighbors = nghCreator.getNeighborhood(false);
		neighbors = gridNeighbors.stream().map(x -> x.items().iterator().next()).collect(Collectors.toList());
		
		if (neighbors.size() != 8)  {
			color = new Color(0, 0, 0);
			isBorder = true;
		}
	}
	
	public void computeHollow() {
		if (!isBorder) {
//			int count_neighbors_with_lower_virtual_altitude = 0;
//			for (Patch neighbor : neighbors) {
//				if (neighbor.virtual_altitude < this.virtual_altitude) {
//					count_neighbors_with_lower_virtual_altitude++;
//				}
//			}
//			
//			isHollow = (count_neighbors_with_lower_virtual_altitude == 0);
			
			isHollow = !neighbors.stream().anyMatch(neighbor -> neighbor.virtual_altitude < this.virtual_altitude);
		}
	}
	
	public void computeTarget() {
		if (!isHollow && !isBorder) {
//			double min_alt = (neighbors.stream().map(neighbor -> ((neighbor.virtual_altitude - this.virtual_altitude) / (Math.sqrt( Math.pow((this.x - neighbor.x), 2) + Math.pow((this.y - neighbor.y), 2) )))).collect(Collectors.toList())).stream().min(Comparator.naturalOrder()).get();
//			
//			Collections.sort(neighbors);
//			for(Patch neighbor : neighbors) {
//				if ( ((neighbor.virtual_altitude - this.virtual_altitude) / (Math.sqrt( Math.pow((this.x - neighbor.x), 2) + Math.pow((this.y - neighbor.y), 2) ))) == min_alt ) {
//					target = neighbor;
//					break;
//				}
//			}
			
			Patch min_patch = neighbors.get(0);
			double min_alt = ((min_patch.virtual_altitude - this.virtual_altitude) / (Math.sqrt( Math.pow((this.x - min_patch.x), 2) + Math.pow((this.y - min_patch.y), 2) )));
			
			for(Patch neighbor : neighbors) {
				double alt = ((neighbor.virtual_altitude - this.virtual_altitude) / (Math.sqrt( Math.pow((this.x - neighbor.x), 2) + Math.pow((this.y - neighbor.y), 2) )));
				if (alt == min_alt) {
					if (((neighbor.x - this.x)*10 - (neighbor.y - this.y)) < ((min_patch.x - this.x)*10 - (min_patch.y - this.y))) {
						min_patch = neighbor;
					}
				}
				else if (alt < min_alt) {
					min_patch = neighbor;
					min_alt = alt;
				}
			}
			
			target = min_patch;
			
		}
		else {
			target = this;
		}
	}
	
	public void mergeDrops() {
//		List<Drop> dropsHere = new ArrayList<Drop>();
//		
//		for(Object objDrop : grid.getObjectsAt(this.x, this.y)) {
//			if (objDrop instanceof Drop) {
//				dropsHere.add((Drop)objDrop);
//			}
//		}
		
		Drop mainDrop = dropsHere.get(0);
		for (int i = 1; i < dropsHere.size(); i++) {
			Drop currentDrop = dropsHere.get(i);
			
			mainDrop.volume += currentDrop.volume;
			currentDrop.volume = 0;
		}
	}
	
	public void waterAbsorption() {
//		double min_alt = (neighbors.stream().map(neighbor -> neighbor.virtual_altitude).collect(Collectors.toList())).stream().min(Comparator.naturalOrder()).get();
//		
//		Collections.sort(neighbors);
//		
//		Patch lowest_neighbor = null;
//		for(Patch neighbor : neighbors) {
//			if (neighbor.virtual_altitude == min_alt) {
//				lowest_neighbor = neighbor;
//				break;
//			}
//		}
		
		Patch lowest_neighbor = neighbors.get(0);
		double min_alt = lowest_neighbor.virtual_altitude;
		
		for(Patch neighbor : neighbors) {
			if (neighbor.virtual_altitude == min_alt) {
				if (((neighbor.x - this.x)*10 - (neighbor.y - this.y)) < ((lowest_neighbor.x - this.x)*10 - (lowest_neighbor.y - this.y))) {
					lowest_neighbor = neighbor;
				}
			}
			else if (neighbor.virtual_altitude < min_alt) {
				lowest_neighbor = neighbor;
				min_alt = neighbor.virtual_altitude;
			}
		}
		
//		List<Drop> dropsHere = new ArrayList<Drop>();
//		
//		for(Object objDrop : grid.getObjectsAt(this.x, this.y)) {
//			if (objDrop instanceof Drop) {
//				dropsHere.add((Drop)objDrop);
//			}
//		}
		
		for(Drop drop : dropsHere) {
			if (this.isHollow) {
				double volume_to_absorb = Math.min(drop.volume, (lowest_neighbor.virtual_altitude - this.virtual_altitude));
				drop.volume -= volume_to_absorb;
				this.virtual_altitude += volume_to_absorb;
				
				this.computeHollow();
			}
			else break;
		}
		
		this.computeTarget();
		for(Patch neighbor : neighbors) {
			neighbor.computeTarget();
		}
		
	}
	
	@Override
	public int compareTo(Patch patch) {
		return -((patch.x - this.x)*10 - (patch.y - this.y));
	}

	@Override
	public String toString() {
		return "Patch["+this.x+"]["+this.y+"]";
	}
	
}
