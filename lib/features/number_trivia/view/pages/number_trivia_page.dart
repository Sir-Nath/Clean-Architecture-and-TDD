import 'package:clean_architecture_tdd_course/features/number_trivia/view/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/number_trivia.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';
import '../widgets/trivia_control.dart';
import '../widgets/trivia_display.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) =>  sl<NumberTriviaBloc>(),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
            builder: (context, state){
              if(state is Empty){
                return const MessageDisplay(message: 'Start Searching',);
              }else if(state is ErrorState){
                return MessageDisplay(message: state.message);
              }else if(state is Loading){
                return const LoadingWidget();
              }else if(state is Loaded){
                return TriviaDisplay(numberTrivia: state.trivia);
              }else{
                return Container();
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const TriviaControl()
        ],
      ),
    );
  }
}







