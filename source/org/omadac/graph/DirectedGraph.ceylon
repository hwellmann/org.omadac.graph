shared interface DirectedGraph<Vertex, Edge> 
	satisfies Graph<Vertex, Edge> 
    given Vertex satisfies Object
	given Edge satisfies Object {
	
    shared formal Integer inDegreeOf(Vertex vertex);

    shared formal Set<Edge> incomingEdgesOf(Vertex vertex);

    shared formal Integer outDegreeOf(Vertex vertex);

    shared formal Set<Edge> outgoingEdgesOf(Vertex vertex);
}