shared abstract class AbstractHeap<Key, Item>()
		satisfies Heap<Key, Item>
		given Key satisfies Comparable<Key>
		given Item satisfies Object {
	
	shared actual void insertAll(Heap<Key, Item> that) {
		for (Key->Item entry in that)	{
			insert(entry.key, entry.item);
		}
	}
	
}
