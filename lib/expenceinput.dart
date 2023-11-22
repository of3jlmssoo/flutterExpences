// done: 経費種別を選ばないとnulになる
// todo: 経費種別=transporationで入力した内容が経費種別=othersにしても残る
// done: taxtype enum化
// done: taxType default
// todo: valudator
// todo: save button
//
//
// dart run build_runner build expenceinput.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import 'enums.dart';
import 'expence.dart';
import 'expenceproviders.dart';

// part 'expenceinput.g.dart';

// @riverpod
// class ExpenceDate extends _$ExpenceDate {
//   @override
//   String build() {
//     return intl.DateFormat.yMd().format(DateTime.now());
//   }
//
//   void setExpenceDate(DateTime dt) {
//     if (state != intl.DateFormat.yMd().format(dt))
//       state = intl.DateFormat.yMd().format(dt);
//   }
// }
//
// @riverpod
// // @Riverpod(keepAlive: true)
// class CurrentTaxType extends _$CurrentTaxType {
//   @override
//   TaxType build() {
//     return TaxType.invoice;
//   }
//
//   // int get number => _number;
//   // TaxType get taxtype => state;
//   void setTaxType(String taxtypestr) {
//     for (var type in TaxType.values) {
//       if (taxtypestr == type.name) {
//         state = type;
//         break;
//       }
//     }
//   }
// }
//
// @riverpod
// class CurrentExpenceType extends _$CurrentExpenceType {
//   @override
//   ExpenceType build() {
//     return ExpenceType.transportation;
//   }
//
//   void setExpenceType(String exptypestr) {
//     for (var type in ExpenceType.values) {
//       if (exptypestr == type.name) {
//         state = type;
//         break;
//       }
//     }
//   }
//
//   ExpenceType getcurrentstate() {
//     return state;
//   }
// }

var uuid = const Uuid();
final log = Logger('ExpenceInputLogger');

Expence expence = Expence(
  userID: 'dummyuserid',
  reportID: 'dummyreportid',
  id: 'dumyyid',
  createdDate: DateTime.now(),
  expenceDate: DateTime.now(),
  expenceType: ExpenceType.transportation,
  taxType: TaxType.invoice,
);

// class CurrentExpence {

// }

// const List<String> expenceTypeList = <String>['交通費', 'その他', '直', 'Four'];
// @riverpod
// class CurrentExpence extends _$CurrentExpence {
//   @override
//   Expence build() {
//     return Expence(
//         userID: 'userid',
//         reportID: 'reportid',
//         id: 'id',
//         expenceType: ExpenceType.transportation,
//         createdDate: DateTime.now(),
//         expenceDate: DateTime.now(),
//         taxType: TaxType.invoice);
//   }
//
//   set userID(String s) => state.copyWith(userID: s);
//   set expenceType(ExpenceType s) {
//     log.info('setter4expType1 : ${state.expenceType}');
//     state = state.copyWith(expenceType: s);
//     log.info('setter4expType2 : ${state.expenceType}');
//     log.info('setter4expType3 : ${state.toString()}');
//     log.info('setter4expType4 : ${stateToString()}');
//     ref.invalidateSelf();
//   }
//
//   String stateToString() {
//     return state.toString();
//   }
//
//   // Add methods to mutate the state
// }

class ExpenceInput extends ConsumerStatefulWidget {
  String reportID;
  String userID;
  String id;
  // DateTime createdDate;
  String expenceTypeName;
  // DateTime expenceDate;
  String taxTypeName;

  ExpenceInput({
    super.key,
    required String this.reportID,
    required String this.userID,
    required String this.id,
    // required DateTime this.createdDate,
    required String this.expenceTypeName,
    // required DateTime this.expenceDate,
    required String this.taxTypeName,
  });

  @override
  ExpenceInputState createState() => ExpenceInputState();
}

class ExpenceInputState extends ConsumerState<ExpenceInput> {
  @override
  void initState() {
    super.initState();

    late ExpenceType expenceType;
    for (var type in ExpenceType.values) {
      if (widget.expenceTypeName == type.name) {
        expenceType = type;
        break;
      }
    }

    late TaxType taxType;
    for (var type in TaxType.values) {
      if (widget.taxTypeName == type.name) {
        taxType = type;
        break;
      }
    }

    expence = expence.copyWith(
        userID: widget.userID, reportID: widget.reportID, id: widget.id);

    log.info('initState 1 : ref.watch(currentExpenceProvider).toString()');
    // expence = Expence(
    //   userID: widget.userID,
    //   reportID: widget.reportID,
    //   id: widget.id,
    //   createdDate: DateTime.now(),
    //   expenceType: expenceType,
    //   expenceDate: DateTime.now(),
    //   taxType: taxType,
    // );
  }

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

  var expenceTypeDefault =
      <String>[ExpenceType.values.map((e) => e.name).toList().first].first;
  var taxTypeDefault =
      <String>[TaxType.values.map((e) => e.name).toList().first].first;

  @override
  Widget build(BuildContext context) {
    final tt = ref.watch(currentTaxTypeProvider);
    final ed = ref.watch(currentExpenceDateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          // style: TextStyle(
          //   fontFamily: 'MPLUSRounded',
          // ),
          '経費入力',
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
                        // style: TextStyle(
                        //   fontFamily: 'MPLUSRounded',
                        // ),
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
                          fontSize: 12,
                          // fontFamily: 'MPLUSRounded',
                        ),

                        initialSelection: expenceTypeDefault,
                        onSelected: (String? value) {
                          log.info('経費種別0 value:${value}');
                          log.info('経費種別1 ${expence.expenceType}');

                          late var epType;
                          for (var type in ExpenceType.values) {
                            if (value == type.name) {
                              epType = type;
                              break;
                            }
                          }
                          log.info('経費種別2 ${epType}');
                          expence = expence.copyWith(expenceType: epType);
                          ref
                              .read(currentExpenceTypeProvider.notifier)
                              .expenceType(epType);
                          log.info('経費種別4 ${expence.expenceType}');
                          log.info('経費種別5 ${expence.toString()}');
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
                                            // fontFamily: 'MPLUSRounded',
                                          ))),
                              value: value,
                              label: value);
                        }).toList(),
                      ),
                      // ),
                      const SizedBox(height: 20),
                      const Text(
                        '日付',
                        // style: Theme.of(context).textTheme.bodyLarge,
                        // style: TextStyle(
                        //   fontFamily: 'MPLUSRounded',
                        // ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 12),
                              Text('${ed}'),
                            ],
                          ),

                          //   ],
                          // ),
                          TextButton(
                            child: const Text(
                              '日付指定',
                              // style: TextStyle(
                              //   fontFamily: 'MPLUSRounded',
                              // ),
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
                                    .read(currentExpenceDateProvider.notifier)
                                    .expenceDate(selectedDate);
                                log.info('日付 : ${expence.toString()}');

                                // expence =
                                //     expence.copyWith(expenceDate: selectedDate);
                                // ref
                                //     .read(expenceDateProvider.notifier)
                                //     .setExpenceDate(selectedDate);
                                // // expenceDate = selectedDate;
                                // log.info('${expence.toString()}');
                                // setState(() {
                                //   date = selectedDate;
                                // });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      InputDetails(),
                      // InputDetails(inputType: InputType.transportation),
                      // InputDetails(inputType: InputType.other),
                      // InputDetails(
                      //     inputType: ref
                      //         .read(currentExpenceTypeProvider.notifier)
                      //         .getcurrentstate()),

                      // InputDetails(
                      //   funcCol1: (String c1) {
                      //     expence = expence.copyWith(col1: c1);
                      //   },
                      //   funcCol2: (String c2) {
                      //     expence = expence.copyWith(col2: c2);
                      //   },
                      // ),
                      const SizedBox(height: 20),
                      const Text(
                        '金額',
                        // style: TextStyle(fontFamily: 'MPLUSRounded'),
                        // style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextFormField(
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          // filled: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          // log.info('input: value:$value');
                          // expence = expence.copyWith(price: int.parse(value));
                          // log.info('${expence.toString()}');
                          expence = expence.copyWith(price: int.parse(value));
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'メモ',
                        // style: TextStyle(fontFamily: 'MPLUSRounded'),
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
                        // style: TextStyle(fontFamily: 'MPLUSRounded'),
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
                          // fontFamily: 'MPLUSRounded',
                        ),
                        initialSelection: taxTypeDefault,
                        onSelected: (String? value) {
                          late var tType;
                          for (var type in TaxType.values) {
                            if (value == type.name) {
                              tType = type;
                              break;
                            }
                          }
                          expence = expence.copyWith(taxType: tType);
                          ref
                              .read(currentTaxTypeProvider.notifier)
                              .taxType(tType);
                          log.info('TaxType : ${expence.toString()}');
                          // ref
                          //     .read(currentTaxTypeProvider.notifier)
                          //     .setTaxType(value!);
                          // expence = expence.copyWith(
                          //     taxType: ref.watch(currentTaxTypeProvider));
                        },
                        // dropdownMenuEntries: taxTypeList
                        //     .map<DropdownMenuEntry<String>>((String value) {
                        dropdownMenuEntries: TaxType.values
                            .map((e) => e.name)
                            .toList()
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              style: ButtonStyle(
                                  textStyle: MaterialStateTextStyle.resolveWith(
                                      (states) => const TextStyle(
                                            fontSize: 10,
                                            // fontFamily: 'MPLUSRounded',
                                          ))),
                              value: value,
                              label: value);
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      Visibility(
                        visible: tt == TaxType.invoice,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('インボイス番号'),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                expence =
                                    expence.copyWith(invoiceNumber: value);
                                log.info('InvoiceNum : ${expence.toString()}');

                                // description = value;
                                // expence =
                                //     expence.copyWith(invoiceNumber: value);
                                // log.info('${expence.toString()}');
                                // log.info('${expence.toJson()}');
                              },
                              // maxLines: 5,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          log.info('logExpence : ${expence.toString()}');
                        },
                        child: const Text('log expence'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('log list information'),
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
  const InputDetails({super.key});
  // final Function funcCol1;
  // final Function funcCol2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etype = ref.watch(currentExpenceTypeProvider);
    if (etype == ExpenceType.transportation) {
      return Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '乗車地',
                  // style: TextStyle(fontFamily: 'MPLUSRounded'),
                  // style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    // filled: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    log.info('col1 : input: value:$value');
                    expence = expence.copyWith(col1: value);
                    log.info('col1 : ${expence.toString()}');
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
                  // style: TextStyle(fontFamily: 'MPLUSRounded'),
                  // style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    // filled: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // log.info('-------> input: value:$value');
                    // funcCol2(value);
                    log.info('col2 : input: value:$value');
                    expence = expence.copyWith(col2: value);
                    log.info('col2 : ${expence.toString()}');
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
                  // style: TextStyle(fontFamily: 'MPLUSRounded'),
                  // style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    // filled: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    log.info('input: 費用項目value:$value');
                    // funcCol1(value);
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
