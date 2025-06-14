

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:wise_child/features/NewChildren/presentation/bloc/NewChildren_cubit.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/section_header.dart';


class GenderToggle extends StatefulWidget {
  const GenderToggle({
    super.key,
  });



  @override
  State<GenderToggle> createState() => _GenderToggleState();
}

class _GenderToggleState extends State<GenderToggle> {
  bool isMaleSelected = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SectionHeader(title: 'النوع',),
          Container(
            height: 50,
            width: double.infinity,
            // margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment: isMaleSelected
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 2 - 32,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            context.read<NewChildrenCubit>().gender = 'Male';
                            isMaleSelected = false;
                          });
                        },
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.male, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                "ذكر",
                                style: TextStyle(
                                  color: isMaleSelected
                                      ? Colors.purple
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          {
                            setState(() {
                              context.read<NewChildrenCubit>().gender = 'Famale';
                              isMaleSelected = true;
                            });
                          }
                        },
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.female, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                "أنثى",
                                style: TextStyle(
                                  color: isMaleSelected
                                      ? Colors.grey
                                      : Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
