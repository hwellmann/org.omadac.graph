shared abstract class AbstractGraph<Vertex, Edge>()
		satisfies MutableGraph<Vertex, Edge>
		given Vertex satisfies Object
		given Edge satisfies Object {

    shared actual Boolean adjacent(Vertex sourceVertex, Vertex targetVertex) {
        return edge(sourceVertex, targetVertex) exists;
    }
    
    shared actual Boolean removeAllEdges({Edge*} edges) {
        variable Boolean modified = false;

        for (Edge e in edges) {
            modified ||= removeEdge(e);
        }

        return modified;
    }

    shared actual Set<Edge> removeIncidentEdges(Vertex sourceVertex, Vertex targetVertex) {
        Set<Edge> removed = allEdges(sourceVertex, targetVertex);
        if (! removed.empty) {
            removeAllEdges(removed);
        }

        return removed;
    }

    /**
     * @see Graph#removeAllVertices(Collection)
     */
    shared actual Boolean removeAllVertices({Vertex*} vertices) {
        variable Boolean modified = false;

        for (Vertex v in vertices) {
            modified ||= removeVertex(v);
        }

        return modified;
    }
    
    shared actual String string {
        return toStringFromSets(vertexSet, edgeSet, this is DirectedGraph<Vertex, Edge>);
    }
    

	shared default Boolean assertVertexExists(Vertex v) {
		"no such vertex in graph"
		assert (containsVertex(v));
		return true;
	}
	
	shared default String toStringFromSets(Set<Vertex> vertexSet, Set<Edge> edgeSet, Boolean directed) {
		variable List<String> renderedEdges = [];
		StringBuilder sb = StringBuilder();
		for (Edge e in edgeSet) {
			sb.append(e.string);
			sb.append("=");
			if (directed) {
				sb.append("(");
			}
			else {
				sb.append("{");
			}
			sb.append(edgeSource(e).string);
			sb.append(",");
			sb.append(edgeTarget(e).string);
			if (directed) {
				sb.append(")");
			} else {
				sb.append("}");
			}
			renderedEdges.chain(sb.string);			
			sb.reset();
		}
		return "(``vertexSet``, ``renderedEdges``)";
	}


    shared actual Integer hash  {
        variable Integer hash = vertexSet.hash;
        for (Edge e in edgeSet) {
            variable Integer part = e.hash;
            Integer source = edgeSource(e).hash;
            Integer target = edgeTarget(e).hash;
            
            Integer pairing = ((source + target) * (source + target + 1)/2) + target;
            part = 27 * part + pairing;
            Integer weight = edgeWeight(e).integer;
            part = 27 * (weight.xor(weight.rightLogicalShift(32)));
            hash += part;
        }
        return hash;
    }

    shared actual Boolean equals(Object that) {
        if (this == that) {
            return true;
        }
        if (is AbstractGraph<Vertex, Edge> that) {
            if (! vertexSet.equals(that.vertexSet)) {
                return false;
            }
            
            if (! edgeSet.size == that.edgeSet.size) {
                return false;
            }
            
            for (Edge e in edgeSet) {
                if (! that.containsEdge(e)) {
                    return false;
                }
                Vertex source = edgeSource(e);
                Vertex target = edgeTarget(e);
                
                if (!that.edgeSource(e).equals(source) 
            	    || !that.edgeSource(e).equals(target)) {
                    return false;
                }
                Float diff = edgeWeight(e) - that.edgeWeight(e);
                if (diff.magnitude > 1.0E-7) {
                    return false;
                }
            }
            return true;
        }
        return false;
    }
}