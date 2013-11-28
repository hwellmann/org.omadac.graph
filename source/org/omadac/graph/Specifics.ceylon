shared abstract class Specifics<Vertex,Edge>()
    given Vertex satisfies Object
    given Edge satisfies Object {
	shared formal void addVertex(Vertex v);
	shared formal void removeVertex(Vertex v);
	shared formal Set<Vertex> vertexSet;
	shared formal Set<Edge> getAllEdges(Vertex sourceVertex, Vertex targetVertex);
	shared formal Edge? getEdge(Vertex sourceVertex, Vertex targetVertex);
	shared formal void addEdgeToTouchingVertices(Edge e);
	shared formal Integer degreeOf(Vertex v);
	shared formal Set<Edge> edgesOf(Vertex v);
	shared formal Integer inDegreeOf(Vertex v);
	shared formal Set<Edge> incomingEdgesOf(Vertex v);
	shared formal Integer outDegreeOf(Vertex v);
	shared formal Set<Edge> outgoingEdgesOf(Vertex v);
	shared formal void removeEdgeFromTouchingVertices(Edge e);
	
}

