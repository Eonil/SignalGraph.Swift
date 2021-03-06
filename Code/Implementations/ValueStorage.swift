//
//  ValueStorage.swift
//  SG5
//
//  Created by Hoon H. on 2015/07/04.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

//public class ValueStorage<T>: ValueStorageType {
public class ValueStorage<T> {
	public typealias	Snapshot	=	T
	public typealias	Transaction	=	ValueTransaction<T>
	public typealias	OutgoingSignal	=	TimingSignal<Snapshot, Transaction>

	public typealias	Signal		=	OutgoingSignal

	///

	public init(_ snapshot: T) {
		_snapshot	=	snapshot
	}
	deinit {
	}

	///

	public var state: T {
		get {
			return	snapshot
		}
		set(v) {
			snapshot	=	v
		}
	}
	public var snapshot: T {
		get {
			return	_snapshot
		}
		set(v) {
			apply(Transaction([(_snapshot, v)]))
		}
	}
	public func apply(transaction: Transaction) {
		assert(_isApplying == false, "You cannot call `apply` until application of prior transaction to be finished.")
		_isApplying	=	true
		_cast(HOTFIX_TimingSignalUtility.willEndStateByTransaction(_snapshot, transaction: transaction))
		for m in transaction.mutations {
			_cast(HOTFIX_TimingSignalUtility.willEndStateByMutation(_snapshot, mutation: m))
			_snapshot	=	m.future
			_cast(HOTFIX_TimingSignalUtility.didBeginStateByMutation(_snapshot, mutation: m))
		}
		_cast(HOTFIX_TimingSignalUtility.didBeginStateByTransaction(_snapshot, transaction: transaction))
		_isApplying	=	false
	}
	public func register(identifier: ObjectIdentifier, handler: Signal->()) {
		_relay.register(identifier, handler: handler)
		handler(HOTFIX_TimingSignalUtility.didBeginStateBySession(_snapshot))
	}
	public func deregister(identifier: ObjectIdentifier) {
		_relay.handlerForIdentifier(identifier)(HOTFIX_TimingSignalUtility.willEndStateBySession(_snapshot))
		_relay.deregister(identifier)
	}
	public func register<S: SensitiveStationType where S.IncomingSignal == OutgoingSignal>(s: S) {
		register(ObjectIdentifier(s))	{ [weak s] in s!.cast($0) }
	}
	public func deregister<S: SensitiveStationType where S.IncomingSignal == OutgoingSignal>(s: S) {
		deregister(ObjectIdentifier(s))
	}

	///

	private typealias	_Signal		=	Signal

	private let		_relay		=	Relay<Signal>()
	private var		_snapshot	:	T

	private var		_isApplying	=	false

	private func _cast(signal: Signal) {
		_relay.cast(signal)
	}
}

//extension ValueStorage: SequenceType {
//	public func generate() -> GeneratorOfOne<T> {
//		return	GeneratorOfOne(_snapshot)
//	}
//}




