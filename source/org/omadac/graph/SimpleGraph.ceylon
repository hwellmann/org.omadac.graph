import org.omadac.graph.impl {
	Specifics
}

shared class SimpleGraph<Vertex, Edge>(Edge edgeFactory(Vertex s, Vertex t))
		extends AbstractUndirectedGraph<Vertex, Edge>(edgeFactory)
		satisfies UndirectedGraph<Vertex, Edge>
		given Vertex satisfies Object
		given Edge satisfies Object	{
	
	shared class SimpleGraphSpecifics(Boolean allowingLoops) 
			extends UndirectedSpecifics() {
		
		
		shared actual Integer degreeOf(Vertex v) => edgeContainer(v).edgeCount;
	}	
	
	shared actual Specifics<Vertex,Edge> createSpecifics() => SimpleGraphSpecifics(allowingLoops);
}
