import org.omadac.graph.collection { Heap }
import ceylon.language.meta {type}

"A [pairing heap][1] is one of the most efficient heap implementations, often exceeding
 in practice the performance of other implementations (e.g. Fibonacci heap) which should be
 superior in theory according to complexity analysis.
 
 [1]: http://en.wikipedia.org/wiki/Pairing_heap"

by("Harald Wellmann")
shared class PairingHeap<Key, Item>()
        extends AbstractHeap<Key, Item>()
        given Key satisfies Comparable<Key>
        given Item satisfies Object {
    
    alias Node => PairingHeapNode;
    
    variable Integer numItems = 0;
    variable Integer _modCount = 0;
    
    variable Node? min = null;
    
    "A tree node representing a heap entry. Each node has at most one parent and any number of children.
     The siblings of a node are represented as a double linked list by means of the previous and next members.
     The [[previous]] member has a dual function: for the first sibling, it points to the parent node.
     
     The [[smallest]] flag is used to implement the [[Heap.delete]] method in terms [[Heap.decreaseKey]]
     and [[Heap.removeFirst]]. When the [[smallest]] flag is set for a given node, it will compare
     as smallest to any other node.
     "	
    class PairingHeapNode(shared actual variable Key key, shared actual Item item) extends Object()
            satisfies HeapEntry<Key,Item>{
        
        shared variable Node? child = null; 
        shared variable Node? next = null; 
        shared variable Node? previous = null;
        shared variable Boolean smallest = false;
        
        shared Comparison compare(PairingHeapNode other) {
            if (smallest && other.smallest) {
                return equal;
            }
            
            if (smallest) {
                return smaller;
            }
            
            if (other.smallest) {
                return larger;
            }
            
            return key.compare(other.key);
        }
        
        shared Boolean ownedBy(PairingHeap<Key, Item> heap) => heap === outer;
        
    }
    
    class EntryIterator() 
            satisfies Iterator<HEntry> {
        
        variable Node? current = min;
        
        shared actual HEntry|Finished next(){
            if (exists node=current) {
                HEntry entry = node;
                current = successor(node);
                return entry;
            }
            return finished;
        }
        
        Node? successor(Node node) {
            if (exists c=node.child) {
                return c;
            }
            
            if (exists n = node.next) {
                return n;
            }
            
            variable Node succ = node;
            while (true) {
                if (exists m = outer.min, succ == m) {
                    return null;
                }
                assert (exists sp = succ.previous);
                if (exists c = sp.child, c == succ) {
                    if (exists pn = sp.next) {
                        return pn;
                    }
                    succ = sp;
                }
                else {
                    succ = sp;
                }
            }
        }
    }
    
    
    shared actual Integer size => numItems;
    shared Integer modCount => _modCount;
    
    shared actual HEntry insert(Key k, Item item) {
        Node node = PairingHeapNode(k, item);
        if (size == 0) {
            min = node;
        }
        else {
            if (exists m = min) {
                min = join(m, node);
                min?.previous = null;
            }
        }
        numItems++;
        _modCount++;
        return node;
    }
    
    
    
    shared actual void clear() {
        min = null;
        numItems = 0;
        _modCount++;
    }
    
    shared actual void decreaseKey(HEntry entry, Key k) {
        assert (holdsEntry(entry));
        
        if (is Node entry) {
            assert (! entry.key < k);
            entry.key = k;
            relink(entry);
            _modCount++;
        }
    }
    
    shared actual void delete(HEntry entry) {
        if (is Node entry, exists m=min) {
            if (entry == m) {
                removeFirst();
                return;
            }
            
            entry.smallest = true;
            relink(entry);
            removeFirst();
            entry.smallest = false;			
        }
    }
    
    shared actual Boolean holdsEntry(HEntry entry) {
        if (is Node entry) {
            return entry.ownedBy(this);
        }
        return false;
    }
    
    shared actual Iterator<HEntry> iterator() => EntryIterator();
    
    shared actual HEntry removeFirst() {
        assert (exists oldMin = min);
        if (size == 1) {
            min = null;
        }
        else {
            if (exists m = min, exists mc = m.child) {
                mc.previous = null;
                min = merge(mc);
                min?.previous = null;
                min?.next = null;
            }
        }
        numItems--;
        _modCount++;
        
        oldMin.child = null;
        oldMin.next = null;
        oldMin.previous = null;		
        return oldMin;
    }
    
    shared actual void union(Heap<Key,Item> that) {
        // both heaps must have the same type 
        assert (type(that).exactly(`PairingHeap<Key,Item>`));
        
        // redundant, but the compiler can't derive this automatically
        assert (is PairingHeap<Key, Item> that);
        
        if (exists m=min) {
            min = join(m, that.min);
        }
        else {
            min = that.min;
        }
        
        numItems += that.numItems;
        _modCount++;
        that.clear();
    }
    
    Node join(Node first, Node? second) {
        if (exists second) {
            if (first.compare(second) != smaller) {
                // Make first the child of second.
                second.previous = first.previous;
                first.previous = second;
                first.next = second.child;
                if (exists fn = first.next) {
                    fn.previous = first;
                }
                second.child = first;
                if (exists sp = second.previous) {
                    sp.next = second;
                }
                return second;				
            }
            else {
                // Make second the child of first.
                second.previous = first;
                first.next = second.next;
                if (exists fn = first.next) {
                    fn.previous = first;
                }
                
                second.next = first.child;
                if (exists sn = second.next) {
                    sn.previous = second;
                }
                
                first.child = second;
                return first;
            }
        }
        else {
            return first;
        }
    }
    
    void relink(Node entry) {
        if (exists m=min, entry != m) {
            if (exists n=entry.next) {
                n.previous = entry.previous;
            }
            if (exists ep = entry.previous ) {
                if (exists c = ep.child, c == entry) {
                    ep.child = entry.next;
                }
                else {
                    ep.next = entry.next;
                }			
            }
            entry.next = null;
            entry.previous = null;
            
            min = join(entry, min);
        }		
    }
    
    Node merge(Node other) {
        if (exists cn = other.next) {
            
            variable Node? one = other;
            variable Node? two = other.next;
            variable Node? three = other;
            
            while (exists two_ = two) {
                three = two_.next;
                assert (exists o=one);
                one = join(o,two);
                
                if (exists three_ = three) {
                    two = three_.next;
                    one = three_;
                }
                else {
                    three = one;
                    two = null;
                }
            }
            assert (exists t=three);
            
            one = t.previous;
            two = three;
            
            while (exists one_ = one)
            {
                one = join(one_, two);
                two = one;
                one = one?.previous;
            }
            
            assert (exists two_ = two);
            return two_;
        }
        else {
            return other;
        }
    }
    
    shared actual PairingHeap<Key, Item> clone {
        value copy = PairingHeap<Key, Item>();
        copy.insertAll(this);
        return copy;		
    }	
}