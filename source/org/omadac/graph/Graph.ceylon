import org.omadac.graph { EdgeFactory }
shared interface Graph<Vertex, Edge> 
	given Vertex satisfies Object
	given Edge satisfies Object {
	
	shared formal Set<Vertex> vertexSet;
	shared formal Set<Edge> edgeSet;

	shared formal EdgeFactory<Vertex, Edge> edgeFactory;
	
	shared formal Set<Edge> getAllEdges(Vertex sourceVertex, Vertex targetVertex);
	shared formal Edge? getEdge(Vertex sourceVertex, Vertex targetVertex);
	shared formal Boolean adjacent(Vertex sourceVertex, Vertex targetVertex);
	shared formal Boolean containsEdge(Edge edge);
	shared formal Boolean containsVertex(Vertex vertex);
	shared formal Set<Edge> edgesOf(Vertex vertex);
    shared formal Vertex getEdgeSource(Edge e);
    shared formal Vertex getEdgeTarget(Edge e);
	shared formal Float getEdgeWeight(Edge e);
}