import ceylon.language.meta.model { Class }
shared class DefaultEdgeFactory<Vertex, Edge>(Class<Edge, [Vertex, Vertex]> klass)
    satisfies EdgeFactory<Vertex, Edge>
	given Vertex satisfies Object
    given Edge satisfies Object {

	shared actual Edge createEdge(Vertex sourceVertex, Vertex targetVertex) {
		return klass(sourceVertex, targetVertex);
	}
}