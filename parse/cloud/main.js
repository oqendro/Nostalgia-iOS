
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

// After Saving a Rating object update the rating on the Song object itself

Parse.Cloud.afterSave("SongRating", function(request) {
  var songQuery = new Parse.Query("Song");	
		
  songQuery.get(request.object.get("song").id, {
    success: function(song) {
    	var ratingQuery = new Parse.Query("SongRating");
		ratingQuery.equalTo("song",song);
		ratingQuery.find({
			success: function(songRatings) {
				//get all ratings
				var ratingCount = songRatings.length;
				console.log("count of ratings is " + ratingCount + " for song" + song.get("Title"));
				//calculate average rating
				var sum = 0;
				for (var i = 0; i < songRatings.length; ++i) {
					sum += songRatings[i].get("stars");
					}
				var averageRating = sum / songRatings.length;
				console.log("average rating of" + song.get('Title') + " is " + averageRating);
				song.set("rating",averageRating, 0);
				song.save();
			},
			error: function(error) {
      			console.error("Got an error " + error.code + " : " + error.message);
			}
		});
    
     	song.save();
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });


});

// After Saving a Rating object update the rating on the Movie object itself

Parse.Cloud.afterSave("MovieRating", function(request) {
  var movieQuery = new Parse.Query("Movie");	
		
  movieQuery.get(request.object.get("movie").id, {
    success: function(movie) {
    	var ratingQuery = new Parse.Query("MovieRating");
		ratingQuery.equalTo("movie",movie);
		ratingQuery.find({
			success: function(movieRatings) {
				//get all ratings
				var ratingCount = movieRatings.length;
				console.log("count of ratings is " + ratingCount + " for movie" + movie.get("Title"));
				//calculate average rating
				var sum = 0;
				for (var i = 0; i < movieRatings.length; ++i) {
					sum += movieRatings[i].get("stars");
					}
				var averageRating = sum / movieRatings.length;
				console.log("average rating of" + movie.get('Title') + " is " + averageRating);
				movie.set("rating",averageRating, 0);
				movie.save();
			},
			error: function(error) {
      			console.error("Got an error " + error.code + " : " + error.message);
			}
		});
    
     	movie.save();
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });


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
/*
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
*/