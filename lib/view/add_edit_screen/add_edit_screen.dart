import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mvelopes/model/add_edit/model/add_edit.dart';
import 'package:mvelopes/viewmodel/add_edit/add_edit_pov.dart';
import 'package:provider/provider.dart';
import '../../utilities/color/colors.dart';
import 'widgets/textfield.dart';

class AddEditScreen extends StatelessWidget {
  final ScreenType type;
  final TransationModel? data;
  const AddEditScreen({
    Key? key,
    required this.type,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkScreen(context);
    return GestureDetector(
      onTap: (() {
        FocusScope.of(context).unfocus();
      }),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: indigColor,
          centerTitle: true,
          title: const Text(
            'Add Items',
          ),
        ),
        backgroundColor: whiteColor,
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 30,
            ),
            SvgPicture.asset(
              'assets/image/addInfo.svg',
              height: 170,
            ),
            const SizedBox(
              height: 30,
            ),
            TextFieldCustomWidget(type: type, data: data),
          ],
        ),
      ),
    );
  }

  checkScreen(BuildContext context) {
    if (type == ScreenType.edit) {
      context.read<AddEditPov>().amountController.text = data!.amount.toString();
      context.read<AddEditPov>().notesController.text = data!.notes.toString();
      context.read<AddEditPov>().dateNow = data!.dateTime;
      context.read<AddEditPov>().dropName = context.read<AddEditPov>().categoryConvert(data!.type);
    }
  }
}

class TextFieldCustomWidget extends StatelessWidget {
  final TransationModel? data;
  final ScreenType type;
  const TextFieldCustomWidget({
    Key? key,
    required this.type,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            context.read<AddEditPov>().datePicker(context: context);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: greyLight,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: indigColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: const Icon(
                    Icons.date_range_outlined,
                    color: whiteColor,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Consumer<AddEditPov>(
                    builder: (context, value, _) {
                      return Text(
                        DateFormat('yMMMMd').format(value.dateNow),
                        style: const TextStyle(color: blackColor, fontSize: 18, fontFamily: 'redhat'),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
        ),
        TextFieldsWidget(
          icon: Icons.notes,
          hint: 'Notes',
          controllerText: context.read<AddEditPov>().notesController,
          type: TextInputType.name,
        ),
        TextFieldsWidget(
          icon: Icons.currency_rupee_outlined,
          hint: 'Amount',
          controllerText: context.read<AddEditPov>().amountController,
          type: TextInputType.number,
        ),
        const DropDownMenuWidget(),
        const SizedBox(height: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width * .84,
          child: ElevatedButton(
            onPressed: () {
              checkButton(context);
              FocusScope.of(context).unfocus();
            },
            style: ElevatedButton.styleFrom(
              primary: indigColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // <-- Radius
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'SUBMIT',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'redhat',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  checkButton(context) {
    switch (type) {
      case ScreenType.edit:
        Provider.of<AddEditPov>(context, listen: false).updateDetails(context, data!.id);
        break;
      case ScreenType.add:
        Provider.of<AddEditPov>(context, listen: false).submitDetails(context);
        break;
    }
  }
}

class DropDownMenuWidget extends StatelessWidget {
  const DropDownMenuWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: greyLight,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: indigColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: const Icon(
              Icons.keyboard_arrow_down,
              color: whiteColor,
            ),
          ),
          const SizedBox(width: 15),
          DropdownButtonHideUnderline(
            child: SizedBox(
              width: 230,
              child: Consumer<AddEditPov>(
                builder: (context, value, child) {
                  return DropdownButton(
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'redhat',
                      color: blackColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    dropdownColor: whiteColor,
                    icon: const Visibility(
                      visible: false,
                      child: Icon(Icons.arrow_downward),
                    ),
                    hint: Text(
                      'Select Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'redhat',
                        color: blackColor.withOpacity(.6),
                      ),
                    ),
                    value: value.dropName,
                    items: value.dropList.map((newList) {
                      return DropdownMenuItem(
                        value: newList,
                        child: Text(newList),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      value.changeDropName(dropName: newValue);
                      value.categoryTypeChecking(newValue);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum ScreenType {
  add,
  edit,
}
