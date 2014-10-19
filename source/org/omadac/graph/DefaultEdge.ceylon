
shared class DefaultEdge<Vertex>(Vertex source, Vertex target)
    extends MutableEdge<Vertex>(source, target)
	given Vertex satisfies Object {
	
	shared actual String string => "(``source``:``target``)"; 				
}