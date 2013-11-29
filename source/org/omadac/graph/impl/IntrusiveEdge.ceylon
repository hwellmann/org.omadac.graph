shared class IntrusiveEdge<Vertex>(shared variable Vertex source, shared variable Vertex target)
    satisfies Cloneable<IntrusiveEdge<Vertex>>
    given Vertex satisfies Object {

	shared actual IntrusiveEdge<Vertex> clone => IntrusiveEdge(source, target);


}