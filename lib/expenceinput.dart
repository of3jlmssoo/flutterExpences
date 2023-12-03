// todo: price field
// input tranportation
// input next (price field left as it was)
//
// done: 経費種別を選ばないとnulになる
// todo: 経費種別=transporationで入力した内容が経費種別=othersにしても残る
// done: taxtype enum化
// done: taxType default
// todo: validator
// todo: save button
//
//
// dart run build_runner build expenceinput.dart

import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:riverpodtest/expences.dart';
import 'package:uuid/uuid.dart';

import 'enums.dart';
import 'expence.dart';
import 'expenceproviders.dart';

var uuid = const Uuid();
final log = Logger('ExpenceInputLogger');

Expence expence = Expence(
  userID: 'dummyuserid',
  reportID: 'dummyreportid',
  id: 'dumyyid',
  createdDate: DateTime.now(),
  expenceDate: DateTime.now(),
  expenceType: ExpenceType.transportation.id,
  taxType: TaxType.invoice.id,
);

class ExpenceInput extends ConsumerStatefulWidget {
  String reportID;
  String userID;
  String id;
  String? expenceTypeName;
  String? taxTypeName;
  DateTime? createdDate;
  DateTime? expenceDate;
  String? col1;
  String? col2;
  String? col3;
  int? price;
  String? invoiceNumber;
  String reportName;

  String createdDateStr;
  String? expenceDateStr;
  String? priceStr;

  ExpenceInput({
    super.key,
    required this.reportID,
    required this.userID,
    required this.id,
    required this.createdDateStr,
    this.expenceTypeName,
    this.taxTypeName,
    this.expenceDateStr,
    this.col1,
    this.col2,
    this.col3,
    this.priceStr,
    this.invoiceNumber,
    required this.reportName,
  });

  @override
  ExpenceInputState createState() => ExpenceInputState();
}

class ExpenceInputState extends ConsumerState<ExpenceInput> {
  final _priceFieldController = TextEditingController(
      text: expence.price != null ? expence.price.toString() : '');

  @override
  void initState() {
    super.initState();

    ExpenceType expenceType = ExpenceType.transportation;
    for (var type in ExpenceType.values) {
      if (widget.expenceTypeName == type.name) {
        expenceType = type;
        break;
      }
    }
    // // ref.read(currentExpenceTypeProvider.notifier).expenceType(expenceType);
    //
    TaxType taxType = TaxType.invoice;
    for (var type in TaxType.values) {
      if (widget.taxTypeName == type.name) {
        taxType = type;
        break;
      }
    }
    // // ref.read(currentTaxTypeProvider.notifier).taxType(taxType);

    log.info('initState : ${widget.createdDateStr} ${widget.expenceDateStr}');

    expence = expence.copyWith(
      userID: widget.userID,
      reportID: widget.reportID,
      id: widget.id,
      createdDate: DateTime.parse(widget.createdDateStr!),
      expenceType: expenceType.id,
      expenceDate: DateTime.parse(widget.expenceDateStr!),
      // price: int.parse(widget.priceStr!),
      // col1: widget.col1,
      // col2: widget.col2,
      // col3: widget.col3,
      taxType: taxType.id,
      // invoiceNumber: widget.invoiceNumber,
    );
    if (widget.priceStr != null) {
      expence = expence.copyWith(price: int.parse(widget.priceStr!));
    }

    if (widget.priceStr != null) {
      log.info('priceStr is not null! ${widget.priceStr} and ${expence.price}');
      expence = expence.copyWith(price: int.parse(widget.priceStr!));
    }

    if (widget.col1 != null) {
      expence = expence.copyWith(col1: widget.col1);
    } else {
      expence = expence.copyWith(col1: '');
    }

    if (widget.col2 != null) {
      expence = expence.copyWith(col2: widget.col2);
    } else {
      expence = expence.copyWith(col2: '');
    }

    if (widget.col3 != null) {
      expence = expence.copyWith(col3: widget.col3);
    } else {
      expence = expence.copyWith(col3: '');
    }
    if (widget.invoiceNumber != null) {
      expence = expence.copyWith(invoiceNumber: widget.invoiceNumber);
    } else {
      expence = expence.copyWith(invoiceNumber: '');
    }

    log.info('initState 1 : ${expence.toString()}');
  }

  final _formKey = GlobalKey<FormState>();

  String title = '';
  String description = '';
  DateTime expenceDate = DateTime.now();
  double maxValue = 0;
  bool? brushedTeeth = false;
  bool enableFeature = false;

  final DateTime _date = DateTime.now();

  static const List<String> taxTypeList = <String>['one', 'two', 'Three', '直'];

  var expenceTypeDefault =
      <String?>[ExpenceType.values.map((e) => e.name).toList().first].first;
  var taxTypeDefault =
      <String>[TaxType.values.map((e) => e.name).toList().first].first;

  @override
  Widget build(BuildContext context) {
    final et = ref.watch(currentExpenceTypeProvider);
    final tt = ref.watch(currentTaxTypeProvider);
    final ed = ref.watch(currentExpenceDateProvider);
    final pr = ref.watch(currentPriceProvider);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back, color: Colors.black),
          onTap: () => Router.neglect(context, () {
            context.goNamed("expencescreen", queryParameters: {
              'reportID': widget.reportID,
              'userID': widget.userID,
              'reportName': widget.reportName,
            });
          }),
        ),
        title: const Text(
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
                        ),

                        initialSelection: et.name,

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
                        dropdownMenuEntries: ExpenceType.values
                            .map((e) => e.name)
                            .toList()
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              style: ButtonStyle(
                                  textStyle: MaterialStateTextStyle.resolveWith(
                                      (states) => const TextStyle(
                                            fontSize: 10,
                                          ))),
                              value: value,
                              label: value);
                        }).toList(),
                      ),
                      // ),
                      const SizedBox(height: 20),
                      const Text(
                        '日付',
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
                          TextButton(
                            child: const Text(
                              '日付指定',
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
                                log.info('日付1 : ${expence.toString()}');
                                log.info('日付2 : ${DateTime.now().toString()}');
                                log.info(
                                    '日付3 : ${DateTime.parse(DateTime.now().toString())}');
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const InputDetails(),
                      const SizedBox(height: 20),
                      const Text(
                        '金額',
                      ),

                      TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              num.tryParse(value) == null) {
                            return '半角数字を入力してください';
                          }
                          return null;
                        },
                        initialValue: pr == null ? '' : pr.toString(),
                        // controller: _priceFieldController,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          // filled: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          expence = expence.copyWith(price: int.parse(value));
                        },
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'メモ',
                      ),
                      TextFormField(
                        initialValue: expence.col3,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          expence = expence.copyWith(col3: value);
                          log.info('メモ : ${expence.toString()}');
                        },
                        maxLines: 5,
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        '税タイプ',
                      ),
                      DropdownMenu<String>(
                        trailingIcon:
                            const Icon(Icons.arrow_drop_down, size: 10),
                        inputDecorationTheme: InputDecorationTheme(
                          isDense: true,
                          constraints:
                              BoxConstraints.tight(const Size.fromHeight(45)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                        ),
                        initialSelection: tt.name,
                        onSelected: (String? value) {
                          late TaxType tType;
                          for (var type in TaxType.values) {
                            if (value == type.name) {
                              tType = type;
                              break;
                            }
                          }
                          expence = expence.copyWith(taxType: tType.id);
                          ref
                              .read(currentTaxTypeProvider.notifier)
                              .taxType(tType);
                          log.info('TaxType : ${expence.toString()}');
                        },
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
                              validator: (value) {
                                if (expence.taxType == TaxType.invoice &&
                                        (value == null || value.isEmpty) ||
                                    value?.length != 3 ||
                                    num.tryParse(value!)! == null) {
                                  return 'インボイス番号(3桁)を入力してください';
                                }
                                return null;
                              },
                              initialValue: expence.invoiceNumber,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                expence =
                                    expence.copyWith(invoiceNumber: value);
                                log.info('InvoiceNum : ${expence.toString()}');
                              },
                              // maxLines: 5,
                            ),
                          ],
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ref
                                .read(expenceListProvider.notifier)
                                .addExpence(expence);

                            log.info(
                                'add/update ------> expence.expenceType:${expence.expenceType}');
                            log.info(
                                'add/update ------> expence.expenceType:${expence.expenceType}');

                            var db = FirebaseFirestore.instance;

                            final expenceRef = db
                                .collection('users')
                                .doc(widget.userID)
                                .collection('reports')
                                .doc(widget.reportID)
                                .collection('expences')
                                .withConverter(
                                  fromFirestore: Expence.fromFirestore,
                                  toFirestore: (Expence expence, options) =>
                                      expence.toFirestore(),
                                )
                                .doc(widget.id);
                            await expenceRef.set(expence);

// final city = City(
//   name: "Los Angeles",
//   state: "CA",
//   country: "USA",
//   capital: false,
//   population: 5000000,
//   regions: ["west_coast", "socal"],
// );
// final docRef = db
//     .collection("cities")
//     .withConverter(
//       fromFirestore: City.fromFirestore,
//       toFirestore: (City city, options) => city.toFirestore(),
//     )
//     .doc("LA");
// await docRef.set(city);

                            context.goNamed("expencescreen", queryParameters: {
                              'reportID': widget.reportID,
                              'userID': widget.userID,
                              'reportName': widget.reportName,
                            });
                            _priceFieldController.clear();
                          }
                        },
                        child: const Text('追加/更新'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          log.info('logExpence : ${expence.toString()}');
                        },
                        child: const Text('入力データ確認'),
                      ),
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

class InputDetails extends ConsumerWidget {
  const InputDetails({super.key});

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
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "乗車地を入力してください";
                    }
                    return null;
                  },
                  initialValue: expence.col1,
                  decoration: const InputDecoration(
                    // filled: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    log.info('col1(then) : input: value:$value');
                    expence = expence.copyWith(col1: value);
                    log.info('col1(then) : ${expence.toString()}');
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
                ),
                TextFormField(
                  validator: (value) {
                    if (expence.expenceType == ExpenceType.transportation &&
                        (value == null || value.isEmpty)) {
                      return "降車地を入力してください";
                    }
                    return null;
                  },
                  initialValue: expence.col2,
                  decoration: const InputDecoration(
                    // filled: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
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
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "費用項目を入力してください";
                    }
                    return null;
                  },
                  initialValue: expence.col1,
                  decoration: const InputDecoration(
                    // filled: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    log.info('input: 費用項目value:$value');
                    log.info('col1(else) : input: value:$value');
                    expence = expence.copyWith(col1: value);
                    log.info('col1(else) : ${expence.toString()}');
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
