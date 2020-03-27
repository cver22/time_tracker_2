

import 'package:flutter/material.dart';
import 'package:time_tracker_2/app/home/jobs/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  //re-useable list builder widget that is type agnostic
  const ListItemsBuilder({Key key, @required this.snapshot, @required this.itemBuilder})
      : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    //while waiting for snapshot
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(List<T> items) {
    //ListView.builder only return items as they are required
    //good for large lists where not all have to be visible as the same time
    //separated is the same as builder but also has a separation argument
    return ListView.separated(
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        //check if
        if(index == 0 || index == items.length + 1){
          //returns a container before and after the list so a separator is included
          return Container();
        }
       return itemBuilder(context,items[index - 1]);
      }
    );
  }
}
