import PackageDescription

let package = Package(
    name: "yachtsServer",
	dependencies: [
	        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1),
	        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1),
	        .Package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", majorVersion: 1),
			.Package(url: "https://github.com/IBM-Swift/Kitura-CouchDB.git", majorVersion: 1),
			//.Package(url: "../yachtsShare", majorVersion: 0)
			//.Package(url: "https://github.com/mschmulen/yachtsShare.git", majorVersion: 0)				
			.Package(url: "https://github.com/mschmulen/yachtsShare.git", Version(0, 0, 3))
	],
	exclude: ["Tools"]
)
