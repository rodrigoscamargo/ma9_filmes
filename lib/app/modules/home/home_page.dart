import 'package:flutter/material.dart';
import 'package:ma9filmes/app/app_bloc.dart';
import 'package:ma9filmes/app/app_module.dart';
import 'package:ma9filmes/app/modules/home/home_bloc.dart';
import 'package:ma9filmes/app/modules/home/home_module.dart';
import 'package:ma9filmes/app/modules/movie_categories/movie_categories_module.dart';
import 'package:ma9filmes/app/modules/movie_favorites/movie_favorites_module.dart';
import 'package:ma9filmes/app/modules/search/search_module.dart';
import 'package:ma9filmes/shared/components/bottom_nav_bar.dart';
import 'package:ma9filmes/shared/components/card_movie.dart';
import 'package:ma9filmes/shared/models/filme_model.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 300) / 2;
    final double itemWidth = size.width / 2;
    final pageController = PageController();
    final bloc = HomeModule.to.getBloc<HomeBloc>();
    final blocApp = AppModule.to.getBloc<AppBloc>();

    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: false,
        itemCornerRadius: 25,
        curve: Curves.easeInBack,
        backgroundColor: Colors.black54,
        onItemSelected: (index) => setState(() {
          currentIndex = index;
          pageController.jumpToPage(index);
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Movies'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
            activeColor: Colors.purpleAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.favorite),
            title: Text(
              'Categories',
            ),
            activeColor: Colors.pink,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.favorite),
            title: Text(
              'Favorites',
            ),
            activeColor: Colors.pink,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            height: double.infinity,
            color: Colors.black87,
            child: StreamBuilder<List<FilmeModel>>(
                stream: bloc.filmes,
                builder: (context, snapFilmes) {
                  if (snapFilmes.hasData) {
                    blocApp.setMovies(snapFilmes.data);
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: (itemWidth / itemHeight),
                        ),
                        itemCount: snapFilmes.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CardMovie(
                            filme: FilmeModel(
                                titulo: snapFilmes.data[index].titulo,
                                genero: snapFilmes.data[index].genero,
                                data: snapFilmes.data[index].data,
                                link: snapFilmes.data[index].link,
                                poster: snapFilmes.data[index].poster,
                                sinopse: snapFilmes.data[index].sinopse,
                                sinopseFull:
                                    snapFilmes.data[index].sinopseFull),
                          );
                        });
                  } else
                    return Container();
                }),
          ),
          SearchModule(),
          MovieCategoriesModule(),
          MovieFavoritesModule()
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
