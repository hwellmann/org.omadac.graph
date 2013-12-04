import ceylon.language.meta.model { Class, IncompatibleTypeException }
import ceylon.collection { MutableSet, HashMap, HashSet, MutableMap }
import org.omadac.graph.impl { Specifics, DirectedEdgeContainer }

shared class SimpleDirectedGraph<Vertex, Edge>(Class<Edge, [Vertex, Vertex]> klass, EdgeFactory<Vertex, Edge> ef = DefaultEdgeFactory<Vertex, Edge>(klass), Boolean allowingLoops = false)
		extends AbstractBaseGraph<Vertex, Edge>(ef)
		satisfies DirectedGraph<Vertex, Edge>
		given Vertex satisfies Object
		given Edge satisfies Object	{


	
	shared class DirectedSpecifics(Boolean allowingLoops) 
			extends Specifics<Vertex, Edge>() {
		
		
		MutableMap<Vertex, DirectedEdgeContainer<Vertex, Edge>> vertexMapDirected = HashMap<Vertex, DirectedEdgeContainer<Vertex, Edge>>();
		
		DirectedEdgeContainer<Vertex, Edge> getEdgeContainer(Vertex vertex) {
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
			Vertex source = getEdgeSource(e);
			Vertex target = getEdgeTarget(e);
			
			getEdgeContainer(source).addOutgoingEdge(e);
			getEdgeContainer(target).addIncomingEdge(e);
		}
		
		shared actual void addVertex(Vertex v) {
			vertexMapDirected.put(v, DirectedEdgeContainer(edgeSetFactory, v));
		}
		
		shared actual void removeVertex(Vertex v) {
			vertexMapDirected.remove(v);
		}
		
		shared actual Integer degreeOf(Vertex v) {
			throw IncompatibleTypeException("");
		}
		
		shared actual Set<Edge> edgesOf(Vertex v) {
			MutableSet<Edge> inAndOut = HashSet<Edge>(getEdgeContainer(v).incomingEdges);
			inAndOut.addAll(getEdgeContainer(v).outgoingEdges);
			
			// we have two copies for each self-loop - remove one of them.
			if (allowingLoops) {
				// variable Set<Edge> loops = getAllEdges(v, v);
				
				//                for (int i = 0; i < inAndOut.size();) {
				//                    Object e = inAndOut.get(i);
				//
				//                    if (loops.contains(e)) {
				//                        inAndOut.remove(i);
				//                        loops.remove(e); // so we remove it only once
				//                    } else {
				//                        i++;
				//                    }
				//                }
			}
			
			return inAndOut;
		}
		
		shared actual Set<Edge> getAllEdges(Vertex sourceVertex, Vertex targetVertex) {
			
			if (containsVertex(sourceVertex)
					&& containsVertex(targetVertex))
			{
				MutableSet<Edge> edges = HashSet<Edge>();
				
				DirectedEdgeContainer<Vertex, Edge> ec = getEdgeContainer(sourceVertex);
				for (Edge e in ec.outgoingEdges) {
					if (getEdgeTarget(e).equals(targetVertex)) {
						edges.add(e);
					}
				}
				return LazySet(edges);
			}
			else {
				return emptySet;
			}
		}
		
		shared actual Edge? getEdge(Vertex sourceVertex, Vertex targetVertex) {
			if (containsVertex(sourceVertex)
					&& containsVertex(targetVertex)) {
				DirectedEdgeContainer<Vertex, Edge> ec = getEdgeContainer(sourceVertex);
				for (Edge e in ec.outgoingEdges) {
					if (getEdgeTarget(e).equals(targetVertex)) {
						return e;
					}
				}
			}
			return null;
		}
		
		shared actual Set<Vertex> vertexSet {
			return LazySet(vertexMapDirected.keys);
		}
		
		shared actual Integer inDegreeOf(Vertex v) => getEdgeContainer(v).incomingEdges.size;
		
		shared actual Set<Edge> incomingEdgesOf(Vertex v) => getEdgeContainer(v).incomingEdges;
		
		shared actual Integer outDegreeOf(Vertex v) => getEdgeContainer(v).outgoingEdges.size;
		
		shared actual Set<Edge> outgoingEdgesOf(Vertex v) => getEdgeContainer(v).outgoingEdges;
		
		shared actual void removeEdgeFromTouchingVertices(Edge e) {
			Vertex source = getEdgeSource(e);
			Vertex target = getEdgeTarget(e);
			
			getEdgeContainer(source).removeOutgoingEdge(e);
			getEdgeContainer(target).removeIncomingEdge(e);
		}
	}
	
	shared actual Integer inDegreeOf(Vertex v) => specifics.inDegreeOf(v);
		
	shared actual Set<Edge> incomingEdgesOf(Vertex v) => specifics.incomingEdgesOf(v);
		
	shared actual Integer outDegreeOf(Vertex v) => specifics.outDegreeOf(v);
		
	shared actual Set<Edge> outgoingEdgesOf(Vertex v) => specifics.outgoingEdgesOf(v);
	
	shared actual Specifics<Vertex,Edge> createSpecifics() => DirectedSpecifics(allowingLoops);

	
	
	
}
