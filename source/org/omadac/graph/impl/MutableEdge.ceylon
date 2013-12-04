shared class MutableEdge<Vertex>(shared variable Vertex source, shared variable Vertex target)
    satisfies Cloneable<MutableEdge<Vertex>>
    given Vertex satisfies Object {

	shared actual MutableEdge<Vertex> clone => MutableEdge(source, target);


}