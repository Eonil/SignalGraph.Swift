////
////  ValueMonitor.swift
////  SG5
////
////  Created by Hoon H. on 2015/07/05.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
/////	**DEPRECATION ALERT!**
/////	This class considered overly complex than what it offers.
/////	What we actually need is simplication by having add/remove notification
/////	for all each element. If we need something more, there's no truly better
/////	way then handling signals directly.
/////	So, this is very likely to be replaced with direct closure registering call.
/////	There's no defined order in session/transaction/mutation notifications.
/////	Because they're semantically happen and practically sent all at once.
/////	Anyway this monitor defines calling orders of them for your convenience.
/////	**DEPRECATION ALERT!**
/////
/////	----
/////
/////	There's no defined order in session/transaction/mutation notifications.
/////	Because they're semantically happen and practically sent all at once.
/////	Anyway this monitor defines calling orders of them for your convenience.
/////
/////	Basically, cause of state beginning will be notified first, and new state last.
/////	In reversed order for ending. Here's a proper table.
/////
/////	For sessions,
/////
/////	1.	didInitiate
/////	2.	didBegin
/////
/////	3.	willEnd
/////	4.	willTerminate
/////
/////	For transactions,
/////
/////	1.	didApply
/////	2.	didBegin
/////
/////	3.	willEnd
/////	4.	willApply
/////
/////	For mutations,
/////
/////	1.	didAdd
/////	2.	didBegin
/////
/////	3.	willEnd
/////	4.	willRemove
/////
/////	Please note that session and transaction signals are mutually exclusive, and
/////	won't happen together, but a transaction signal will always be followed by
/////	zero or more mutation signals that describe the transaction.
/////
/////	Segment
/////	-------
/////	As a value is conceptually an atomic state that cannot be divided into,
/////	`ValueMonitor` treats a whole single value state as a segment.
/////
//@availability(*,deprecated=0)
//public class ValueMonitor<T>: ValueMonitorType, SensitiveStationType, StateSegmentMonitorType, SessionMonitorType, TransactionMonitorType, StateMonitorType {
//	public typealias	Segment		=	T
//	public typealias	Signal		=	TimingSignal<T, ValueTransaction<T>>
//	public typealias	IncomingSignal	=	Signal
//
//	public var		didInitiate	:	(Signal.Snapshot->())?
//	public var		willTerminate	:	(Signal.Snapshot->())?
//
//	public var		didApply	:	(Signal.Transaction->())?
//	public var		willApply	:	(Signal.Transaction->())?
//
//	public var		didBegin	:	(Signal.Snapshot->())?
//	public var		willEnd		:	(Signal.Snapshot->())?
//
//	public var		didAdd		:	(Segment->())?
//	public var		willRemove	:	(Segment->())?
//
//	public init() {
//	}
//	public func cast(signal: Signal) {
//		switch signal {
//		case .DidBegin(let subsignal):
//			switch subsignal.by {
//			case .Session(let s):
//				didInitiate?(s())
//				didBegin?(subsignal.state)
//			case .Transaction(let t):
//				didApply?(t())
//			case .Mutation(let m):
//				didAdd?(m().future)
//				didBegin?(subsignal.state)
//			}
//
//		case .WillEnd(let subsignal):
//			switch subsignal.by {
//			case .Mutation(let m):
//				willEnd?(subsignal.state)
//				willRemove?(m().past)
//			case .Transaction(let t):
//				willApply?(t())
//			case .Session(let s):
//				willEnd?(subsignal.state)
//				willTerminate?(s())
//			}
//		}
//	}
//}
//
//
//
