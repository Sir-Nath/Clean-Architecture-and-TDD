import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControl extends StatefulWidget {
  const TriviaControl({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControl> createState() => _TriviaControlState();
}

class _TriviaControlState extends State<TriviaControl> {
  final controller = TextEditingController();
  late String inputStr;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Input a Number'
          ),
          onChanged: (value){
            inputStr = value;
          },
          onSubmitted: (_){
            dispatchConcrete();
          },
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            Expanded(child: MaterialButton(onPressed: (){
              dispatchConcrete();
            },
              color: Theme.of(context).colorScheme.secondary,
              child: const Text('Search'),
            ),
            ),
            const SizedBox(width: 10,),
            Expanded(child: MaterialButton(onPressed: (){
              dispatchRandom();
            },
              color: Theme.of(context).colorScheme.secondary,
              child: const Text('Get random Trivia '),
            ),
            ),
          ],
        )
      ],
    );
  }
  void dispatchConcrete(){
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForConcreteNumber(inputStr));
  }

  void dispatchRandom(){
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}