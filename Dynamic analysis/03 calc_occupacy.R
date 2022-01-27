library(igraph)

edgelist<-c()
for (i in 0:1001) {
  assign(paste("frame",i,sep = ""),
         read_graph(paste(paste("355_",i,sep=""),"_graph.gml",sep=""),format="gml"))
  edgelist<-rbind(edgelist,as_edgelist(get(paste("frame",i,sep = ""))))
}

g = graph_from_edgelist(edgelist, directed = "FALSE")
adjMat = as_adjacency_matrix(g,sparse = FALSE)
adjMat = (adjMat/1002) 
for(i in 1:nrow(adjMat)){
  for(j in 1:ncol(adjMat)){
    if(adjMat[i,j]<0.5)
      adjMat[i,j]=0
  }
}

g = graph_from_adjacency_matrix(adjMat, mode = "undirected")
write_graph(g,"../occupacy_network.ncol",format = "ncol")

