import ceylon.collection { MutableSet, HashSet }
shared class DefaultEdgeSetFactory<Vertex, Edge>()
	satisfies EdgeSetFactory<Vertex, Edge> 
	given Vertex satisfies Object
	given Edge satisfies Object {

	shared actual MutableSet<Edge> createEdgeSet(Vertex v) => HashSet<Edge>();
}