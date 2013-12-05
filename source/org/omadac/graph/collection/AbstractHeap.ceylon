"Abstract base class for [[Heap]] implementations."
by("Harald Wellmann")
shared abstract class AbstractHeap<Key, Item>()
        satisfies Heap<Key, Item>
        given Key satisfies Comparable<Key>
        given Item satisfies Object {
    
    shared alias HEntry => HeapEntry<Key,Item>;
    
    shared actual void insertAll({HEntry*} that) {
        for (HEntry entry in that)	{
            insert(entry.key, entry.item);
        }
    }	
}
