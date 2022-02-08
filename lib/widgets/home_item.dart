import 'package:flutter/material.dart';

class MainItem extends StatelessWidget {
  final Map<String, Object> item;

  MainItem(this.item);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Theme.of(context).colorScheme.primary,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).pushNamed(item['routeName'],arguments: item['argument']);
          },
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      item['title'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!(item['hint'] as String).isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          item['hint'],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                width: mediaQuery.size.width / 2,
                height: (mediaQuery.size.height) / 5.45,
                child: Stack(
                  fit: StackFit.loose,
                  alignment: AlignmentDirectional.centerStart,
                  children: <Widget>[
                    Positioned(
                      width: mediaQuery.size.width / 2 - 10,
                      height: mediaQuery.size.height / 4,
                      left: 10,
                      bottom: 0.1,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(.2)),
                      ),
                    ),
                    Positioned(
                      width: mediaQuery.size.width / 2 - 10,
                      height: mediaQuery.size.height / 4,
                      left: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0),
                              Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(.2),
                              Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                        width: double.infinity,
                        height: double.infinity,
                        margin: EdgeInsets.all(20),
                        child: Image.asset(
                          item['icon'],
                          fit: BoxFit.fitHeight,
                        ))
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
