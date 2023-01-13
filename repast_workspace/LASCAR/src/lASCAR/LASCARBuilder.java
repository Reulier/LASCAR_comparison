package lASCAR;

import java.io.File;
import java.util.ArrayList;

import org.geotools.coverage.grid.GridCoverage2D;
import org.geotools.gce.arcgrid.ArcGridFormat;
import org.geotools.gce.arcgrid.ArcGridReader;
import org.geotools.geometry.DirectPosition2D;
import org.opengis.geometry.DirectPosition;
import org.opengis.geometry.Envelope;

import repast.simphony.context.Context;
import repast.simphony.context.space.continuous.ContinuousSpaceFactory;
import repast.simphony.context.space.continuous.ContinuousSpaceFactoryFinder;
import repast.simphony.context.space.gis.GeographyFactory;
import repast.simphony.context.space.gis.GeographyFactoryFinder;
import repast.simphony.context.space.graph.NetworkBuilder;
import repast.simphony.context.space.grid.GridFactory;
import repast.simphony.context.space.grid.GridFactoryFinder;
import repast.simphony.dataLoader.ContextBuilder;
import repast.simphony.engine.schedule.ScheduledMethod;
import repast.simphony.random.RandomHelper;
import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.continuous.NdPoint;
import repast.simphony.space.continuous.RandomCartesianAdder;
import repast.simphony.space.gis.Geography;
import repast.simphony.space.gis.GeographyParameters;
import repast.simphony.space.grid.Grid;
import repast.simphony.space.grid.GridBuilderParameters;
import repast.simphony.space.grid.SimpleGridAdder;
import repast.simphony.space.grid.StrictBorders;
import repast.simphony.util.collections.IndexedIterable;

public class LASCARBuilder implements ContextBuilder<Object> {
		
	@Override
	public Context build(Context<Object> context) {
		context.setId("LASCAR");

		/*
		 * Data for the La Lingevres
		 */

		RasterLayer altitude_file = loadASCIIFile("./data/laLingevres/mnt.asc");
		RasterLayer direction_file = loadASCIIFile("./data/laLingevres/direction.asc");
		RasterLayer occupation_file = loadASCIIFile("./data/laLingevres/mos.asc");

		/*
		 * Data for the La Bouderie
		 */

		//RasterLayer altitude_file = loadASCIIFile("./data/laBouderie/mnt.asc");
		//RasterLayer direction_file = loadASCIIFile("./data/laBouderie/direction.asc");
		//RasterLayer occupation_file = loadASCIIFile("./data/laBouderie/mos.asc");

		Envelope world_envelope = altitude_file.getEnvelope();

		
		int WORLD_WIDTH = altitude_file.getWidth();
		int WORLD_HEIGHT = altitude_file.getHeight();
		
		GridFactory gridFactory = GridFactoryFinder.createGridFactory(null);
		Grid<Object> grid = gridFactory.createGrid(
				"grid",
				context,
				new GridBuilderParameters<Object>(
						new StrictBorders(),
						new SimpleGridAdder<Object>(),
						true, WORLD_WIDTH, WORLD_HEIGHT
				)
		);
		
		Global global = new Global(context, grid);

		for (int i = 0; i < WORLD_WIDTH; i++) {
			for (int j = 0; j < WORLD_HEIGHT; j++) {
				Patch patch = new Patch(
						context,
						grid,
						i,
						(WORLD_HEIGHT-1)-j,
						occupation_file.getIntegerGridValue(i, j),
						direction_file.getDoubleGridValue(i, j),
						altitude_file.getDoubleGridValue(i, j)
				);
			}
		}
		
		IndexedIterable<Object> patches = context.getObjects(Patch.class);
		
		for (Object obj : patches) {
			Patch patch = (Patch)obj;
			patch.init();
		}
		
		for (Object obj : patches) {
			Patch patch = (Patch)obj;
			patch.computeHollow();
		}
		
		for (Object obj : patches) {
			Patch patch = (Patch)obj;
			patch.computeTarget();
		}
		
		for (int i = 0; i < WORLD_WIDTH; i++) {
			for (int j = 0; j < WORLD_HEIGHT; j++) {
				Patch patchHere = null;
				for(Object objPatch : grid.getObjectsAt(i, j)) {
					if (objPatch instanceof Patch) {
						patchHere = (Patch)objPatch;
						break;
					}
				}
				
				if (!patchHere.isBorder) new Drop(context, grid, i, j, 0.4);
			}	
		}
		
		ArrayList<Patch> patchToRemove = new ArrayList<Patch>();
		for (Object obj : patches) {
			Patch patch = (Patch)obj;
			
			boolean mustBeRemove = true;
			for(Patch neighbor : patch.neighbors) {
				if (!neighbor.isBorder) mustBeRemove = false;
			}
			
			if (mustBeRemove) patchToRemove.add(patch);
		}
		System.out.println("Removed patches: "+patchToRemove.size());
		context.removeAll(patchToRemove);

		return context;
	}
	
	
	public RasterLayer loadASCIIFile(String fileName) {
		File file = new File(fileName);	
		try {
			ArcGridReader reader = new ArcGridReader(file);
			GridCoverage2D coverage = reader.read(null);

			RasterLayer rasterLayer = new RasterLayer(coverage);

			return rasterLayer;
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}
}
