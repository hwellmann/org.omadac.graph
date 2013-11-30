shared interface Heap<Key, Item> satisfies Collection<Key->Item>
    given Key satisfies Comparable<Key>
	given Item satisfies Object {
	
	shared formal Object insert(Key k, Item item);
	shared formal void insertAll(Heap<Key, Item> that);
	shared formal Key->Item minimum;
	shared formal Key->Item removeMinimum();
	shared formal void decreaseKey(Object entry, Key k);
	shared formal void delete(Object entry);
	shared formal void union(Heap<Key, Item> that);
	shared formal void clear();
	shared formal Boolean holdsEntry(Object entry);
}