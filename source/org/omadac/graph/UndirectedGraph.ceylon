"In an undirected graph, edges can be traversed in both direction, from source
 to target of from target to source. Incoming and outgoing edges of a vertex cannot
 be distinguished."
by("Harald Wellmann")
shared interface UndirectedGraph<Vertex, Edge> 
	satisfies Graph<Vertex, Edge> 
		given Vertex satisfies Object
		given Edge satisfies Object {
	
	"The number of edges incident with the given vertex."
	shared formal Integer degreeOf(Vertex vertex);
	
}