import ceylon.test {
	test,
	assertTrue,
	assertEquals,
	assertFalse,
	assertNull
}

import org.omadac.graph.collection {
	PairingHeap
}

import java.util { Random }

class PairingHeapTest() {
	
	shared test void createHeap() {
		PairingHeap<Integer, String> heap = PairingHeap<Integer, String>();
		assertTrue(heap.empty);
		assertEquals(heap.size, 0);
		assertNull(heap.minimum);
	}

	shared test void insertOneEntry() {
		PairingHeap<Integer, String> heap = PairingHeap<Integer, String>();
		heap.insert(10, "one");
		assertFalse(heap.empty);
		assertEquals(heap.size, 1);
		assertEquals(heap.minimum?.key, 10);
		assertEquals(heap.minimum?.item, "one");
	}
	
	shared test void insertTwoEntriesAscending() {
		PairingHeap<Integer, String> heap = PairingHeap<Integer, String>();
		heap.insert(10, "one");
		heap.insert(20, "two");
		assertFalse(heap.empty);
		assertEquals(heap.size, 2);
		assertEquals(heap.minimum?.key, 10);
		assertEquals(heap.minimum?.item, "one");
		
		value min = heap.removeMinimum();
		assertEquals(min.key, 10);
		assertEquals(min.item, "one");
		assertEquals(heap.minimum?.key, 20);
		assertEquals(heap.minimum?.item, "two");
	}

	shared test void insertTwoEntriesDescending() {
		PairingHeap<Integer, String> heap = PairingHeap<Integer, String>();
		heap.insert(20, "two");
		heap.insert(10, "one");
		assertFalse(heap.empty);
		assertEquals(heap.size, 2);
		assertEquals(heap.minimum?.key, 10);
		assertEquals(heap.minimum?.item, "one");
		
		value min = heap.removeMinimum();
		assertEquals(min.key, 10);
		assertEquals(min.item, "one");
		assertEquals(heap.minimum?.key, 20);
		assertEquals(heap.minimum?.item, "two");
	}
	
	
	shared test void insertRandomEntries() {
		PairingHeap<Integer, String> heap = PairingHeap<Integer, String>();
		Integer numEntries = 20;
		Random random = Random(42);
		for (Integer i in 1..numEntries) {
			Integer key = random.nextInt(1000);
			heap.insert(key, key.string);
			print(key);
		}
		assertFalse(heap.empty);
		assertEquals(heap.size, numEntries);
		
		variable Integer key = -1;
		while (! heap.empty) {
			value min = heap.removeMinimum();
			assertTrue(min.key >= key);
			key = min.key;
		}
	}
	
	shared test void iterate() {
		PairingHeap<Integer, String> heap = PairingHeap<Integer, String>();
		Integer numEntries = 5;
		Random random = Random(43);
		for (i in 1..numEntries) {
			Integer key = random.nextInt(1000);
			heap.insert(key, key.string);
			print(key);
		}
		assertFalse(heap.empty);
		assertEquals(heap.size, numEntries);
		
		for (entry in heap) {
			print(entry);
		}		
	}
}

