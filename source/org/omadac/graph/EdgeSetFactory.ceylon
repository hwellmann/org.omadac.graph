import ceylon.collection { MutableSet }
shared interface EdgeSetFactory<Vertex, Edge> 
	given Vertex satisfies Object
    given Edge satisfies Object {

	shared formal MutableSet<Edge> createEdgeSet(Vertex v);
}
