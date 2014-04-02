
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});


Parse.Cloud.define("averageStarsForSongId", function(request, response) {

	var query = new Parse.Query("Song");
	console.log("searching for id  " + request.params.songId);

	query.get(request.params.songID).then(function(songResult) {
		console.log("song result is " + songResult);
		var query = new Parse.Query("Rating");
		query.equalTo("song", songResult);
		return query.find();
	}).then(function(reviews) {
		if (reviews.length == 0) {
			console.log("No ratings exist returning 0");
			response.success(0);
		} else {
			var sum = 0;
			for (var i = 0; i < reviews.length; ++i) {
				sum += reviews[i].get("stars");
			}
			response.success(reviews);
		}
	}, function(error) {
		response.error(error);
	});
});

Parse.Cloud.define("songForId", function(request, response) {
  var query = new Parse.Query("Song");
  query.get(request.params.songID, {
    success: function(songResult) {
    	console.log("song is " + songResult);
    	
    	return query.find();
		var query = new Parse.Query("Review");
		query.equalTo("song", songResult);
		query.find({
			success: function(results) {
				console.log("Reviews are " + results);
				var sum = 0;
				for (var i = 0; i < results.length; ++i) {
					sum += results[i].get("stars");
					}
				response.success(sum / results.length);
				},
			error: function() {
				response.error("movie lookup failed");
				}			
		});
		
		
		
		
	},
	error: function() {
      	response.error("movie lookup failed");
    }
  });
});

Parse.Cloud.define("averageStars", function(request, response) {
  var query = new Parse.Query("Review");
  query.equalTo("song", request.params.movie);
  query.find({
    success: function(results) {
      var sum = 0;
      for (var i = 0; i < results.length; ++i) {
        sum += results[i].get("stars");
      }
      response.success(sum / results.length);
    },
    error: function() {
      response.error("movie lookup failed");
    }
  });
});