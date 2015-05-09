//
//  DictionarySignal.swift
//  Channel3
//
//  Created by Hoon H. on 2015/04/10.
//  Copyright (c) 2015 Eonil. All rights reserved.
//


public enum DictionarySignal<K: Hashable,V> {
	typealias	Snapshot	=	[K:V]
	typealias	Transaction	=	CollectionTransaction<K,V>
	case Initiation	(snapshot	: Snapshot)
	case Transition	(transaction: Transaction)
	case Termination(snapshot	: Snapshot)						//<	Passes snapshot of current (latest) state.
}
//extension DictionarySignal: CollectionSignalType {
//	var initiation: Snapshot? {
//		get {
//			switch self {
//			case .Initiation(snapshot: let s):		return	s
//			default:								return	nil
//			}
//		}
//	}
//	var transition: Transaction? {
//		get {
//			switch self {
//			case .Transition(transaction: let s):	return	s
//			default:								return	nil
//			}
//		}
//	}
//	var termination: Snapshot? {
//		get {
//			switch self {
//			case .Termination(snapshot: let s):		return	s
//			default:								return	nil
//			}
//		}
//	}
//}
extension DictionarySignal {
	func apply(inout d: Dictionary<K,V>?) {
		switch self {
		case .Initiation(snapshot: let s):
			assert(d == nil, "Current array must be empty to apply initiation snapshot.")
			d	=	s
			
		case .Transition(transaction: let t):
			assert(d != nil)
			for m in t.mutations {
				switch (m.past != nil, m.future != nil) {
				case (false, true):
					//	Insert.
					assert(d![m.identity] == nil, "There should be no existing value for the key `\(m.identity)`, but there's an existing value `\(d![m.identity]!)` for the key.")
					d![m.identity]	=	m.future
					
				case (true, true):
					//	Update.
					assert(d![m.identity] != nil, "There should be an existing value for the key `\(m.identity)`, but there's none.")
					d![m.identity]	=	m.future
					
				case (true, false):
					assert(d![m.identity] != nil, "There should be an existing value for the key `\(m.identity)`, but there's none.")
					//	Delete.
					d!.removeValueForKey(m.identity)
					
				default:
					fatalError("Unsupported combination.")
				}
			}
			
		case .Termination(snapshot: let s):
			assert(d != nil)
			assert(s.count == d!.count, "Current array must be equal to latest snapshot to apply termination.")
			d	=	nil
		}
	}
}






































