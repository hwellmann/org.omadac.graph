import ceylon.collection {
	MutableSet,
	HashSet
}

import org.omadac.graph.impl {
	Specifics
}

shared class DirectedMultigraph<Vertex, Edge>(Edge edgeFactory(Vertex s, Vertex t))
		extends AbstractDirectedGraph<Vertex, Edge>(edgeFactory, true)
		satisfies DirectedGraph<Vertex, Edge>
		given Vertex satisfies Object
		given Edge satisfies Object	{


	
	shared class DirectedMultigraphSpecifics() extends DirectedSpecifics(false) {
		
		
		shared actual Set<Edge> edgesOf(Vertex v) {
			MutableSet<Edge> inAndOut = HashSet(edgeContainer(v).incomingEdges);
			inAndOut.addAll(edgeContainer(v).outgoingEdges);
			
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
		
	}
	
	shared actual Specifics<Vertex,Edge> createSpecifics() => DirectedMultigraphSpecifics();
}
