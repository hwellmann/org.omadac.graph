import org.omadac.graph { Graph }
"In a directed graph, each edge can only be traversed from its source vertex to its
 target vertex. An edge s to t and an edge from t to s are two distinct edges.
 
 An incoming edge of a given vertex v has v as its target vertex.
 An outgoing edge of a given vertex v has v as its source vertex.
 "
shared interface DirectedGraph<Vertex, Edge> 
        satisfies Graph<Vertex, Edge> 
        given Vertex satisfies Object
        given Edge satisfies Object {
    
    "Number of incoming edges of the given vertex."
    shared formal Integer inDegreeOf(Vertex vertex);
    
    "Set of incoming edges of the given vertex."
    shared formal Set<Edge> incomingEdgesOf(Vertex vertex);
    
    "Number of outgoing edges of the given vertex."
    shared formal Integer outDegreeOf(Vertex vertex);
    
    "Set of outgoing edges of the given vertex."
    shared formal Set<Edge> outgoingEdgesOf(Vertex vertex);
    
    "Successors of the given vertex. 
     A successor may occur multiple times if the graph allows parallel edges."
    shared default {Vertex*} successors(Vertex vertex) {
        return outgoingEdgesOf(vertex).map((Edge edge) => oppositeVertex(edge, vertex));
    }
    
    "Predecessors of the given vertex. 
     A successor may occur multiple times if the graph allows parallel edges."
    shared default {Vertex*} predecessors(Vertex vertex) {
        return incomingEdgesOf(vertex).map((Edge edge) => oppositeVertex(edge, vertex));
    }
}