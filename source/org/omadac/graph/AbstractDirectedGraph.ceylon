import ceylon.collection {
	HashMap,
	MutableMap
}

import org.omadac.graph.impl {
	Specifics,
	DirectedEdgeContainer
}

shared abstract class AbstractDirectedGraph<Vertex, Edge>(Edge edgeFactory(Vertex s, Vertex t), Boolean allowingMultipleEdges = false, Boolean allowingLoops = false)
		extends AbstractBaseGraph<Vertex, Edge>(edgeFactory, allowingMultipleEdges, allowingLoops)
		satisfies DirectedGraph<Vertex, Edge>
		given Vertex satisfies Object
		given Edge satisfies Object	{


	
	shared abstract class DirectedSpecifics(Boolean allowingLoops) 
			extends Specifics<Vertex, Edge>() {
		
		
		MutableMap<Vertex, DirectedEdgeContainer<Vertex, Edge>> vertexMapDirected = HashMap<Vertex, DirectedEdgeContainer<Vertex, Edge>>();
		
		shared DirectedEdgeContainer<Vertex, Edge> edgeContainer(Vertex vertex) {
			assertVertexExists(vertex);
			
			DirectedEdgeContainer<Vertex, Edge>? ec = vertexMapDirected.get(vertex);
			if (exists e = ec) {
				return e;
			}
			else { 
				value container = DirectedEdgeContainer<Vertex, Edge>(edgeSetFactory, vertex);
				vertexMapDirected.put(vertex, container);
				return container;
			}
		}
		
		
		
		shared actual void addEdgeToTouchingVertices(Edge e) {
			Vertex source = edgeSource(e);
			Vertex target = edgeTarget(e);
			
			edgeContainer(source).addOutgoingEdge(e);
			edgeContainer(target).addIncomingEdge(e);
		}
		
		shared actual void addVertex(Vertex v) {
			vertexMapDirected.put(v, DirectedEdgeContainer(edgeSetFactory, v));
		}
		
		shared actual void removeVertex(Vertex v) {
			vertexMapDirected.remove(v);
		}
		
		shared actual Integer degreeOf(Vertex v) {
			throw AssertionException("");
		}
		
		shared actual Set<Edge> allEdges(Vertex sourceVertex, Vertex targetVertex) {
			
			if (containsVertex(sourceVertex) && containsVertex(targetVertex)) {
				value edges = edgeContainer(sourceVertex).outgoingEdges;
				return LazySet(edges.select((Edge e) => edgeTarget(e) == targetVertex));
			}
			else {
				return emptySet;
			}
		}
		
		shared actual Edge? edge(Vertex sourceVertex, Vertex targetVertex) {
			if (containsVertex(sourceVertex) && containsVertex(targetVertex)) {
				return edgeContainer(sourceVertex).outgoingEdges.find((Edge e) => edgeTarget(e) == targetVertex);
			}
			return null;
		}
		
		shared actual Set<Vertex> vertexSet {
			return LazySet(vertexMapDirected.keys);
		}
		
		shared actual Integer inDegreeOf(Vertex v) => edgeContainer(v).incomingEdges.size;
		
		shared actual Set<Edge> incomingEdgesOf(Vertex v) => edgeContainer(v).incomingEdges;
		
		shared actual Integer outDegreeOf(Vertex v) => edgeContainer(v).outgoingEdges.size;
		
		shared actual Set<Edge> outgoingEdgesOf(Vertex v) => edgeContainer(v).outgoingEdges;
		
		shared actual void removeEdgeFromTouchingVertices(Edge e) {
			Vertex source = edgeSource(e);
			Vertex target = edgeTarget(e);
			
			edgeContainer(source).removeOutgoingEdge(e);
			edgeContainer(target).removeIncomingEdge(e);
		}
	}
	
	shared actual Integer inDegreeOf(Vertex v) => specifics.inDegreeOf(v);
		
	shared actual Set<Edge> incomingEdgesOf(Vertex v) => specifics.incomingEdgesOf(v);
		
	shared actual Integer outDegreeOf(Vertex v) => specifics.outDegreeOf(v);
		
	shared actual Set<Edge> outgoingEdgesOf(Vertex v) => specifics.outgoingEdgesOf(v);
}
