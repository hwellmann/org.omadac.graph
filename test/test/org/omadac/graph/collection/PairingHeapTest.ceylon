import ceylon.test {
	test,
	assertTrue,
	assertEquals,
	assertFalse,
	assertNull
}

import org.omadac.graph.collection {
	PairingHeap, HeapEntry
}

class PairingHeapTest() {
	alias Entry => HeapEntry<Integer, String>;
	
	shared test void createHeap() {
		PairingHeap<Integer, String> heap = PairingHeap<Integer, String>();
		assertTrue(heap.empty);
		assertEquals(heap.size, 0);
		assertNull(heap.first);
	}

	shared test void insertOneEntry() {
		PairingHeap<Integer, String> heap = PairingHeap<Integer, String>();
		heap.insert(10, "one");
		assertFalse(heap.empty);
		assertEquals(heap.size, 1);
		assertEquals(heap.first?.key, 10);
		assertEquals(heap.first?.item, "one");
	}
	
	shared test void insertTwoEntriesAscending() {
		PairingHeap<Integer, String> heap = PairingHeap<Integer, String>();
		heap.insert(10, "one");
		heap.insert(20, "two");
		assertFalse(heap.empty);
		assertEquals(heap.size, 2);
		assertEquals(heap.first?.key, 10);
		assertEquals(heap.first?.item, "one");
		
		value min = heap.removeFirst();
		assertEquals(min.key, 10);
		assertEquals(min.item, "one");
		assertEquals(heap.first?.key, 20);
		assertEquals(heap.first?.item, "two");
	}

	shared test void insertTwoEntriesDescending() {
		PairingHeap<Integer, String> heap = PairingHeap<Integer, String>();
		heap.insert(20, "two");
		heap.insert(10, "one");
		assertFalse(heap.empty);
		assertEquals(heap.size, 2);
		assertEquals(heap.first?.key, 10);
		assertEquals(heap.first?.item, "one");
		
		value min = heap.removeFirst();
		assertEquals(min.key, 10);
		assertEquals(min.item, "one");
		assertEquals(heap.first?.key, 20);
		assertEquals(heap.first?.item, "two");
	}
	
	
	shared test void insertRandomEntries() {
		PairingHeap<Integer, String> heap = PairingHeap<Integer, String>();
		Integer[] keys = [21, 54, 28, 38, 23, 342, 43, 32, 43, 29, 99];
		for (Integer key in keys) {
			heap.insert(key, key.string);
		}
		assertFalse(heap.empty);
		assertEquals(heap.size, keys.size);
		
		variable Integer key = -1;
		while (! heap.empty) {
			value min = heap.removeFirst();
			assertTrue(min.key >= key);
			key = min.key;
		}
	}
	
	shared test void iterate() {
		PairingHeap<Integer, String> heap = PairingHeap<Integer, String>();
		value keys = [43, 32, 43, 29, 99];
		keys.collect((Integer key) => heap.insert(key, key.string));
		assertFalse(heap.empty);
		assertEquals(heap.size, keys.size);

		assertEquals(heap.collect((Entry e) => e.key), [29, 99, 32, 43, 43]);
	}
	
	shared test void union() {
		PairingHeap<Integer, String> heap1 = PairingHeap<Integer, String>();
		heap1.insert(32, "32");
		heap1.insert(18, "18");
		PairingHeap<Integer, String> heap2 = PairingHeap<Integer, String>();
		heap2.insert(29, "29");
		heap2.insert(15, "25");
		heap2.insert(77, "77");
		heap1.union(heap2);
		
		assertTrue(heap2.empty);
		assertEquals(heap1.size, 5);
		
		assertEquals(heap1.collect((Entry e) => heap1.removeFirst().key), [15, 18, 29, 32, 77]);
	}
}

