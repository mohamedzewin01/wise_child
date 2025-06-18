import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/custom_app_bar.dart';
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
import 'package:wise_child/features/layout/presentation/widgets/custom_button_navigation_bar.dart';
import 'package:wise_child/l10n/app_localizations.dart';
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
      child: ProfileFormScreen(viewModel: viewModel),
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
    final result = await showDialog<Siblings>(
      context: context,
      builder: (_) => AddSistersOrBrotherSheet(personType: type),
    );

    if (result != null) {
      setState(() {
        list.add(result);
      });
    }
  }


  Future<void> _addFriends(List<Friends> list, String type) async {
    final result = await showDialog<Friends>(
      context: context,

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
      child: GradientBackground(
        child:
        Stack(
          children: [
            CustomAppBar(
              iconActionOne: Icons.arrow_forward_ios_rounded,
              onTapActionOne: () => Navigator.pop(context),
            ),
            Positioned(
              top: 95,
              left: 0,
              right: 0,
              bottom: 0,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                     physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          children: [
                            const SizedBox(height: 5),
                            ChangeUserImage(),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextForm(
                                    controller:
                                    widget.viewModel.firstNameController,
                                    hintText: AppLocalizations.of(context)!.firstName,
                                    validator: (value) => value!.isEmpty
                                        ? AppLocalizations.of(context)!.pleaseEnterTheFirstName

                                        : null,
                                  ),
                                ),


                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomTextForm(
                                    controller:
                                    widget.viewModel.lastNameController,
                                    hintText: AppLocalizations.of(context)!.lastName,
                                    validator: (value) => value!.isEmpty
                                        ?AppLocalizations.of(context)!.pleaseEnterTheLastName
                                        : null,
                                  ),
                                ),

                              ],
                            ),
                            GenderToggle(),
                            SectionHeader(title: AppLocalizations.of(context)!.birthDate),
                            SetDateOfBirth(),
                            SiblingsListSection(
                              title: AppLocalizations.of(context)!.familySiblings,
                              buttonLabel: AppLocalizations.of(context)!.addSibling,
                              list: widget.viewModel.siblings,
                              onAdd: () => _addPerson(
                                widget.viewModel.siblings,
                               AppLocalizations.of(context)!.sibling,
                              ),
                              onRemove: (person) {
                                setState(
                                  () =>
                                      widget.viewModel.siblings.remove(person),
                                );
                              },
                            ),
                            FriendsListSection(
                              title: AppLocalizations.of(context)!.addFriends,
                              buttonLabel: AppLocalizations.of(context)!.addFriend,
                              list: widget.viewModel.friends,
                              onAdd: () => _addFriends(
                                widget.viewModel.friends,
                                AppLocalizations.of(context)!.addFriend,

                              ),
                              onRemove: (friend) {
                                setState(
                                  () => widget.viewModel.friends.remove(friend),
                                );
                              },
                            ),
                            const SizedBox(height: 30),
                            BlocListener<NewChildrenCubit, NewChildrenState>(
                              listener: (context, state) {
                                if (state is NewChildrenSuccess) {
                                  Navigator.of(context, rootNavigator: true).pop();

                                  Navigator.pop(context, true);
                                }
                                if (state is NewChildrenFailure) {}
                                if (state is NewChildrenLoading) {
                                  showDialog(
                                    barrierDismissible: false,
                                    barrierColor: Colors.transparent,
                                    context: context,
                                    builder: (context) =>
                                        Center(
                                          child: CircularProgressIndicator(
                                            color: ColorManager.primaryColor,
                                          ),
                                        ),
                                  );
                                }
                              },
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    widget.viewModel.saveChild();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: ColorManager.primaryColor,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.save,
                                  style: getSemiBoldStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: kBottomNavigationBarHeight + 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
