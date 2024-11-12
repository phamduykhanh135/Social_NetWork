import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:network/app/messages.dart';
import 'package:network/data/models/titlle_model.dart';
import 'package:network/utils/get_user_id.dart';
import 'package:network/views/widgets/custom_elevated_button.dart';
import 'package:network/data/services/title_service.dart';
import 'package:network/views/widgets/validate_input.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_state.dart';
import 'package:network/views/widgets/home_widget/item_collection_bottom_sheet.dart';

class CollectionBottomSheet extends StatefulWidget {
  final String idPost; // Đánh dấu là final

  const CollectionBottomSheet({super.key, required this.idPost});

  @override
  CollectionBottomSheetState createState() => CollectionBottomSheetState();
}

class CollectionBottomSheetState extends State<CollectionBottomSheet>
    with AutomaticKeepAliveClientMixin {
  String? userId = getUserId();
  TitleService titleService = TitleService();
  // Hàm xử lý khi người dùng nhấn vào

  Future<void> _handlerAddCollection(String titleId) async {
    await titleService.addPostToCollection(
      titleId: titleId,
      postId: widget.idPost,
      context: context,
    );
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Save to collection',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomElevatedButton(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.4,
                      text: 'New Collection',
                      fontSize: 13,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => const AddCollection(),
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              BlocBuilder<TitleBloc, TitleState>(
                builder: (context, state) {
                  if (state is TitlesLoading) {
                    return Container();
                  } else if (state is TitlesError) {
                    return Center(
                      child: Text('Error: ${state.errorMessage}'),
                    );
                  } else if (state is TitlesLoaded) {
                    final titles = state.titles;
                    if (titles.isEmpty) {
                      return Center(
                          child: Image.asset(
                        'assets/images/no_shot.png',
                        width: 300,
                        height: 300,
                      ));
                    }
                    return Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(10),
                        controller: scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemCount: titles.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              final titleId = titles[index].id;
                              _handlerAddCollection(titleId!); // Gọi hàm xử lý
                            },
                            child: ItemCollectionBottomSheet(
                              title: titles[index].name,
                              titleId: titles[index].id!,
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const Center(
                      child: Text(Messages.noCollectionsAvailable));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class AddCollection extends StatefulWidget {
  const AddCollection({super.key});

  @override
  State<AddCollection> createState() => _AddCollectionState();
}

class _AddCollectionState extends State<AddCollection> {
  final _formKey = GlobalKey<FormState>();
  final TitleService _titleService = TitleService();
  late TextEditingController _typeNameController;
  @override
  void initState() {
    _typeNameController = TextEditingController();
    super.initState();
  }

  Future<void> _handlercreateNewTitle(BuildContext context) async {
    String titleName = _typeNameController.text.trim();

    if (titleName.isEmpty) {
      // Thông báo lỗi nếu tên title trống
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(Messages.pleaseEnterCollectionName)),
      );
      return;
    }

    // Tạo đối tượng TitleModel
    TitleModel newTitle = TitleModel(name: titleName, post: []);

    // Gọi service để thêm title vào Firestore
    await _titleService.addTitle(newTitle, context);
  }

  @override
  void dispose() {
    _typeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            context.pop();
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      controller: _typeNameController,
                      decoration: InputDecoration(
                          labelText: 'Type name',
                          labelStyle:
                              const TextStyle(color: Colors.grey, fontSize: 13),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.grey[200],
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none)),
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateName,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomElevatedButton(
                    width: MediaQuery.of(context).size.width * 0.8,
                    text: 'CREATE COLLECTION',
                    fontSize: 13,
                    onPressed: () {
                      _handlercreateNewTitle(context);

                      _typeNameController.clear();
                    }, // Gọi hàm tạo t
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
