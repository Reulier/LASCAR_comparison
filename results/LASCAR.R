library(stringr)

###########################
                                                          
#######                                                   
#       #    # #    #  ####  ##### #  ####  #    #  ####  
#       #    # ##   # #    #   #   # #    # ##   # #      
#####   #    # # #  # #        #   # #    # # #  #  ####  
#       #    # #  # # #        #   # #    # #  # #      # 
#       #    # #   ## #    #   #   # #    # #   ## #    # 
#        ####  #    #  ####    #   #  ####  #    #  ####  
                                                          
###########################

compile_run_test = function(folder_path) {
  files_path = list.files(folder_path)[regexpr('run[0-9]+.csv', list.files(folder_path))==TRUE]
  tick = NULL
  drops = NULL
  run = NULL
  for (file_path in files_path) {
    print(paste(folder_path,file_path,sep=""))
    temp = read.csv(paste(folder_path,file_path,sep = ""), row.names = 1, header = TRUE, sep = ";")
    if (is.null(tick) || is.null(drops) || is.null(run)) {
      tick = rownames(temp)
      drops = temp[["drops"]]
      run = as.matrix(temp["time"], ncol = 1)
      colnames(run) = c((str_extract(file_path, "[0-9]+")))
    }
    else {
      if (any(tick != rownames(temp))) {
        stop(paste("Ticks number inconsistency: \"",file_path,"\"",sep=""))
      }
      new_col = temp["time"]
      colnames(new_col) = c((str_extract(file_path, "[0-9]+")))
      run = cbind(run, new_col)
    }
    
  }
  
  time = apply(run, 1, mean)
  
  value = list(tick = tick, drops = drops, time = time, run = run)
  class(value) = "compile_run_test"
  value
}


compile_run_test_with_splitTimer = function(folder_path) {
  files_path = list.files(folder_path)[regexpr('run[0-9]+.csv', list.files(folder_path))==TRUE]
  tick = NULL
  drops = NULL
  run = NULL
  run_patch = NULL
  run_drop = NULL
  for (file_path in files_path) {
    print(paste(folder_path,file_path,sep=""))
    temp = read.csv(paste(folder_path,file_path,sep = ""), row.names = 1, header = TRUE, sep = ";")
    if (is.null(tick) || is.null(drops) || is.null(run)) {
      tick = rownames(temp)
      drops = temp[["drops"]]
      run = as.matrix(temp["time"], ncol = 1)
      colnames(run) = c((str_extract(file_path, "[0-9]+")))
      
      run_patch = as.matrix(temp["time_patch"], ncol = 1)
      colnames(run_patch) = c((str_extract(file_path, "[0-9]+")))
      run_drop = as.matrix(temp["time_drop"], ncol = 1)
      colnames(run_drop) = c((str_extract(file_path, "[0-9]+")))
    }
    else {
      if (any(tick != rownames(temp))) {
        stop(paste("Ticks number inconsistency:  \"",file_path,"\"",sep=""))
      }
      if (any(drops != temp["drops"])) {
        stop(paste("Drops number inconsistency: \"",file_path,"\"",sep=""))
      }
      new_col = temp["time"]
      colnames(new_col) = c((str_extract(file_path, "[0-9]+")))
      run = cbind(run, new_col)
      
      new_col = temp["time_patch"]
      colnames(new_col) = c((str_extract(file_path, "[0-9]+")))
      run_patch = cbind(run_patch, new_col)
      
      new_col = temp["time_drop"]
      colnames(new_col) = c((str_extract(file_path, "[0-9]+")))
      run_drop = cbind(run_drop, new_col)
    }
    
  }
  
  time = apply(run, 1, mean)
  time_patch = apply(run_patch, 1, mean)
  time_drop = apply(run_drop, 1, mean)
  
  value = list(tick = tick, drops = drops, time = time, time_patch = time_patch, time_drop = time_drop, run = run, run_patch = run_patch, run_drop = run_drop)
  class(value) = "compile_run_test"
  value
}


compile_run_test_with_splitTimerUltra = function(folder_path) {
  files_path = list.files(folder_path)[regexpr('run[0-9]+.csv', list.files(folder_path))==TRUE]
  tick = NULL
  drops = NULL
  run = NULL
  run_patch = NULL
  run_drop = NULL
  for (file_path in files_path) {
    print(paste(folder_path,file_path,sep=""))
    temp = read.csv(paste(folder_path,file_path,sep = ""), row.names = 1, header = TRUE, sep = ";")
    if (is.null(tick) || is.null(drops) || is.null(run)) {
      tick = rownames(temp)
      drops = temp[["drops"]]
      run = as.matrix(temp["time"], ncol = 1)
      colnames(run) = c((str_extract(file_path, "[0-9]+")))
      
      run_patch = as.matrix(temp["time_patch"], ncol = 1)
      colnames(run_patch) = c((str_extract(file_path, "[0-9]+")))
      run_drop = as.matrix(temp["time_drop"], ncol = 1)
      colnames(run_drop) = c((str_extract(file_path, "[0-9]+")))
      
      run_patch_getLocation = as.matrix(temp["time_patch_getLocation"], ncol = 1)
      colnames(run_patch_getLocation) = c((str_extract(file_path, "[0-9]+")))
      run_patch_dropsHere = as.matrix(temp["time_patch_dropsHere"], ncol = 1)
      colnames(run_patch_dropsHere) = c((str_extract(file_path, "[0-9]+")))
      run_patch_actions = as.matrix(temp["time_patch_actions"], ncol = 1)
      colnames(run_patch_actions) = c((str_extract(file_path, "[0-9]+")))
      run_drop_getLocation = as.matrix(temp["time_drop_getLocation"], ncol = 1)
      colnames(run_drop_getLocation) = c((str_extract(file_path, "[0-9]+")))
      run_drop_patchHere = as.matrix(temp["time_drop_patchHere"], ncol = 1)
      colnames(run_drop_patchHere) = c((str_extract(file_path, "[0-9]+")))
      run_drop_remove = as.matrix(temp["time_drop_remove"], ncol = 1)
      colnames(run_drop_remove) = c((str_extract(file_path, "[0-9]+")))
      run_drop_move = as.matrix(temp["time_drop_move"], ncol = 1)
      colnames(run_drop_move) = c((str_extract(file_path, "[0-9]+")))
    }
    else {
      if (any(tick != rownames(temp))) {
        stop(paste("Ticks number inconsistency: \"",file_path,"\"",sep=""))
      }
      if (any(drops != temp["drops"])) {
        stop(paste("Drops number inconsistency: \"",file_path,"\"",sep=""))
      }
      new_col = temp["time"]
      colnames(new_col) = c((str_extract(file_path, "[0-9]+")))
      run = cbind(run, new_col)
      
      new_col = temp["time_patch"]
      colnames(new_col) = c((str_extract(file_path, "[0-9]+")))
      run_patch = cbind(run_patch, new_col)
      
      new_col = temp["time_drop"]
      colnames(new_col) = c((str_extract(file_path, "[0-9]+")))
      run_drop = cbind(run_drop, new_col)
      
      new_col = temp["time_patch_getLocation"]
      colnames(new_col) = c((str_extract(file_path, "[0-9]+")))
      run_patch_getLocation = cbind(run_patch_getLocation, new_col)
      
      new_col = temp["time_patch_dropsHere"]
      colnames(new_col) = c((str_extract(file_path, "[0-9]+")))
      run_patch_dropsHere = cbind(run_patch_dropsHere, new_col)
      
      new_col = temp["time_patch_actions"]
      colnames(new_col) = c((str_extract(file_path, "[0-9]+")))
      run_patch_actions = cbind(run_patch_actions, new_col)
      
      new_col = temp["time_drop_getLocation"]
      colnames(new_col) = c((str_extract(file_path, "[0-9]+")))
      run_drop_getLocation = cbind(run_drop_getLocation, new_col)
      
      new_col = temp["time_drop_patchHere"]
      colnames(new_col) = c((str_extract(file_path, "[0-9]+")))
      run_drop_patchHere = cbind(run_drop_patchHere, new_col)
      
      new_col = temp["time_drop_remove"]
      colnames(new_col) = c((str_extract(file_path, "[0-9]+")))
      run_drop_remove = cbind(run_drop_remove, new_col)
      
      new_col = temp["time_drop_move"]
      colnames(new_col) = c((str_extract(file_path, "[0-9]+")))
      run_drop_move = cbind(run_drop_move, new_col)
    }
    
  }
  
  time = apply(run, 1, mean)
  time_patch = apply(run_patch, 1, mean)
  time_drop = apply(run_drop, 1, mean)
  
  time_patch_getLocation = apply(run_patch_getLocation, 1, mean)
  time_patch_dropsHere = apply(run_patch_dropsHere, 1, mean)
  time_patch_actions = apply(run_patch_actions, 1, mean)
  time_drop_getLocation = apply(run_drop_getLocation, 1, mean)
  time_drop_patchHere = apply(run_drop_patchHere, 1, mean)
  time_drop_remove = apply(run_drop_remove, 1, mean)
  time_drop_move = apply(run_drop_move, 1, mean)
  
  
  value = list(tick = tick, drops = drops, time = time, time_patch = time_patch, time_drop = time_drop, run = run, run_patch = run_patch, run_drop = run_drop, run_patch_getLocation = run_patch_getLocation, run_patch_dropsHere = run_patch_dropsHere, run_patch_actions = run_patch_actions, run_drop_getLocation = run_drop_getLocation, run_drop_patchHere = run_drop_patchHere, run_drop_remove = run_drop_remove,  run_drop_move = run_drop_move, time_patch_getLocation = time_patch_getLocation, time_patch_dropsHere = time_patch_dropsHere, time_patch_actions = time_patch_actions, time_drop_getLocation = time_drop_getLocation, time_drop_patchHere = time_drop_patchHere, time_drop_remove = time_drop_remove,  time_drop_move = time_drop_move)
  class(value) = "compile_run_test"
  value
}


plot.compile_run_test = function(obj, yaxis = "time", with.sd = FALSE, col = "black", col.sd = NULL, type = "l", type.sd = "l", xlab = "Ticks", ylab = "Temps (ms)", ylim = NULL, ...){
  max_value = max(obj[[yaxis]])
  
  if (with.sd) {
    suffixe = str_extract(yaxis, "_([a-z]*[A-Z]*[0-9]*)*")
    run_x = obj[[paste("run", (if(is.na(suffixe)) "" else suffixe), sep="")]]
    if (!is.null(run_x)) {
      error_margin = apply(run_x, 1, sd)
      sd_sup = obj[[yaxis]] + error_margin
      sd_inf = obj[[yaxis]] - error_margin
      max_value = max(max_value, max(sd_sup))
      
      if (is.null(col.sd)) {
        main_col = col2rgb(col)
        col.sd = rgb(main_col["red",], main_col["green",], main_col["blue",], maxColorValue = 255, alpha = 255*0.2)
      }
    }
    else {
      with.sd = FALSE
    }
  }
  
  if (is.null(ylim)) {ylim = c(0,max_value)}
  
  if (with.sd) {
    plot(obj$tick, sd_sup, type = type.sd, col = col.sd, xlab = xlab, ylab = ylab, ylim = ylim, ...)
    par(new=TRUE)
    plot(obj$tick, sd_inf, type = type.sd, col = col.sd, xlab = xlab, ylab = ylab, ylim = ylim, ...)
    par(new=TRUE)
  }
  plot(obj$tick, obj[[yaxis]], type = type, col = col, xlab = xlab, ylab = ylab, ylim = ylim, ...)
}


plotMultipleRunTest = function(listOfRunTest, attributeOnY = "time", with.sd = FALSE, col = "black" , pch = 3, lty = 1, ylim = NULL, main = "", xlab = "", ylab = "", sub = "", default.ymin = 0, ...) {
  attributeOnY = rep(attributeOnY, length.out = length(listOfRunTest))
  with.sd = rep(with.sd, length.out = length(listOfRunTest))
  col = rep(col, length.out = length(listOfRunTest))
  pch = rep(pch, length.out = length(listOfRunTest))
  lty = rep(lty, length.out = length(listOfRunTest))
  
  if (is.null(ylim)) {
    y_max = NULL
    y_min = default.ymin

    for (i in 1:length(listOfRunTest)) {
      y_values = as.double(listOfRunTest[[i]][[attributeOnY[i]]])
      y_max = max(y_values, y_max)
      y_min = min(y_values, y_min)
    }
    ylim = c(y_min, y_max)
  }

  plot(listOfRunTest[[1]], yaxis = attributeOnY[1], with.sd = with.sd[1], col = col[1], pch = pch[1], lty = lty[1], ylim = ylim, main = main, xlab = xlab, ylab = ylab, ...)
  mtext(sub, side = 3, line = 0.5)
  for (i in 2:length(listOfRunTest)) {
    par(new=TRUE)
    plot(listOfRunTest[[i]], yaxis = attributeOnY[i], with.sd = with.sd[i], col = col[i], pch = pch[i], lty = lty[i], ylim = ylim, main = "", xlab = "", ylab = "", ...)
  }
}

###########################
                                                                               
 #####                                                                         
#     #  ####  #    # #####  #    # ##### ######    #####    ##   #####   ##   
#       #    # ##  ## #    # #    #   #   #         #    #  #  #    #    #  #  
#       #    # # ## # #    # #    #   #   #####     #    # #    #   #   #    # 
#       #    # #    # #####  #    #   #   #         #    # ######   #   ###### 
#     # #    # #    # #      #    #   #   #         #    # #    #   #   #    # 
 #####   ####  #    # #       ####    #   ######    #####  #    #   #   #    # 
                                                                              
###########################

# Runs (x10) la Bouderie [200 cycles] (with mergeDrops)
NETLOGO_BOUDERIE = compile_run_test("./NETLOGO/laBouderie/")
GAMA_BOUDERIE = compile_run_test("./GAMA/laBouderie/")
REPAST_JAVA_BOUDERIE = compile_run_test("./REPAST_SIMPHONY_JAVA/laBouderie/")

# Runs (x10) la Lingèvres [200 cycles] (with mergeDrops)
NETLOGO_LINGEVRES = compile_run_test("./NETLOGO/laLingevres/")
GAMA_LINGEVRES = compile_run_test("./GAMA/laLingevres/")

# Runs (x10) la Bouderie [200 cycles] (without mergeDrops)
NETLOGO_BOUDERIE_WITHOUT_MERGEDROPS = compile_run_test("./NETLOGO/laBouderie_without_mergeDrops/")
GAMA_BOUDERIE_WITHOUT_MERGEDROPS = compile_run_test("./GAMA/laBouderie_without_mergeDrops/")
REPAST_JAVA_BOUDERIE_WITHOUT_MERGEDROPS = compile_run_test("./REPAST_SIMPHONY_JAVA/laBouderie_without_mergeDrops/")

# Runs (x20) la Bouderie [300 cycles] (without mergeDrops)
NETLOGO_BOUDERIE_2_WITH_MERGEDROPS = compile_run_test("./NETLOGO/laBouderie_with_mergeDrops_300cycles/")
GAMA_BOUDERIE_2_WITH_MERGEDROPS = compile_run_test("./GAMA/laBouderie_with_mergeDrops_300cycles/")
REPAST_JAVA_BOUDERIE_2_WITH_MERGEDROPS = compile_run_test("./REPAST_SIMPHONY_JAVA/laBouderie_with_mergeDrops_300cycles/")

# Runs (x20) la Bouderie [300 cycles] (without mergeDrops)
NETLOGO_BOUDERIE_2_WITHOUT_MERGEDROPS = compile_run_test("./NETLOGO/laBouderie_without_mergeDrops_300cycles/")
GAMA_BOUDERIE_2_WITHOUT_MERGEDROPS = compile_run_test("./GAMA/laBouderie_without_mergeDrops_300cycles/")
REPAST_JAVA_BOUDERIE_2_WITHOUT_MERGEDROPS = compile_run_test("./REPAST_SIMPHONY_JAVA/laBouderie_without_mergeDrops_300cycles/")

# Runs (x5) la Bouderie [300 cycles] (with mergeDrops, execution time decomposition)
NETLOGO_BOUDERIE_splitTimer = compile_run_test_with_splitTimer("./NETLOGO/laBouderie_splitTimer/")
GAMA_BOUDERIE_splitTimer = compile_run_test_with_splitTimer("./GAMA/laBouderie_splitTimer/")
REPAST_JAVA_BOUDERIE_splitTimer = compile_run_test_with_splitTimer("./REPAST_SIMPHONY_JAVA/laBouderie_splitTimer/")

# Runs (x5) la Bouderie [300 cycles] (with mergeDrops, execution time decomposition)
NETLOGO_BOUDERIE_splitTimer_without_mergeDrops = compile_run_test_with_splitTimer("./NETLOGO/laBouderie_splitTimer_without_mergeDrops/")
# Runs (x10) "    "    "    "    "
GAMA_BOUDERIE_splitTimer_without_mergeDrops = compile_run_test_with_splitTimer("./GAMA/laBouderie_splitTimer_without_mergeDrops/")
REPAST_JAVA_BOUDERIE_splitTimer_without_mergeDrops = compile_run_test_with_splitTimer("./REPAST_SIMPHONY_JAVA/laBouderie_splitTimer_without_mergeDrops/")

# Runs (x10) la Bouderie [300 cycles] (with mergeDrops, execution time decomposition, without visual rendering)
NETLOGO_BOUDERIE_splitTimer_without_mergeDrops_noViz = compile_run_test_with_splitTimer("./NETLOGO/laBouderie_splitTimer_without_mergeDrops_noViz/")
GAMA_BOUDERIE_splitTimer_without_mergeDrops_noViz = compile_run_test_with_splitTimer("./GAMA/laBouderie_splitTimer_without_mergeDrops_noViz/")
REPAST_JAVA_BOUDERIE_splitTimer_without_mergeDrops_noViz = compile_run_test_with_splitTimer("./REPAST_SIMPHONY_JAVA/laBouderie_splitTimer_without_mergeDrops_noViz/")

# Runs (x10) la Bouderie [300 cycles] (without mergeDrops, execution time decomposition, without visual rendering)
NETLOGO_BOUDERIE_splitTimer_noViz = compile_run_test_with_splitTimer("./NETLOGO/laBouderie_splitTimer_noViz/")
REPAST_JAVA_BOUDERIE_splitTimer_noViz = compile_run_test_with_splitTimer("./REPAST_SIMPHONY_JAVA/laBouderie_splitTimer_noViz/")

# Runs (x10) la Bouderie [300 cycles] (without mergeDrops, execution time decomposition, conditional move)
NETLOGO_BOUDERIE_splitTimer_without_mergeDrops_conditionalMove = compile_run_test_with_splitTimer("./NETLOGO/laBouderie_splitTimer_without_mergeDrops_conditionalMove/")
GAMA_BOUDERIE_splitTimer_without_mergeDrops_conditionalMove = compile_run_test_with_splitTimer("./GAMA/laBouderie_splitTimer_without_mergeDrops_conditionalMove/")
REPAST_JAVA_BOUDERIE_splitTimer_without_mergeDrops_conditionalMove = compile_run_test_with_splitTimer("./REPAST_SIMPHONY_JAVA/laBouderie_splitTimer_without_mergeDrops_conditionalMove/")

# Runs (x10) la Bouderie [300 cycles] (with mergeDrops, execution time decomposition)
REPAST_JAVA_BOUDERIE_splitTimerUltra = compile_run_test_with_splitTimerUltra("./REPAST_SIMPHONY_JAVA/laBouderie_splitTimerUltra/")

# Runs (x10) la Bouderie [300 cycles] (without mergeDrops, execution time decomposition)
REPAST_JAVA_BOUDERIE_splitTimerUltra_without_mergeDrops = compile_run_test_with_splitTimerUltra("./REPAST_SIMPHONY_JAVA/laBouderie_splitTimerUltra_without_mergeDrops/")

# Runs (x10) la Bouderie [300 cycles] (without mergeDrops, execution time decomposition, without visual rendering)
REPAST_JAVA_BOUDERIE_splitTimerUltra_without_mergeDrops_noViz = compile_run_test_with_splitTimerUltra("./REPAST_SIMPHONY_JAVA/laBouderie_splitTimerUltra_without_mergeDrops_noViz/")

# Runs (x3) la Lingèvres [200 cycles] (with mergeDrops, execution time decomposition)
NETLOGO_LINGEVRES_splitTimer = compile_run_test("./NETLOGO/laLingevres_splitTimer/")
REPAST_JAVA_LINGEVRES_splitTimer = compile_run_test("./REPAST_SIMPHONY_JAVA/laLingevres_splitTimer/")
REPAST_JAVA_LINGEVRES_splitTimer_opti = compile_run_test("./REPAST_SIMPHONY_JAVA/laLingevres_splitTimer_opti/")

# Runs (x3) la Lingèvres [200 cycles] (without mergeDrops, execution time decomposition, without visual rendering)
NETLOGO_LINGEVRES_splitTimer_noViz = compile_run_test("./NETLOGO/laLingevres_splitTimer_noViz/")
REPAST_JAVA_LINGEVRES_splitTimer_noViz = compile_run_test("./REPAST_SIMPHONY_JAVA/laLingevres_splitTimer_noViz/")
REPAST_JAVA_LINGEVRES_splitTimer_noViz_opti = compile_run_test("./REPAST_SIMPHONY_JAVA/laLingevres_splitTimer_noViz_opti/")

###########################
                                                 
 #####                                           
#     #  ####  #    # #####  #    # ##### ###### 
#       #    # ##  ## #    # #    #   #   #      
#       #    # # ## # #    # #    #   #   #####  
#       #    # #    # #####  #    #   #   #      
#     # #    # #    # #      #    #   #   #      
 #####   ####  #    # #       ####    #   ###### 
                                                 
                                            
###### #  ####  #    # #####  ######  ####  
#      # #    # #    # #    # #      #      
#####  # #      #    # #    # #####   ####  
#      # #  ### #    # #####  #           # 
#      # #    # #    # #   #  #      #    # 
#      #  ####   ####  #    # ######  ####  
                                            
###########################

# Figure 1: Elapsed time (ms) with NetLogo Bouderie with and without merging drops

jpeg("IMG/figure_1.jpg", width = 1200, height = 600)

par(mfrow=c(2,1))

plot(NETLOGO_BOUDERIE_splitTimer,
     with.sd = TRUE, 
     col = "#F44336", 
     main = "NetLogo / La Bouderie",
     ylab = "Time (ms)",
     xlim = c(0, 200),
     ylim = c(0, 250),
     xaxp  = c(0, 200, 10),
     yaxp  = c(0, 250, 10)
)

plot(NETLOGO_BOUDERIE_splitTimer_without_mergeDrops_conditionalMove, 
     with.sd = TRUE, 
     col = "#F44336", 
     main = "NetLogo / La Bouderie without merging AgentDrops",
     ylab = "Time (ms)",
     xlim = c(0, 200),
     ylim = c(0, 250),
     xaxp  = c(0, 200, 10),
     yaxp  = c(0, 250, 10)
)

dev.off()

# Figure 2: Number of AgentDrops with NetLogo Bouderie with and without merging drops

jpeg("IMG/figure_2.jpg", width = 1200, height = 600)

par(mfrow=c(1,2))

plot(NETLOGO_BOUDERIE_splitTimer$drops[0:151], 
     col = "#1976D2", 
     main = "NetLogo / La Bouderie",
     xlab = "Ticks",
     ylab = "Number of AgentDrops",
     ylim = c(0, 45000),
     type = "p",
     xaxp  = c(0, 150, 10)

)
plot(NETLOGO_BOUDERIE_splitTimer_without_mergeDrops$drops[0:151], 
     col = "#1976D2", 
     main = "NetLogo / La Bouderie without merging AgentDrops",
     xlab = "Ticks",
     ylab = "Number of AgentDrops",
     ylim = c(0, 45000),
     type = "p",
     xaxp  = c(0, 150, 10)
)

dev.off()

# Figure 3: Comparison of the three platform both on La Bouderie and Lingèvres (elapsed time in ms. vs. ticks)

jpeg("IMG/figure_3.jpg", width = 1200, height = 600)

par(mfrow=c(1,2))
plotMultipleRunTest(
  main = "La Bouderie",
  listOfRunTest = list(GAMA_BOUDERIE, REPAST_JAVA_BOUDERIE, NETLOGO_BOUDERIE),
  col = c("#FFC107", "#671611", "#F44336"),
  xlab = "Ticks", ylab = "Time (ms)",
  xaxp  = c(0, 200, 20),
  with.sd = TRUE
)
legend("topright", inset=.02, c("NetLogo", "GAMA", "Repast Simphony"), fill=c("#F44336", "#FFC107", "#671611"), horiz=FALSE, cex=1, text.width = 40)

plotMultipleRunTest(
  main = "La Lingèvres",
  listOfRunTest = list(REPAST_JAVA_LINGEVRES_splitTimer, GAMA_LINGEVRES, NETLOGO_LINGEVRES),
  col = c("#671611", "#FFC107", "#F44336"),
  xlab = "Ticks", ylab = "Time (ms)",
  xaxp  = c(0, 200, 20),
  with.sd = TRUE
)
legend("topright", inset=.02, c("NetLogo", "GAMA", "Repast Simphony"), fill=c("#F44336", "#FFC107", "#671611"), horiz=FALSE, cex=1, text.width = 40)

dev.off()

# Figure 4: Decomposition of the execution time with NetLogo Bouderie

jpeg("IMG/figure_4.jpg", width = 1200, height = 600)

barplot(
  matrix(
    c(NETLOGO_BOUDERIE_splitTimer$time_other,NETLOGO_BOUDERIE_splitTimer$time_patch, NETLOGO_BOUDERIE_splitTimer$time_drop),
    ncol = length(NETLOGO_BOUDERIE_splitTimer$time),
    byrow = TRUE
  ),
  main = "NetLogo La Bouderie",
  names = NETLOGO_BOUDERIE_splitTimer$tick,
  xlab = "Ticks",
  ylab = "Time (ms)",
  xlim = c(0, 200),
  xaxp  = c(0, 200, 10),
  col = c("gray", "#7CB342", "#427CB3")
)
legend("topright", inset=.02, c("AgentDrops","Patches","Other"), fill=c("#427CB3", "#7CB342", "gray"), horiz=FALSE, cex=1, text.width = 40)

dev.off()

# Figure 5: Decomposition of the execution time with GAMA Bouderie

jpeg("IMG/figure_5.jpg", width = 1200, height = 600)

barplot(
  matrix(
    c(GAMA_BOUDERIE_splitTimer$time_other,GAMA_BOUDERIE_splitTimer$time_patch, GAMA_BOUDERIE_splitTimer$time_drop),
    ncol = length(GAMA_BOUDERIE_splitTimer$time),
    byrow = TRUE
  ),
  main = "GAMA La Bouderie",
  names = GAMA_BOUDERIE_splitTimer$tick,
  xlab = "Ticks",
  ylab = "Time (ms)",
  xlim = c(0, 200),
  xaxp  = c(0, 200, 10),
  col = c("gray", "#7CB342", "#427CB3")
)
legend("topright", inset=.02, c("AgentDrops","Patches","Other"), fill=c("#427CB3", "#7CB342", "gray"), horiz=FALSE, cex=1, text.width = 40)

dev.off()

# Figure 6: Decomposition of the execution time with Repast Bouderie

jpeg("IMG/figure_6.jpg", width = 1200, height = 600)

barplot(
  matrix(
    c(REPAST_JAVA_BOUDERIE_splitTimer$time_other,REPAST_JAVA_BOUDERIE_splitTimer$time_patch, REPAST_JAVA_BOUDERIE_splitTimer$time_drop),
    ncol = length(REPAST_JAVA_BOUDERIE_splitTimer$time),
    byrow = TRUE
  ),
  main = "Repast Simphony La Bouderie",
  names = REPAST_JAVA_BOUDERIE_splitTimer$tick,
  xlab = "Ticks",
  ylab = "Time (ms)",
  xlim = c(0, 200),
  xaxp  = c(0, 200, 10),
  col = c("gray", "#7CB342", "#427CB3")
)
legend("topright", inset=.02, c("AgentDrops","Patches","Other"), fill=c("#427CB3", "#7CB342", "gray"), horiz=FALSE, cex=1, text.width = 40)

dev.off()

# Figure 7: Comparison between NetLogo and Repast without visual rendering both on La Bouderie and Lingèvres

jpeg("IMG/figure_7.jpg", width = 1200, height = 600)

par(mfrow=c(1,2))
plotMultipleRunTest(
  main = "La Bouderie",
  listOfRunTest = list(REPAST_JAVA_BOUDERIE_splitTimer_noViz, NETLOGO_BOUDERIE_splitTimer_noViz),
  col = c("#671611", "#F44336"),
  xlab = "Ticks", ylab = "Time (ms)", xlim = c(0, 200),
  xaxp  = c(0, 200, 10),
  with.sd = TRUE
)
legend("topright", inset=.02, c("NetLogo", "Repast Simphony"), fill=c("#F44336", "#671611"), horiz=FALSE, cex=1, text.width = 40)

plotMultipleRunTest(
  main = "La Lingèvres",
  listOfRunTest = list(REPAST_JAVA_LINGEVRES_splitTimer_noViz, NETLOGO_LINGEVRES_splitTimer_noViz),
  col = c("#671611", "#F44336"),
  xlab = "Ticks", ylab = "Time (ms)", xlim = c(0, 200),
  xaxp  = c(0, 200, 10),
  with.sd = TRUE
)
legend("topright", inset=.02, c("NetLogo", "Repast Simphony"), fill=c("#F44336", "#671611"), horiz=FALSE, cex=1, text.width = 40)

dev.off()
