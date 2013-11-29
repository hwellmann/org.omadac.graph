import ceylon.collection { HashMap,  MutableMap }
import org.omadac.graph.impl { Specifics, IntrusiveEdge }

shared abstract class AbstractBaseGraph<Vertex, Edge> (shared actual EdgeFactory<Vertex, Edge> edgeFactory, 
shared Boolean allowingMultipleEdges = false, 
	shared Boolean allowingLoops = false)
    	
		extends AbstractGraph<Vertex, Edge>()
		given Vertex satisfies Object
    	given Edge satisfies Object {


    shared EdgeSetFactory<Vertex, Edge> edgeSetFactory = DefaultEdgeSetFactory<Vertex, Edge>();
    
    shared formal Specifics<Vertex, Edge> createSpecifics();
        
    MutableMap<Edge, IntrusiveEdge<Vertex>> edgeMap = HashMap<Edge, IntrusiveEdge<Vertex>>();
        
    variable Specifics<Vertex, Edge>? specifics_ = null;
        
    shared Specifics<Vertex, Edge> specifics {
        if (exists s = specifics_) {
            return s;
        }
        value s = createSpecifics();
        specifics_ = s;
        return s;
    }
    
    shared actual Set<Edge> getAllEdges(Vertex source, Vertex target) {
        return specifics.getAllEdges(source, target);
    }
    
    shared actual Edge? getEdge(Vertex source, Vertex target) {
        return specifics.getEdge(source, target);
    }
    
    shared actual Edge? createEdge(Vertex source, Vertex target) {
        assertVertexExists(source);
        assertVertexExists(target);
        
        if (! allowingMultipleEdges && adjacent(source, target)) {
            return null;
        }
        
        if (!allowingLoops && source.equals(target)) {
            throw AssertionException("loops not allowed");
        }
        
        Edge edge = edgeFactory.createEdge(source, target);
        if (containsEdge(edge)) {
            return null;
        }
        value intrusiveEdge = createIntrusiveEdge(edge, source, target);
        edgeMap.put(edge, intrusiveEdge);
        specifics.addEdgeToTouchingVertices(edge);
        return edge;
    }
    
    shared actual Boolean addEdge(Vertex source, Vertex target, Edge edge) {
        if (containsEdge(edge)) {
            return false;
        }
        assertVertexExists(source);
        assertVertexExists(target);
        
        if (! allowingMultipleEdges && adjacent(source, target)) {
            return false;
        }
        
        if (!allowingLoops && source.equals(target)) {
            throw AssertionException("loops not allowed");
        }
        
        value intrusiveEdge = createIntrusiveEdge(edge, source, target);
        edgeMap.put(edge, intrusiveEdge);
        specifics.addEdgeToTouchingVertices(edge);
        return true;
    }
    
    IntrusiveEdge<Vertex> createIntrusiveEdge(Edge e, Vertex source, Vertex target) {
        if (is IntrusiveEdge<Vertex> e) {
            e.source = source;
            e.target = target;
            return e;
        }        
        return IntrusiveEdge(source, target);
    }
    
    shared actual Boolean addVertex(Vertex vertex) {
        if (containsVertex(vertex)) {
            return false;
        }
        else {
            specifics.addVertex(vertex);
            return true;
        }
    }
    
    shared actual Vertex getEdgeSource(Edge edge) {
        if (is IntrusiveEdge<Vertex> edge) {
            return edge.source;
        }
        throw AssertionException("unchecked cast");
    }
    
    shared actual Vertex getEdgeTarget(Edge edge) {
        if (is IntrusiveEdge<Vertex> edge) {
            return edge.target;
        }
        throw AssertionException("unchecked cast");
    }
    
    shared actual Boolean containsEdge(Edge e) {
        return edgeMap.contains(e);
    }
    
    shared actual Boolean containsVertex(Vertex v) {
        return specifics.vertexSet.contains(v);
    }
    
    shared actual Set<Edge> edgeSet => edgeMap.keys;
    
    
    shared actual Set<Edge> edgesOf(Vertex v) {
        return specifics.edgesOf(v);
    }
    
    shared actual Float getEdgeWeight(Edge e) {
        return 1.0;
    }
    
    shared actual Boolean removeEdge(Edge edge) {
        if (containsEdge(edge)) {
            specifics.removeEdgeFromTouchingVertices(edge);
            edgeMap.remove(edge);
            return true;
        }
        else {
            return false;
        }
    }
    
    shared actual Edge? removeIncidentEdge(Vertex sourceVertex, Vertex targetVertex) {
        Edge? e = getEdge(sourceVertex, targetVertex);
        if (exists e) {
            specifics.removeEdgeFromTouchingVertices(e);
            edgeMap.remove(e);
        }
        return e;
    }
    
    shared actual Boolean removeVertex(Vertex vertex) {
        if (containsVertex(vertex)) {
            removeAllEdges(edgesOf(vertex));
            specifics.removeVertex(vertex);
            return true;
        }
        else {
            return false;
        }
    }
    
    shared actual Set<Vertex> vertexSet => specifics.vertexSet;
    
    
    
}