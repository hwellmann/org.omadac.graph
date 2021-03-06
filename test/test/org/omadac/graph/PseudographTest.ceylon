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
	Pseudograph
}


class PseudographTest() {
	alias Edge => DefaultEdge<Integer>;
	Pseudograph<Integer,DefaultEdge<Integer>> g = Pseudograph(`DefaultEdge<Integer>`); 
	
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
	
	shared test void shouldAllowParallelEdges() {
		g.addVertex(10);
		g.addVertex(20);
		g.addVertex(30);
		g.createEdge(10, 20);
		g.createEdge(20, 30);
		assertNotNull(g.createEdge(10, 20));
		assertEquals(g.edgeSet.size, 3);		
		assertEquals(g.allEdges(10, 20).size, 2);			
		assertEquals(g.allEdges(20, 10), g.allEdges(10, 20));			
	}
	
	shared test void shouldAllowLoops() {
		g.addVertex(10);
		Edge? edge = g.createEdge(10, 10);
		assert (exists edge);
		assertEquals(g.edgeSet.size, 1);
		assertEquals(g.edgeSource(edge), 10);
		assertEquals(g.edgeTarget(edge), 10);
		assertEquals(g.degreeOf(10), 2);
	}	

	shared test void shouldAllowMultipleLoops() {
		g.addVertex(10);
		Edge? edge = g.createEdge(10, 10);
		assert (exists edge);

		Edge? edge2 = g.createEdge(10, 10);
		assert (exists edge2);

		assertEquals(g.edgeSet.size, 2);
		assertEquals(g.edgeSource(edge2), 10);
		assertEquals(g.edgeTarget(edge2), 10);
		assertEquals(g.degreeOf(10), 4);
	}	
}