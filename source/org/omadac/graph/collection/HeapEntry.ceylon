shared class HeapEntry<Key, out Item>(key, item)
		extends Object()
		given Key satisfies Comparable<Key>
		given Item satisfies Object {
	
	"The key used to access the entry."
	shared variable Key key;
	
	"The value associated with the key."
	shared Item item;
	
	"A pair (2 element tuple) with the key and
	 item of this entry."
	shared [Key,Item] pair => [key,item];
	
	"Determines if this entry is equal to the given entry. 
	 Two entries are equal if they have the same key and 
	 the same value."
	shared actual Boolean equals(Object that) {
		if (is HeapEntry<Key,Object> that) {
			return this.key==that.key &&
					this.item==that.item;
		}
		else {
			return false;
		}
	}
	
	shared actual Integer hash => (31 + key.hash) * 31 + item.hash;
	
	"Returns a description of the entry in the form 
	 `key->item`."
	shared actual default String string => "``key``->``item``";
	
}
