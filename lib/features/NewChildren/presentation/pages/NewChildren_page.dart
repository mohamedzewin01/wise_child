import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/custom_text_form.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/addSisters_or_brother_sheet.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/add_friends_sheet.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/child_image.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/friends_list_section.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/gender_selector.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/section_header.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/set_date_of_birth.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/siblings_list_section.dart';
import '../../../../core/di/di.dart';
import '../bloc/NewChildren_cubit.dart';

class NewChildrenPage extends StatefulWidget {
  const NewChildrenPage({super.key});

  @override
  State<NewChildrenPage> createState() => _NewChildrenPageState();
}

class _NewChildrenPageState extends State<NewChildrenPage> {
  late NewChildrenCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<NewChildrenCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(body: ProfileFormScreen(viewModel: viewModel)),
    );
  }
}


class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key, required this.viewModel});

  final NewChildrenCubit viewModel;

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _addPerson(List<Siblings> list, String type) async {
    final result = await showModalBottomSheet<Siblings>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddSistersOrBrotherSheet(personType: type),
    );

    if (result != null) {
      setState(() {
        list.add(result);
      });
    }
  }

  Future<void> _addFriends(List<Friends> list, String type) async {
    final result = await showModalBottomSheet<Friends>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddFriendsSheet(personType: type),
    );

    if (result != null) {
      setState(() {
        list.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'اضافة طفل',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  children: [
                    ChangeUserImage(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextForm(
                            controller: widget.viewModel.lastNameController,
                            hintText: 'الاسم الأخير',
                            validator: (value) => value!.isEmpty
                                ? 'الرجاء إدخال الاسم الأخير'
                                : null,
                          ),
                        ),

                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextForm(
                            controller: widget.viewModel.firstNameController,
                            hintText: 'الاسم الأول',
                            validator: (value) => value!.isEmpty
                                ? 'الرجاء إدخال الاسم الأول'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    GenderToggle(),
                    SectionHeader(title: 'تاريخ الميلاد'),
                    SetDateOfBirth(),
                    SiblingsListSection(
                      title: "العائلة (الإخوة)",
                      buttonLabel: "إضافة أخ/أخت",
                      list: widget.viewModel.siblings,
                      onAdd: () =>
                          _addPerson(widget.viewModel.siblings, 'أخ/أخت'),
                      onRemove: (person) {
                        setState(
                          () => widget.viewModel.siblings.remove(person),
                        );
                      },
                    ),
                    FriendsListSection(
                      title: "الأصدقاء",
                      buttonLabel: "إضافة اصدقاء",
                      list: widget.viewModel.friends,
                      onAdd: () =>
                          _addFriends(widget.viewModel.friends, 'صديق/صديقة'),
                      onRemove: (friend) {
                        setState(() => widget.viewModel.friends.remove(friend));
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.viewModel.saveChild();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم حفظ البيانات بنجاح!'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: ColorManager.primaryColor,
                      ),
                      child: Text(
                        'إضافة',
                        style: getSemiBoldStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
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
