"A mutable graph is a [[Graph]] that may be modified by adding or removing vertices or edges."
by("Harald Wellmann")
shared interface MutableGraph<Vertex, Edge> 
	satisfies Graph<Vertex, Edge> 
	given Vertex satisfies Object
	given Edge satisfies Object {
	
	"Creates an edge with the given source and target vertices, if no such edge
	 exists or if the graph admits multiple edges."
	shared formal Edge? createEdge(Vertex sourceVertex, Vertex targetVertex);
	
	"Inserts the given edge between the given vertices.
	 sourceVertex must be the source vertex of the given edge, targetVertex must be 
	 its target vertex. Both vertices must belong to this graph. Returns true if
	 the edge was added or false if the given vertices are already adjacent and if 
	 the graph does not allow multiple edges. 
	 "
	shared formal Boolean addEdge(Vertex sourceVertex, Vertex targetVertex, Edge edge);
	
	"Adds the given vertex to this graph."
	shared formal Boolean addVertex(Vertex v);
	
	"Removes all given edges from this graph."
	shared formal Boolean removeAllEdges({Edge*} edges);
	
	"Removes any edges connecting the given vertices and returns the removed edges."
	shared formal Set<Edge> removeIncidentEdges(Vertex sourceVertex, Vertex targetVertex);
	
	"Removes all given vertices from this graph. This also removes any edges of these vertices."
	shared formal Boolean removeAllVertices({Vertex*} vertices);

	"Removes the first edge (if any) incident with the given source and target vertices 
	 and returns this edge. Returns null if the given edges are not connected."
    shared formal Edge? removeIncidentEdge(Vertex sourceVertex, Vertex targetVertex);
	
	"Removes the given edge from the graph and returns true. If the edge does not belong to
	 the graph, this method returns false and leaves the graph unchanged."
    shared formal Boolean removeEdge(Edge edge);
	
	"Removes the given vertex and all incident edges and return true. If the vertex does not
	 belong to the graph, this method returns false and leaves the graph unchanged."
    shared formal Boolean removeVertex(Vertex vertex);
}
