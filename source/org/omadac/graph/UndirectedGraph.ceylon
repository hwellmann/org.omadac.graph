shared interface UndirectedGraph<Vertex, Edge> 
	satisfies Graph<Vertex, Edge> 
		given Vertex satisfies Object
		given Edge satisfies Object {
	
	shared formal Integer degreeOf(Vertex vertex);
	
}