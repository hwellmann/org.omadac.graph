
import org.omadac.graph { UndirectedGraph, AbstractUndirectedGraph }

shared class Multigraph<Vertex, Edge>(Edge edgeFactory(Vertex s, Vertex t))
		extends AbstractUndirectedGraph<Vertex, Edge>(edgeFactory, true)
		satisfies UndirectedGraph<Vertex, Edge>
		given Vertex satisfies Object
		given Edge satisfies Object	{
	
	shared class MultigraphSpecifics() extends UndirectedSpecifics() {
		
		shared actual Integer degreeOf(Vertex v) => edgeContainer(v).edgeCount;
	}		
	
	shared actual Specifics<Vertex,Edge> createSpecifics() => MultigraphSpecifics();	
}
	