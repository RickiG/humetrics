//
//  Metric.swift
//  Humetrics
//
//  Created by Ricki Gregersen on 21/01/2017.
//
//

import Foundation
import Vapor

struct Metric: Model {

	var exists: Bool = false
	var id: Node?

	let sender: String
	let metric: String
	let value: Double

	init(sender: String, metric: String, value: Double) {

		self.sender = sender
		self.metric = metric
		self.value = value
	}

	// NodeInitializable
	init(node: Node, in context: Context) throws {
		id = try node.extract("id")
		sender = try node.extract("sender")
		metric = try node.extract("metric")
		value = try node.extract("value")
	}

	// NodeRepresentable
	func makeNode(context: Context) throws -> Node {
		return try Node(node: ["id": id,
		                       "sender": sender,
		                       "metric": metric,
		                       "value": value])
	}

	// Preparation
	static func prepare(_ database: Database) throws {
		try database.create("metrics") { metrics in
			metrics.id()
			metrics.string("sender")
			metrics.string("metric")
			metrics.double("value")
		}
	}

	static func revert(_ database: Database) throws {
		try database.delete("metrics")
	}
}
