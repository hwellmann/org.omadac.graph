shared class DefaultEdge<Vertex>(Vertex source, Vertex target)
    extends IntrusiveEdge<Vertex>(source, target)
	given Vertex satisfies Object {
	
	shared actual String string => "(``source``:``target``)"; 
				
}