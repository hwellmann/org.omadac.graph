import ceylon.collection { MutableSet }
import org.omadac.graph { EdgeSetFactory }
shared class DirectedEdgeContainer<Vertex, Edge>(EdgeSetFactory<Vertex, Edge> edgeSetFactory, Vertex vertex) 
        given Vertex satisfies Object
        given Edge satisfies Object {
    
    MutableSet<Edge> incoming = edgeSetFactory.createEdgeSet(vertex);
    MutableSet<Edge> outgoing = edgeSetFactory.createEdgeSet(vertex);
    
    shared void addIncomingEdge(Edge e) {
        incoming.add(e);
    }
    
    shared void removeIncomingEdge(Edge e) {
        incoming.remove(e);
    }
    
    shared void addOutgoingEdge(Edge e) {
        outgoing.add(e);
    }
    
    shared void removeOutgoingEdge(Edge e) {
        outgoing.remove(e);
    }
    
    shared Set<Edge> incomingEdges {
        return incoming;
    }
    
    shared Set<Edge> outgoingEdges {
        return outgoing;
    }
}

