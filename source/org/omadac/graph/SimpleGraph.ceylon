import org.omadac.graph {
	EdgeFactory,
	AbstractBaseGraph
}
import ceylon.language.meta.model { Class, IncompatibleTypeException }
import ceylon.collection { HashMap, MutableMap }
import org.omadac.graph.impl { Specifics, UndirectedEdgeContainer }

shared class SimpleGraph<Vertex, Edge>(Class<Edge, [Vertex, Vertex]> klass, EdgeFactory<Vertex, Edge> ef = DefaultEdgeFactory<Vertex, Edge>(klass))
		extends AbstractBaseGraph<Vertex, Edge>(ef)
		satisfies UndirectedGraph<Vertex, Edge>
		given Vertex satisfies Object
		given Edge satisfies Object	{
	
	shared actual Integer degreeOf(Vertex v) {
		return specifics.degreeOf(v);
	}
	
	shared class UndirectedSpecifics(Boolean allowingLoops) 
			extends Specifics<Vertex, Edge>() {
		
		
		MutableMap<Vertex, UndirectedEdgeContainer<Vertex, Edge>> vertexMapDirected = HashMap<Vertex, UndirectedEdgeContainer<Vertex, Edge>>();
		
		UndirectedEdgeContainer<Vertex, Edge> getEdgeContainer(Vertex vertex) {
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
			
			getEdgeContainer(source).addEdge(e);
			
			if (!source.equals(target)) {
				getEdgeContainer(target).addEdge(e);
			}
		}
		
		shared actual void addVertex(Vertex v) {
			vertexMapDirected.put(v, UndirectedEdgeContainer(edgeSetFactory, v));
		}
		
		shared actual void removeVertex(Vertex v) {
			vertexMapDirected.remove(v);
		}
		
		shared actual Integer degreeOf(Vertex v) {
			if (allowingLoops) { // then we must count, and add loops twice
				
				//                int degree = 0;
				//                Set<E> edges = getEdgeContainer(vertex).vertexEdges;
				//
				//                for (E e : edges) {
				//                    if (getEdgeSource(e).equals(getEdgeTarget(e))) {
				//                        degree += 2;
				//                    } else {
				//                        degree += 1;
				//                    }
				//                }
				
				return 0;
			} else {
				return getEdgeContainer(v).edgeCount;
			}
		}
		
		shared actual Set<Edge> edgesOf(Vertex v) {
			return getEdgeContainer(v).edges;
		}
		
		Boolean joins(Edge e, Vertex sourceVertex, Vertex targetVertex) => sourceVertex.equals(edgeSource(e)) && targetVertex.equals(edgeTarget(e));
		
		shared actual Set<Edge> getAllEdges(Vertex sourceVertex, Vertex targetVertex) {
			
			if (containsVertex(sourceVertex) && containsVertex(targetVertex))
			{
				value ec = getEdgeContainer(sourceVertex);
				return LazySet(ec.edges.select((Edge e) => (joins(e, sourceVertex, targetVertex) || joins(e, targetVertex, sourceVertex))));
			}
			else {
				return emptySet;
			}
		}

		shared actual Edge? getEdge(Vertex sourceVertex, Vertex targetVertex) {
			if (containsVertex(sourceVertex) && containsVertex(targetVertex)) {
				value ec = getEdgeContainer(sourceVertex);
				return ec.edges.find((Edge e) => (joins(e, sourceVertex, targetVertex) || joins(e, targetVertex, sourceVertex)));
			}
			return null;
		}
		
		shared actual Set<Vertex> vertexSet {
			return LazySet(vertexMapDirected.keys);
		}
		
		shared actual Integer inDegreeOf(Vertex v) {
			throw IncompatibleTypeException("");
		}
		
		shared actual Set<Edge> incomingEdgesOf(Vertex v) {
			throw IncompatibleTypeException("");
		}
		
		shared actual Integer outDegreeOf(Vertex v) {
			throw IncompatibleTypeException("");
		}
		
		shared actual Set<Edge> outgoingEdgesOf(Vertex v) {
			throw IncompatibleTypeException("");
		}
		
		shared actual void removeEdgeFromTouchingVertices(Edge e) {
			Vertex source = edgeSource(e);
			Vertex target = edgeTarget(e);
			
			getEdgeContainer(source).removeEdge(e);
			if (!source.equals(target)) {
				getEdgeContainer(target).removeEdge(e);
			}
		}
	}
	
	
	
	shared actual Specifics<Vertex,Edge> createSpecifics() => UndirectedSpecifics(allowingLoops);
	
}
