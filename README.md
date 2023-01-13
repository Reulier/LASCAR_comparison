# LASCAR

## Directories

* `result` : data presented in the article and `R`files to generate the figures.
* `gama_workspace` : source code for the GAMA platform.
* `netlogo_workspace` : source code for the NetLogo platform.
* `repast_workspace` : source code for the Repast Simphony platform. 

### Agent-based platforms

Follow the instructions.

* **NetLogo** - Version 6.1.1 [see here](https://ccl.northwestern.edu/netlogo/)
* **GAMA** - Version 1.8 (max. RAM set to 4096 Mo) [see here](https://gama-platform.github.io)
* **Repast Simphony** - Version 2.7.0 [see here](https://repast.github.io)

Those ABM platform have new version. Except for Repast Simphony, new versions can be used. 

# GAMA

* Install GAMA (see above)
* Launch GAMA and make `gama_workspace` as your workspace
* Select `New`-> `Other`then select `General` -> `Project`
* Create a new projet named `LASCAR`: the model will be imported
* Open `LASCAR\models\LASCAR_V1.gaml`in the GAMA IDE
* Run the `simulation` experiment
* You can switch from LaBouderie and LaLingèvres experiments with commenting / decommenting the `grid line` instructions (lines 10 to 20)
* You can deactivate the visual rendering by commenting the `output` lines 273 to 278

# NETLOGO

* Install NetLogo (see above)
* Launch NetLogo and open the file `LASCAR_V1.nlogo`
* Use the buttons to load map data, generate rain, then launch simulation
* You can switch from LaBouderie and LaLingèvres experiments with commenting / decommenting the `set [...] gis:load-dataset` instructions (lines 57 to 63)
* You can deactivate the visual rendering by ticking the `view updates`check box

# REPAST

* Install Repast Simphony (see above, beware installation is bit more complex than previously)
* Please note that the Repast Simphony version used for our model is Repast Simphony 2.7.0
* Launch Eclipse and make `repast_workspace` as your workspace
* The project LASCAR should appear
* Launch the Run Configuration `LASCAR Launcher`
* You can switch from La Bouderie and La Lingèvre experiments by commenting / decommenting the Raster Layer instructions in `src\lASCAR\LASCARBuilder.java` (lines 45 to 55)
* You can deactivate the visual rendering by commenting the `repast.simphony.action.display` in `LASCAR.rs\scenario.xml` (line 4)

# RESULTS

* Install R if needed [see here](https://cran.r-project.org/)
* You can check the `.csv` files in the different directories inside `results`
* In the directory `results`, launch R and execute the script `LASCAR.R` (`source("LASCAR.R")` in command line)
* All figures will be generated in the `results/IMG/` directory
