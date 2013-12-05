"A heap is a collection of entries such that each entry contains an item
 and a sortable key. Heaps can be used to sort entries efficiently by key, given
 that the [[first]] element is always the one with the minimum key, independent
 of insertion order. 
 " 
by("Harald Wellmann")
shared interface Heap<Key, Item> satisfies Collection<HeapEntry<Key,Item>>
        given Key satisfies Comparable<Key>
        given Item satisfies Object {
    
    "Inserts an entry into the heap."
    shared formal HeapEntry<Key,Item> insert(Key k, Item item);
    
    "Inserts all entries from the given Iterable into this heap."
    shared formal void insertAll({HeapEntry<Key, Item>*} that);
    
    "Removes the first entry from this heap. The key of any other item
     remaining in the heap is guaranteed to be greater than or equal to the 
     key of this entry."
    shared formal HeapEntry<Key,Item>? removeFirst();
    
    "Decreases the key of the given entry. The new key value k must not be
     greater than the current value. The given entry must be a member of this heap."
    shared formal void decreaseKey(HeapEntry<Key,Item> entry, Key k);
    
    "Deletes an entry from the heap. The given entry must be a member of this heap."
    shared formal void delete(HeapEntry<Key,Item> entry);
    
    "Merges another heap into this heap. This method does not copy any entries."
    shared formal void union(Heap<Key, Item> that);
    
    "Removes all entries from this heap."
    shared formal void clear();
    
    "Does this heap contain an entry e such that e === entry? 	 
     This condition is stronger than [[contains]] which only checks that e == entry."
    shared formal Boolean holdsEntry(HeapEntry<Key,Item> entry);
}