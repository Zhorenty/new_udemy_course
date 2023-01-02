import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_udemy_course/features/domain/entities/person_entity.dart';
import 'package:new_udemy_course/features/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:new_udemy_course/features/presentation/bloc/person_list_cubit/person_list_state.dart';
import 'package:new_udemy_course/features/presentation/widgets/person_card_widget.dart';

class PersonList extends StatelessWidget {
  PersonList({super.key});
  final scrollController = ScrollController();
  final int page = -1;
  void setupScrollController(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          // BlocProvider.of<PersonListCubit>(context).loadPerson();
          context.read<PersonListCubit>().loadPerson(); //либо так, покороче
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setupScrollController(context); //не забыть указать метод в билде
    return BlocBuilder<PersonListCubit, PersonState>(
      builder: (context, state) {
        List<PersonEntity> persons = [];
        bool isLoading = false;

        if (state is PersonLoading && state.isFirstFetch) {
          return _loadingIndicator();
        } else if (state is PersonLoading) {
          persons = state.oldPersonsList;
          isLoading = true;
        } else if (state is PersonLoaded) {
          persons = state.personsList;
        } else if (state is PersonError) {
          return Text(
            state.message,
            style: const TextStyle(color: Colors.white, fontSize: 25),
          );
        }
        return ListView.separated(
            controller: scrollController,
            itemBuilder: ((context, index) {
              if (index < persons.length) {
                return PersonCard(person: persons[index]);
              } else {
                return _loadingIndicator();
              }
            }),
            separatorBuilder: ((context, index) {
              return Divider(
                color: Colors.grey[400],
              );
            }),
            itemCount: persons.length + (isLoading ? 1 : 0));
        //когда мы дойдем до конца нашего списка, мы будем отображать индикатор загрузки
      },
    );
  }

  Widget _loadingIndicator() {
    return const Center(
      child: SpinKitChasingDots(color: Colors.black),
    );
  }
}
