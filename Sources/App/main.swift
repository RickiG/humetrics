import Vapor
import VaporPostgreSQL

let drop = Droplet()
drop.preparations.append(Metric.self)

do {
	try drop.addProvider(VaporPostgreSQL.Provider.self)
} catch {
	assertionFailure("Error adding provider: \(error)")
}

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.get("metrics") { req in
	let metrics = try Metric.all().makeNode()
	let metricsDictionary = ["metrics" : metrics]
	return try JSON(node: metricsDictionary)
}

drop.get("metrics", Int.self) { req, metricID in
	guard let metric = try Metric.find(metricID) else {
		throw Abort.notFound
	}
	return try metric.makeJSON()
}

drop.post("metric") { req in
	var metric = try Metric(node: req.json)
	try metric.save()
	return try metric.makeJSON()
}

drop.resource("posts", PostController())

drop.run()
