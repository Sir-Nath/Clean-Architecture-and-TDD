import 'package:clean_architecture_tdd_course/features/number_trivia/view/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: buildBody(context),
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
              }
              return Container(
                height: MediaQuery.of(context).size.height/3,
                child: Placeholder(),
              );
            },
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Placeholder(fallbackHeight: 40,),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(child: Placeholder(fallbackHeight: 30,)),
                  SizedBox(width: 10,),
                  Expanded(child: Placeholder(fallbackHeight: 30,),)
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class MessageDisplay extends StatelessWidget {
  final String message;
  const MessageDisplay({
    Key? key, required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/3,
      child: Center(
        child: SingleChildScrollView(
          child: Text(message,
          style: const TextStyle(
            fontSize: 25,
          ),textAlign: TextAlign.center,),
        ),
      )
      ,
    );
  }
}
