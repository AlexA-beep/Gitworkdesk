#' @export
summarise_ithim_inputs <- function(ithim_object){
  modenames <- unlist(ithim_object$dist[,1])
  
  x11(width=10,height=10); par(mfrow=c(2,2),cex.axis=1.25,cex.lab=1.3)
  distances <- as.matrix(ithim_object$dist[,-1])
  distances_pc <- apply(distances,2,function(x)x/sum(x))
  par(mar=c(6,5,2,9)); barplot(distances_pc,col=rainbow(length(modenames)),legend.text=modenames,args.legend = c(x=length(SCEN)+5),ylab=paste0(CITY,' mode share by distance'),las=2)
  
  trips <- sapply(SCEN,function(y)sapply(modenames,function(x)nrow(subset(subset(ithim_object$trip_scen_sets,trip_mode==x&scenario==y),!duplicated(trip_id)))))
  trips <- apply(trips,2,function(x)x/sum(x))
  par(mar=c(6,5,2,9)); barplot(trips,col=rainbow(length(modenames)),legend.text=modenames,args.legend = c(x=length(SCEN)+5),ylab=paste0(CITY,' mode share by trip mode'),las=2)

  cas_modes <- unique(c(as.character(INJURY_TABLE$whw$cas_mode),as.character(INJURY_TABLE$noov$cas_mode)))
  injuries <- sapply(cas_modes,function(x)sum(subset(INJURY_TABLE$whw,cas_mode==x)$count)+sum(subset(INJURY_TABLE$noov,cas_mode==x)$count))
  injury_modes <- c('pedestrian','bicycle','car','motorcycle')
  injury_rates <- sapply(injury_modes,function(x)sum(subset(INJURY_TABLE$whw,cas_mode==x)$count)+sum(subset(INJURY_TABLE$noov,cas_mode==x)$count))/
    distances[match(c('walking','bicycle','car','motorcycle'),modenames),1]
  
  print(injuries)
  par(mar=c(8,7,2,2)); barplot(injury_rates,col=rainbow(length(injury_rates)),ylab='',las=2)
  mtext(2,line=4.5,cex=1.25,text = paste0(CITY,' injury rates'))
  
  emissions <- unlist(EMISSION_INVENTORY)
  emissions <- emissions[emissions>0]
  par(mar=c(2,5,4,5)); pie(emissions,main=paste0(CITY,' emissions'),cex=1.25)
}
