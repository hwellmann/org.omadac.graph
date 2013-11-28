shared interface MutableGraph<Vertex, Edge> 
	satisfies Graph<Vertex, Edge> 
	given Vertex satisfies Object
	given Edge satisfies Object {
	
	shared formal Edge? createEdge(Vertex sourceVertex, Vertex targetVertex);
	shared formal Boolean addEdge(Vertex sourceVertex, Vertex targetVertex, Edge edge);
	shared formal Boolean addVertex(Vertex v);
	shared formal Boolean removeAllEdges({Edge*} edges);
	shared formal Set<Edge> removeAllIncidentEdges(Vertex sourceVertex, Vertex targetVertex);
	
	shared formal Boolean removeAllVertices({Vertex*} vertices);

    shared formal Edge? removeIncidentEdge(Vertex sourceVertex, Vertex targetVertex);
    shared formal Boolean removeEdge(Edge edge);
    shared formal Boolean removeVertex(Vertex vertex);
}