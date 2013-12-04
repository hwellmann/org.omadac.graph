import ceylon.test {
	test,
	assertTrue,
	assertEquals,
	assertFalse,
	assertNull,
	assertNotNull
}

import org.omadac.graph {
	DefaultEdge,
	DirectedMultigraph
}


class DirectedMultigraphTest() {
	
	DirectedMultigraph<Integer,DefaultEdge<Integer>> g = DirectedMultigraph(`DefaultEdge<Integer>`); 
	
	shared test void newGraphShouldHaveNoVertices() {		
		assertTrue(g.vertexSet.empty);
	}	

	shared test void newGraphShouldHaveNoEdges() {		
		assertTrue(g.edgeSet.empty);
	}
	
	shared test void addDisconnectedVertices() {
		g.addVertex(10);
		g.addVertex(20);
		assertEquals(2, g.vertexSet.size);
		assertTrue(g.edgeSet.empty);
		assertTrue(g.containsVertex(10));
		assertTrue(g.containsVertex(20));
	}
	
	shared test void addSingleEdge() {
		g.addVertex(10);
		g.addVertex(20);
		value e = g.createEdge(10, 20);
		if (exists edge = e) {
			assertEquals(10, g.edgeSource(edge));
			assertEquals(20, g.edgeTarget(edge));
		}
		else {
			assertFalse(true);
		}
	}
	
	shared test void reverseEdgeShouldNotExist() {
		g.addVertex(10);
		g.addVertex(20);
		g.createEdge(10, 20);
		assertNotNull(g.edge(10, 20));
		assertNull(g.edge(20, 10));
	}
	
	
	shared test void removingVertexShouldRemoveEdge() {
		g.addVertex(10);
		g.addVertex(20);
		g.createEdge(10, 20);
		g.removeVertex(10);
		assertFalse(g.containsVertex(10));
		assertTrue(g.containsVertex(20));
		assertNull(g.edge(10, 20));
		assertTrue(g.edgeSet.empty);		 
	}
	
	shared test void removingEdgeShouldNotRemoveVertices() {
		g.addVertex(10);
		g.addVertex(20);
		value e = g.createEdge(10, 20);
		if (exists edge = e) {
			assertTrue(g.removeEdge(edge));
			assertTrue(g.edgeSet.empty);		 
			assertTrue(g.containsVertex(10));
			assertTrue(g.containsVertex(20));
			assertEquals(g.vertexSet.size, 2);			
		}
		else {
			assertFalse(true);
		}
	}
	
	shared test void shouldAllowParallelEdges() {
		g.addVertex(10);
		g.addVertex(20);
		g.createEdge(10, 20);
		assertNotNull(g.createEdge(10, 20));
		assertEquals(g.edgeSet.size, 2);			
		assertEquals(g.allEdges(10, 20).size, 2);			
		assertTrue(g.allEdges(20, 10).empty);			
	}	
}