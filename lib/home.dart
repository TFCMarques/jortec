import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'dart:html' show window;

Future<List<Movie>> fetchMovies() async {
  Response res = await get(
    Uri.http("ws-api.neec-fct.com", "/movie"),
    headers: {
      "token": window.localStorage["token"]
    }
  );

  if (res.statusCode == 200) {
    List<dynamic> body = jsonDecode(res.body);
    List<Movie> movies = body.map((dynamic item) => Movie.fromJSON(item)).toList();

    return movies;
  } else {
    return null;
  }
}

class Movie {
  String id;
  String title;
  String image;
  String plot;
  double rating;

  Movie(String id, String title, String image, String plot, double rating) {
    this.id = id;
    this.title = title;
    this.image = image;
    this.plot = plot;
    this.rating = rating;
  }

  Movie.fromJSON(Map json):
    id = json["id"],
    title = json["title"],
    image = json["image"],
    plot = json["plot"],
    rating = json["rating"];

  Map toJSON() {
    return {
      "id": id,
      "title": title,
      "image": image,
      "plot": plot,
      "rating": rating
    };
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Scaffold(
      appBar: AppBar(
        title: Text("Movie List")
      ),
      body: Container(
              color: Colors.grey.withOpacity(0.2),
              height: MediaQuery.of(context).size.height,
              child: MovieList(),
            )
        ),
    );
  }
}

class MovieList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Movie> movies = snapshot.data;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.25, vertical: 10),
              child: ListView(
                children: movies.map((Movie movie) {
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1
                      )
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          child :Text(
                            movie.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.network(movie.image, height: 200),
                            Container(
                              child: Text(
                                movie.plot,
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                              width: 400,
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          child :Text(
                            "Rating: " + movie.rating.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    )
                  );
                }).toList()
              )
            );
          } else if (snapshot.hasError) {
            return Text("No movies to display!");
          }
          return CircularProgressIndicator();
        },
      )
    );
  }
}