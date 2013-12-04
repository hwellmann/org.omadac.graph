import org.omadac.graph.impl {
	Specifics
}

shared class Multigraph<Vertex, Edge>(Edge edgeFactory(Vertex s, Vertex t))
		extends AbstractUndirectedGraph<Vertex, Edge>(edgeFactory, true)
		satisfies UndirectedGraph<Vertex, Edge>
		given Vertex satisfies Object
		given Edge satisfies Object	{
	
	shared class MultigraphSpecifics() extends UndirectedSpecifics() {
		
		shared actual Integer degreeOf(Vertex v) {			
			return edgeContainer(v).edges.fold(0, (Integer d, Edge e) => 
					edgeSource(e) == edgeTarget(e) then d+2 else d+1);			
		}		
	}		
	
	shared actual Specifics<Vertex,Edge> createSpecifics() => MultigraphSpecifics();	
}
