import ceylon.collection { HashMap,  MutableMap,
	HashSet }


shared abstract class AbstractBaseGraph<Vertex, Edge> (Edge factory(Vertex s, Vertex t), 
shared Boolean allowingMultipleEdges = false, 
shared Boolean allowingLoops = false)

        extends AbstractGraph<Vertex, Edge>()
        given Vertex satisfies Object
        given Edge satisfies Object {
    
    
    shared EdgeSetFactory<Vertex, Edge> edgeSetFactory = DefaultEdgeSetFactory<Vertex, Edge>();
    
    MutableMap<Edge, MutableEdge<Vertex>> edgeMap = HashMap<Edge, MutableEdge<Vertex>>();
    
    variable Specifics<Vertex, Edge>? specifics_ = null;
    
    shared formal Specifics<Vertex, Edge> createSpecifics();
    
    shared Specifics<Vertex, Edge> specifics {
        if (exists s = specifics_) {
            return s;
        }
        value s = createSpecifics();
        specifics_ = s;
        return s;
    }
    
    shared actual Set<Edge> allEdges(Vertex source, Vertex target) {
        return specifics.allEdges(source, target);
    }
    
    shared actual Edge? edge(Vertex source, Vertex target) {
        return specifics.edge(source, target);
    }
    
    shared actual Edge? createEdge(Vertex source, Vertex target) {
        assertVertexExists(source);
        assertVertexExists(target);
        
        if (! allowingMultipleEdges && adjacent(source, target)) {
            return null;
        }
        
        if (!allowingLoops && source == target) {
            throw AssertionError("loops not allowed");
        }
        
        Edge edge = factory(source, target);
        if (containsEdge(edge)) {
            return null;
        }
        value intrusiveEdge = createMutableEdge(edge, source, target);
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
        
        if (!allowingLoops && source == target) {
            throw AssertionError("loops not allowed");
        }
        
        value mutableEdge = createMutableEdge(edge, source, target);
        edgeMap.put(edge, mutableEdge);
        specifics.addEdgeToTouchingVertices(edge);
        return true;
    }
    
    MutableEdge<Vertex> createMutableEdge(Edge e, Vertex source, Vertex target) {
        if (is MutableEdge<Vertex> e) {
            e.source = source;
            e.target = target;
            return e;
        }        
        return MutableEdge(source, target);
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
    
    shared actual Vertex edgeSource(Edge edge) {
        assert (is MutableEdge<Vertex> e = edge);
        return e.source;
    }
    
    shared actual Vertex edgeTarget(Edge edge) {
        assert (is MutableEdge<Vertex> e = edge);
        return e.target;
    }
    
    shared actual Boolean containsEdge(Edge e) {
        return edgeMap.items.contains(e);
    }
    
    shared actual Boolean containsVertex(Vertex v) {
        return specifics.vertexSet.contains(v);
    }
    
    shared actual Set<Edge> edgeSet => HashSet<Edge> { elements = edgeMap.keys; };
    
    
    shared actual Set<Edge> edgesOf(Vertex v) {
        return specifics.edgesOf(v);
    }
    
    shared actual Float edgeWeight(Edge e) {
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
        Edge? e = edge(sourceVertex, targetVertex);
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
