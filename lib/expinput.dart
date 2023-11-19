// todo: 経費種別を選ばないとnulになる
// todo: 経費種別=transporationで入力した内容が経費種別=othersにしても残る
// dart run build_runner build expinput.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'expence.dart';

// final _currentExpenceType =
// Provider<ExpenceType>((ref) => throw UnimplementedError());
part 'expinput.g.dart';

@riverpod
class ExpenceDate extends _$ExpenceDate {
  @override
  String build() {
    return intl.DateFormat.yMd().format(DateTime.now());
  }

  void setExpenceDate(DateTime dt) {
    if (state != intl.DateFormat.yMd().format(dt))
      state = intl.DateFormat.yMd().format(dt);
  }
}

@riverpod
class CurrentExpenceType extends _$CurrentExpenceType {
  @override
  ExpenceType build() {
    return ExpenceType.transportation;
  }

  void setExpenceType(String exptypestr) {
    for (var type in ExpenceType.values) {
      if (exptypestr == type.name) {
        state = type;
        break;
      }
    }
  }

  ExpenceType getcurrentstate() {
    return state;
  }

  // void setExpenceType(ExpenceType expenceType) {
  //   state = expenceType;
  // }

  // void setTransportation() {
  //   state = ExpenceType.transportation;
  // }

  // void setOthers() {
  //   state = ExpenceType.others;
  // }
}

var uuid = const Uuid();
final log = Logger('ExpenceInputLogger');

const List<String> expenceTypeList = <String>['交通費', 'その他', '直', 'Four'];

class ExpenceInput extends ConsumerWidget {
  ExpenceInput({
    super.key,
    required this.userID,
    required this.reportID,
    // required this.expence
  });
  final String userID;
  final String reportID;
  // final Expence expence;

  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  DateTime expenceDate = DateTime.now();
  double maxValue = 0;
  bool? brushedTeeth = false;
  bool enableFeature = false;

  DateTime _date = new DateTime.now();

  // Expence expence = Expence(
  //     userID: userID,
  //     reportID: reportID,
  //     id: uuid.v7(),
  //     createdDate: DateTime.now());

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2016),
      lastDate: DateTime.now().add(
        Duration(days: 360),
      ),
    ); // if (picked != null) setState(() => _date = picked);
    if (picked != null)
      return picked;
    else
      return DateTime.now();
  }

  static const List<String> taxTypeList = <String>['one', 'two', 'Three', '直'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Expence expence = Expence(
        userID: userID,
        reportID: reportID,
        id: uuid.v7(),
        createdDate: DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          style: TextStyle(
            fontFamily: 'MPLUSRounded',
          ),
          'Sample Code :',
        ),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: Align(
            alignment: Alignment.topCenter,
            child: Card(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '経費種別',
                        // style: Theme.of(context).textTheme.bodyLarge,
                        style: TextStyle(
                          fontFamily: 'MPLUSRounded',
                        ),
                      ),

                      DropdownMenu<String>(
                        trailingIcon:
                            const Icon(Icons.arrow_drop_down, size: 10),
                        inputDecorationTheme: InputDecorationTheme(
                          isDense: true,
                          // contentPadding:
                          //     const EdgeInsets.symmetric(horizontal: 16),
                          constraints:
                              BoxConstraints.tight(const Size.fromHeight(45)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        // textStyle: const TextStyle(fontSize: 14),
                        textStyle: const TextStyle(
                            fontSize: 12, fontFamily: 'MPLUSRounded'),
                        // initialSelection: expenceTypeList.first,
                        initialSelection: <String>[
                          ExpenceType.values.map((e) => e.name).toList().first,
                        ].first,
                        onSelected: (String? value) {
                          // ref
                          //     .read(currentExpenceTypeProvider.notifier)
                          //     .setExpenceType(value);
                          log.info('value:$value');
                          log.info('Etype:${ExpenceType.values}');
                          log.info(
                              'provider1:${ref.read(currentExpenceTypeProvider.notifier).getcurrentstate()}');
                          ref
                              .read(currentExpenceTypeProvider.notifier)
                              .setExpenceType(value!);
                          log.info(
                              'provider2:${ref.read(currentExpenceTypeProvider.notifier).getcurrentstate()}');

                          expence = expence.copyWith(
                              expenceType: ref
                                  .read(currentExpenceTypeProvider.notifier)
                                  .getcurrentstate());
                          log.info('${expence.toString()}');
                          //
                          // setState(() {
                          //   log.info('selected :$value');
                          // });
                        },
                        // dropdownMenuEntries: expenceTypeList
                        dropdownMenuEntries: ExpenceType.values
                            .map((e) => e.name)
                            .toList()
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              style: ButtonStyle(
                                  textStyle: MaterialStateTextStyle.resolveWith(
                                      (states) => const TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'MPLUSRounded'))),
                              value: value,
                              label: value);
                        }).toList(),
                      ),
                      // ),
                      const SizedBox(height: 20),
                      const Text(
                        '日付',
                        // style: Theme.of(context).textTheme.bodyLarge,
                        style: TextStyle(
                          fontFamily: 'MPLUSRounded',
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 12),
                              Text(
                                // intl.DateFormat.yMd().format(expenceDate),
                                // style: Theme.of(context).textTheme.titleMedium,
                                ref.watch(expenceDateProvider),
                              ),
                            ],
                          ),

                          //   ],
                          // ),
                          TextButton(
                            child: const Text(
                              '日付指定',
                              style: TextStyle(
                                fontFamily: 'MPLUSRounded',
                              ),
                            ),
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: _date,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                expence =
                                    expence.copyWith(expenceDate: selectedDate);
                                ref
                                    .read(expenceDateProvider.notifier)
                                    .setExpenceDate(selectedDate);
                                // expenceDate = selectedDate;
                                log.info('${expence.toString()}');
                                // setState(() {
                                //   date = selectedDate;
                                // });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // InputDetails(inputType: InputType.transportation),
                      // InputDetails(inputType: InputType.other),
                      // InputDetails(
                      //     inputType: ref
                      //         .read(currentExpenceTypeProvider.notifier)
                      //         .getcurrentstate()),
                      InputDetails(
                        funcCol1: (String c1) {
                          expence = expence.copyWith(col1: c1);
                        },
                        funcCol2: (String c2) {
                          expence = expence.copyWith(col2: c2);
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '金額',
                        style: TextStyle(fontFamily: 'MPLUSRounded'),
                        // style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextFormField(
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          // filled: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          log.info('input: value:$value');
                          expence = expence.copyWith(price: int.parse(value));
                          log.info('${expence.toString()}');
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'メモ',
                        style: TextStyle(fontFamily: 'MPLUSRounded'),
                        // style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          // filled: true,
                          // hintText: 'Enter a description...',
                          // labelText: 'Description',
                        ),
                        onChanged: (value) {
                          // description = value;
                          expence = expence.copyWith(col3: value);
                          log.info('${expence.toString()}');
                        },
                        maxLines: 5,
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        '税タイプ',
                        style: TextStyle(fontFamily: 'MPLUSRounded'),
                        // style: Theme.of(context).textTheme.bodyLarge),
                      ),
                      DropdownMenu<String>(
                        trailingIcon:
                            const Icon(Icons.arrow_drop_down, size: 10),
                        inputDecorationTheme: InputDecorationTheme(
                          isDense: true,
                          // contentPadding:
                          //     const EdgeInsets.symmetric(horizontal: 16),
                          constraints:
                              BoxConstraints.tight(const Size.fromHeight(45)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'MPLUSRounded',
                        ),
                        initialSelection: taxTypeList.first,
                        onSelected: (String? value) {
                          // setState(() {
                          //   log.info('selected :$value');
                          // });
                        },
                        dropdownMenuEntries: taxTypeList
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              style: ButtonStyle(
                                  textStyle: MaterialStateTextStyle.resolveWith(
                                      (states) => const TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'MPLUSRounded'))),
                              value: value,
                              label: value);
                        }).toList(),
                      ),
                      // //
                      // //
                      // //
                      // const SizedBox(height: 20),

                      // TextFormField(
                      //   decoration: const InputDecoration(
                      //     filled: true,
                      //     hintText: 'Enter a title...',
                      //     labelText: 'Title',
                      //   ),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       title = value;
                      //     });
                      //   },
                      // ),
                      // TextFormField(
                      //   decoration: const InputDecoration(
                      //     border: OutlineInputBorder(),
                      //     filled: true,
                      //     hintText: 'Enter a description...',
                      //     labelText: 'Description',
                      //   ),
                      //   onChanged: (value) {
                      //     description = value;
                      //   },
                      //   maxLines: 5,
                      // ),

                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Text(
                      //           'Estimated value',
                      //           style: Theme.of(context).textTheme.bodyLarge,
                      //         ),
                      //       ],
                      //     ),
                      //     Text(
                      //       intl.NumberFormat.currency(
                      //               symbol: "\$", decimalDigits: 0)
                      //           .format(maxValue),
                      //       style: Theme.of(context).textTheme.titleMedium,
                      //     ),
                      //     Slider(
                      //       min: 0,
                      //       max: 500,
                      //       divisions: 500,
                      //       value: maxValue,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           maxValue = value;
                      //         });
                      //       },
                      //     ),
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Checkbox(
                      //       value: brushedTeeth,
                      //       onChanged: (checked) {
                      //         setState(() {
                      //           brushedTeeth = checked;
                      //         });
                      //       },
                      //     ),
                      //     Text('Brushed Teeth',
                      //         style: Theme.of(context).textTheme.titleMedium),
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Text('Enable feature',
                      //         style: Theme.of(context).textTheme.bodyLarge),
                      //     Switch(
                      //       value: enableFeature,
                      //       onChanged: (enabled) {
                      //         setState(() {
                      //           enableFeature = enabled;
                      //         });
                      //       },
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// enum InputType { transportation, other }

class InputDetails extends ConsumerWidget {
  const InputDetails(
      {super.key, required this.funcCol1, required this.funcCol2});
  final Function funcCol1;
  final Function funcCol2;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputType = ref.watch(currentExpenceTypeProvider);
    if (inputType == ExpenceType.transportation) {
      return Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '乗車地',
                  style: TextStyle(fontFamily: 'MPLUSRounded'),
                  // style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    // filled: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    log.info('input: value:$value');
                    funcCol1(value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '降車地',
                  style: TextStyle(fontFamily: 'MPLUSRounded'),
                  // style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    // filled: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    log.info('-------> input: value:$value');
                    funcCol2(value);
                  },
                ),
              ],
            ),
          ),
          // SizedBox(width: 5),
          const SizedBox(width: 0),
          SizedBox(
            height: 60,
            width: 23,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    log.info("favorite pressed");
                  },
                  iconSize: 23,
                  icon: const Icon(Icons.favorite_border, size: 25),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '費用項目',
                  style: TextStyle(fontFamily: 'MPLUSRounded'),
                  // style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    // filled: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    log.info('input: 費用項目value:$value');
                    funcCol1(value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 3),
        ],
      );
    }
  }
}
