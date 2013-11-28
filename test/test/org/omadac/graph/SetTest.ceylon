import ceylon.test { ... }
import ceylon.collection { ... }

	
	shared test void testEmptySet() {
		Set<String> set = HashSet<String>({"foo", "bar"});
		assertEquals(set.size, 2);
		
		if (is MutableSet<String> m=set) {
			m.add("bla");
		}
		assertEquals(set.size, 3);
	}
