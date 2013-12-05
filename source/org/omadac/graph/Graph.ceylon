"A graph has a set of vertices and edges. An edge has a source and a target vertex.
 
 A graph may be directed or undirected, see refinements of this interface.
 "
by("Harald Wellmann")
shared interface Graph<Vertex, Edge> 
	given Vertex satisfies Object
	given Edge satisfies Object {
	
	"The vertex set of this graph."
	shared formal Set<Vertex> vertexSet;
	
	"The edge set of this graph."
	shared formal Set<Edge> edgeSet;

    "The set of all edges connecting the given source and target vertex."
	shared formal Set<Edge> allEdges(Vertex sourceVertex, Vertex targetVertex);
    
    "Returns the fist edge (if any) connecting the given source and target vertex."
	shared formal Edge? edge(Vertex sourceVertex, Vertex targetVertex);
    
    "Are the given vertices adjacent? I.e. is there an edge connecting the given source
     and target vertex?"
	shared formal Boolean adjacent(Vertex sourceVertex, Vertex targetVertex);
    
    "Does this graph contain the given edge?"
	shared formal Boolean containsEdge(Edge edge);

	"Does this graph contain the given vertex?"
	shared formal Boolean containsVertex(Vertex vertex);
	
	"The set of all edges connected to the given vertex. The given vertex is the source
	 or target vertex of each returned edge (or even both when the edge is a loop)."
	shared formal Set<Edge> edgesOf(Vertex vertex);
    
    "The source vertex of the given edge."
    shared formal Vertex edgeSource(Edge e);

    "The target vertex of the given edge."
    shared formal Vertex edgeTarget(Edge e);

    "The weight of the given edge."
	shared formal Float edgeWeight(Edge e);
    
    "The opposite vertex of the given edge, when v is one of its vertices."
    shared default Vertex oppositeVertex(Edge e, Vertex v) {        
        Vertex source = edgeSource(e);
        Vertex target = edgeTarget(e);
        if (v == source) {
            return target;
        } else if (v == target) {
            return source;
        }
        
        "no such vertex"
        assert(false);
    }
    
    "Is the given edge incident with the given vertex? "
    shared default Boolean incident(Edge e, Vertex v) {
        return edgeSource(e) == v || edgeTarget(e) == v;
    }

    "Returns the neighbours of the given vertex. 
     A neighbour may occur twice if the graph allows parallel edges."
    shared {Vertex*} neighbours(Vertex v) {
        return edgesOf(v).map((Edge e) => oppositeVertex(e, v));
    }
}

