shared interface Heap<Key, Item> satisfies Collection<HeapEntry<Key,Item>>
    given Key satisfies Comparable<Key>
	given Item satisfies Object {
	
	shared formal HeapEntry<Key,Item> insert(Key k, Item item);
	shared formal void insertAll(Heap<Key, Item> that);
	shared formal HeapEntry<Key,Item>? minimum;
	shared formal HeapEntry<Key,Item>? removeMinimum();
	shared formal void decreaseKey(HeapEntry<Key,Item> entry, Key k);
	shared formal void delete(HeapEntry<Key,Item> entry);
	shared formal void union(Heap<Key, Item> that);
	shared formal void clear();
	shared formal Boolean holdsEntry(HeapEntry<Key,Item> entry);
}