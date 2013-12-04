import ceylon.collection {
	HashMap,
	MutableMap
}

import org.omadac.graph {
	AbstractBaseGraph
}
import org.omadac.graph.impl {
	Specifics,
	UndirectedEdgeContainer
}

shared abstract class AbstractUndirectedGraph<Vertex, Edge>(Edge edgeFactory(Vertex s, Vertex t), Boolean allowingMultipleEdges = false, Boolean allowingLoops = false)
		extends AbstractBaseGraph<Vertex, Edge>(edgeFactory, allowingMultipleEdges, allowingLoops)
		satisfies UndirectedGraph<Vertex, Edge>
		given Vertex satisfies Object
		given Edge satisfies Object	{
	
	shared actual Integer degreeOf(Vertex v) {
		return specifics.degreeOf(v);
	}
	
	shared abstract class UndirectedSpecifics() 
			extends Specifics<Vertex, Edge>() {
		
		
		MutableMap<Vertex, UndirectedEdgeContainer<Vertex, Edge>> vertexMapDirected = HashMap<Vertex, UndirectedEdgeContainer<Vertex, Edge>>();
		
		shared UndirectedEdgeContainer<Vertex, Edge> edgeContainer(Vertex vertex) {
			assertVertexExists(vertex);
			
			UndirectedEdgeContainer<Vertex, Edge>? ec = vertexMapDirected.get(vertex);
			if (exists e = ec) {
				return e;
			}
			else { 
				value container = UndirectedEdgeContainer<Vertex, Edge>(edgeSetFactory, vertex);
				vertexMapDirected.put(vertex, container);
				return container;
			}
		}
		
		
		
		shared actual void addEdgeToTouchingVertices(Edge e) {
			Vertex source = edgeSource(e);
			Vertex target = edgeTarget(e);
			
			edgeContainer(source).addEdge(e);
			
			if (source != target) {
				edgeContainer(target).addEdge(e);
			}
		}
		
		shared actual void addVertex(Vertex v) {
			vertexMapDirected.put(v, UndirectedEdgeContainer(edgeSetFactory, v));
		}
		
		shared actual void removeVertex(Vertex v) {
			vertexMapDirected.remove(v);
		}
		
		shared actual Set<Edge> edgesOf(Vertex v) {
			return edgeContainer(v).edges;
		}
		
		Boolean joins(Edge e, Vertex sourceVertex, Vertex targetVertex) => sourceVertex == edgeSource(e) && targetVertex == edgeTarget(e);
		
		shared actual Set<Edge> allEdges(Vertex sourceVertex, Vertex targetVertex) {
			
			if (containsVertex(sourceVertex) && containsVertex(targetVertex))
			{
				value ec = edgeContainer(sourceVertex);
				return LazySet(ec.edges.select((Edge e) => (joins(e, sourceVertex, targetVertex) || joins(e, targetVertex, sourceVertex))));
			}
			else {
				return emptySet;
			}
		}

		shared actual Edge? edge(Vertex sourceVertex, Vertex targetVertex) {
			if (containsVertex(sourceVertex) && containsVertex(targetVertex)) {
				value ec = edgeContainer(sourceVertex);
				return ec.edges.find((Edge e) => (joins(e, sourceVertex, targetVertex) || joins(e, targetVertex, sourceVertex)));
			}
			return null;
		}
		
		shared actual Set<Vertex> vertexSet {
			return LazySet(vertexMapDirected.keys);
		}
		
		shared actual Integer inDegreeOf(Vertex v) {
			throw AssertionException("");
		}
		
		shared actual Set<Edge> incomingEdgesOf(Vertex v) {
			throw AssertionException("");
		}
		
		shared actual Integer outDegreeOf(Vertex v) {
			throw AssertionException("");
		}
		
		shared actual Set<Edge> outgoingEdgesOf(Vertex v) {
			throw AssertionException("");
		}
		
		shared actual void removeEdgeFromTouchingVertices(Edge e) {
			Vertex source = edgeSource(e);
			Vertex target = edgeTarget(e);
			
			edgeContainer(source).removeEdge(e);
			if (source !=target) {
				edgeContainer(target).removeEdge(e);
			}
		}
	}
}
