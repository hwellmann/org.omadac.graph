import ceylon.collection { MutableSet }
import org.omadac.graph { EdgeSetFactory }
shared class UndirectedEdgeContainer<Vertex, Edge>(EdgeSetFactory<Vertex, Edge> edgeSetFactory, Vertex vertex) 
		given Vertex satisfies Object
		given Edge satisfies Object {
	
	shared MutableSet<Edge> edges = edgeSetFactory.createEdgeSet(vertex);
	
	shared void addEdge(Edge e) {
		edges.add(e);
	}
	
	shared void removeEdge(Edge e) {
		edges.remove(e);
	}
	
	shared Integer edgeCount => edges.size;	
}

