shared interface EdgeFactory<Vertex, Edge> {
	shared formal Edge createEdge(Vertex sourceVertex, Vertex targetVertex);	
}