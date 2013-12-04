import ceylon.test {
	test,
	assertTrue,
	assertEquals,
	assertFalse,
	assertNull
}

import org.omadac.graph {
	DefaultEdge,
	SimpleGraph
}


class SimpleGraphTest() {
	
	SimpleGraph<Integer,DefaultEdge<Integer>> g = SimpleGraph(`DefaultEdge<Integer>`); 
	
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
	
	shared test void reverseEdgeShouldBeEqual() {
		g.addVertex(10);
		g.addVertex(20);
		value e1 = g.createEdge(10, 20);
		value e2 = g.edge(20, 10);
		if (exists edge1 = e2, exists edge2 = e2) {
			assertEquals(e2, e1);
		}
		else {
			assertFalse(true);
		}
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
	
	shared test void shouldNotAllowParallelEdges() {
		g.addVertex(10);
		g.addVertex(20);
		g.createEdge(10, 20);
		assertNull(g.createEdge(10, 20));
		assertEquals(g.edgeSet.size, 1);			
	}
}