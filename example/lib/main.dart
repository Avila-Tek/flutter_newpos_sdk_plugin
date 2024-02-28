// ignore_for_file: unused_field

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_newpos_sdk/flutter_newpos_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String _platformVersion = 'Unknown';
  final _flutterNewposSdkPlugin = FlutterNewposSdk.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: FindDevicesScreen());
  }
}

final snackBarKeyA = GlobalKey<ScaffoldMessengerState>();
final snackBarKeyB = GlobalKey<ScaffoldMessengerState>();
final snackBarKeyC = GlobalKey<ScaffoldMessengerState>();

class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen({super.key});

  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  BluetoothDevice? deviceConnected;
  DeviceInfo? deviceInfo;
  ReadCardInfo? readCardInfo;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: snackBarKeyB,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('POS N98 - Demo'),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {}); // force refresh of connectedSystemDevices
            if (FlutterNewposSdk.isScanningNow == false) {
              FlutterNewposSdk.scanBluetoothDevices(
                timeout: const Duration(seconds: 5),
              );
            }
            return Future.delayed(
              const Duration(milliseconds: 500),
            ); // show refresh icon breifly
          },
          child: StreamBuilder<bool>(
            stream: FlutterNewposSdk.isScanning,
            builder: (context, snapshot) {
              final isScanning = snapshot.data ?? false;

              if (deviceConnected != null) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      if (readCardInfo != null)
                        const Icon(
                          Icons.check_circle_outline_outlined,
                          size: 100,
                          color: Colors.greenAccent,
                        ),
                      if (readCardInfo != null)
                        ReadCardView(readCardInfo: readCardInfo!),
                      if (readCardInfo != null)
                        const SizedBox(
                          height: 20,
                        ),
                      if (readCardInfo != null) const Divider(),
                      const SizedBox(
                        height: 20,
                      ),
                      if (readCardInfo != null)
                        ElevatedButton(
                          onPressed: () {},
                          child: const Center(
                            child: Text('Procesar pago'),
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (deviceConnected != null)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          onPressed: () async {
                            try {
                              LoadingDialog.show(context);
                              final success =
                                  await FlutterNewposSdk.disconnectDevice();
                              if (success) {
                                setState(() {
                                  deviceConnected = null;
                                  readCardInfo = null;
                                  deviceInfo = null;
                                });
                              }
                              LoadingDialog.hide(context);
                            } catch (e) {
                              LoadingDialog.hide(context);
                            }
                          },
                          child: const Center(
                            child: Text('Desconectar'),
                          ),
                        ),
                      if (readCardInfo != null) const Divider(),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        deviceConnected!.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        deviceConnected!.address,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (readCardInfo == null)
                        FutureBuilder(
                          future: FlutterNewposSdk.getDeviceInfo(),
                          builder: (context, snapshot) {
                            final data = snapshot.data;
                            if (data == null) {
                              return const CircularProgressIndicator();
                            }

                            return DeviceInfoView(data: data);
                          },
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (readCardInfo == null)
                        Column(
                          children: [
                            // ElevatedButton(
                            //   onPressed: () async {
                            //     try {
                            //       LoadingDialog.show(context);
                            //       const masterkey =
                            //           '206FF105BFCD92E629F5CBD19E2E70CF';
                            //       const dukptIPEK = masterkey;
                            //       const dukptIKSN = 'FFFF1234560000000000';

                            //       await FlutterNewposSdk.updateMasterKey(
                            //         masterKey: dukptIPEK + dukptIKSN,
                            //         ifDukpt: true,
                            //       );
                            //       LoadingDialog.hide(context);
                            //     } catch (e) {
                            //       LoadingDialog.hide(context);
                            //     }
                            //   },
                            //   child: const Center(
                            //     child: Text('Update masterKey'),
                            //   ),
                            // ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await FlutterNewposSdk.displayText(
                                  text: 'Hello World',
                                );
                              },
                              child: const Center(
                                child: Text('Hello World'),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // ElevatedButton(
                            //   onPressed: () async {
                            //     try {
                            //       LoadingDialog.show(context);

                            //       await FlutterNewposSdk.clearAids();
                            //       ScaffoldMessenger.of(context).showSnackBar(
                            //         const SnackBar(
                            //           content: Text('Success clear aids'),
                            //         ),
                            //       );
                            //       LoadingDialog.hide(context);
                            //     } catch (e) {
                            //       LoadingDialog.hide(context);
                            //     }
                            //   },
                            //   child: const Center(
                            //     child: Text('CLEAR AIDS'),
                            //   ),
                            // ),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            // ElevatedButton(
                            //   onPressed: () async {
                            //     try {
                            //       LoadingDialog.show(context);
                            //       await FlutterNewposSdk.addAids();
                            //       ScaffoldMessenger.of(context).showSnackBar(
                            //         const SnackBar(
                            //           content: Text('Success aids added'),
                            //         ),
                            //       );
                            //       LoadingDialog.hide(context);
                            //     } catch (e) {
                            //       LoadingDialog.hide(context);
                            //     }
                            //   },
                            //   child: const Center(
                            //     child: Text('ADD AIDS'),
                            //   ),
                            // ),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  LoadingDialog.show(context);
                                  final result = await FlutterNewposSdk
                                      .completeTransaction(
                                    amount: 1000,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Tarjeta obtenida con éxito'),
                                    ),
                                  );
                                  setState(() {
                                    readCardInfo = result.card;
                                  });
                                  LoadingDialog.hide(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Error leyendo tarjeta'),
                                    ),
                                  );
                                  LoadingDialog.hide(context);
                                } finally {}
                              },
                              child: const Center(
                                child: Text('Empezar transacción'),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              }

              return Column(
                children: <Widget>[
                  if (isScanning) const ScanningTextInfo(),
                  const ScanDevicesTextButton(),
                  Expanded(
                    child: StreamBuilder<List<DeviceScanned>>(
                      stream: FlutterNewposSdk.scanResults,
                      initialData: const [],
                      builder: (c, snapshot) {
                        final devices = snapshot.data ?? [];
                        if (devices.isEmpty) {
                          return const Center(
                            child: Text('No devices found'),
                          );
                        }
                        return ListView(
                          shrinkWrap: true,
                          children: (snapshot.data ?? [])
                              .map(
                                (r) => ScanResultTile(
                                  result: r,
                                  connected: r.device.address ==
                                      deviceConnected?.address,
                                  onTap: () async {
                                    final connected = await FlutterNewposSdk
                                        .connectToBluetoothDevice(
                                      r.device.address,
                                    );

                                    log('Is connected $connected');

                                    if (connected) {
                                      setState(() {
                                        deviceConnected = r.device;
                                      });
                                    }
                                  },
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                  if (deviceConnected != null)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: () async {
                          await FlutterNewposSdk.displayText(
                              text: 'Hello World');
                        },
                        child: const Center(
                          child: Text('Hello World'),
                        ),
                      ),
                    ),
                  if (deviceConnected != null)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            const masterkey =
                                '206FF105BFCD92E629F5CBD19E2E70CF';
                            const dukptIPEK = masterkey;
                            const dukptIKSN = 'FFFF1234560000000000';
                            LoadingDialog.show(context);
                            await FlutterNewposSdk.updateMasterKey(
                              masterKey: dukptIPEK + dukptIKSN,
                              ifDukpt: true,
                            );
                          } finally {
                            LoadingDialog.hide(context);
                          }
                        },
                        child: const Center(
                          child: Text('Update masterKey'),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (deviceConnected != null)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            LoadingDialog.show(context);
                            // await FlutterNewposSdk.addRids();
                          } finally {
                            LoadingDialog.hide(context);
                          }
                        },
                        child: const Center(
                          child: Text('Add RIDS'),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (deviceConnected != null)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: () async {
                          // await FlutterNewposSdk.addAids();
                        },
                        child: const Center(
                          child: Text('Add AIDS'),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (deviceConnected != null)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: () async {
                          await FlutterNewposSdk.getCardNumber();
                        },
                        child: const Center(
                          child: Text('Get card info'),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: deviceConnected != null
            ? null
            : StreamBuilder<bool>(
                stream: FlutterNewposSdk.isScanning,
                initialData: false,
                builder: (c, snapshot) {
                  if (snapshot.data ?? false) {
                    return const StopScanningFab();
                  } else {
                    return FloatingActionButton(
                      child: const Text('SCAN'),
                      onPressed: () async {
                        try {
                          await FlutterNewposSdk.scanBluetoothDevices(
                            timeout: const Duration(seconds: 10),
                          );
                          // await FlutterBluePlus.startScan(
                          //   timeout: const Duration(seconds: 15),
                          // );
                        } catch (e) {
                          // final snackBar =
                          //     snackBarFail(prettyException('Start Scan Error:', e));
                          // snackBarKeyB.currentState?.removeCurrentSnackBar();
                          // snackBarKeyB.currentState?.showSnackBar(snackBar);
                        }
                        setState(
                          () {},
                        ); // force refresh of connectedSystemDevices
                      },
                    );
                  }
                },
              ),
      ),
    );
  }
}

class StopScanningFab extends StatelessWidget {
  const StopScanningFab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        try {
          await FlutterNewposSdk.stopScan();
        } catch (e) {
          // final snackBar =
          //     snackBarFail(prettyException('Stop Scan Error:', e));
          // snackBarKeyB.currentState?.removeCurrentSnackBar();
          // snackBarKeyB.currentState?.showSnackBar(snackBar);
        }
      },
      backgroundColor: Colors.red,
      child: const Icon(Icons.stop),
    );
  }
}

class ScanDevicesTextButton extends StatelessWidget {
  const ScanDevicesTextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        // await platform.invokeMethod('scanBlueDevice');
        await FlutterNewposSdk.scanBluetoothDevices(
          timeout: const Duration(seconds: 5),
        );
      },
      child: const Center(child: Text('Scan devices')),
    );
  }
}

class ScanningTextInfo extends StatelessWidget {
  const ScanningTextInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Scanning...'),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}

class ReadCardView extends StatelessWidget {
  const ReadCardView({
    required this.readCardInfo,
    super.key,
  });

  final ReadCardInfo readCardInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreditCardWidget(
          cardNumber: readCardInfo.cardNumber,
          expiryDate: readCardInfo.expirationDate,
          cardHolderName: readCardInfo.cardholderName ?? '',
          cvvCode: '',
          showBackView: false,
          onCreditCardWidgetChange: (_) {},
        ),
        Row(
          children: [
            const Text('Card Type'),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  readCardInfo.readCardMethod.toString(),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text('Track 2'),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  readCardInfo.track2.toString(),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text('ENCRYPT PIN'),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  readCardInfo.encryptPin.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text('ENCRYPT SN'),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  readCardInfo.encryptedSN.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text('IC55 DATA: '),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  readCardInfo.ic55Data.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DeviceInfoView extends StatelessWidget {
  const DeviceInfoView({
    required this.data,
    super.key,
  });

  final DeviceInfo data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text('Firmware'),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      data.firmwareVersion,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Device Type'),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(data.deviceType),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                const Text('KSN'),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(data.ksn),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                const Text('currentElePer'),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      data.currentElePer.toString(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // FutureBuilder(
            //   future: FlutterNewposSdk.getDeviceInfo(),
            //   builder: (context, snapshot) {
            //     final data = snapshot.data;

            //     if (data == null) {
            //       return const CircularProgressIndicator();
            //     }

            //     return Text(data.toString());
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({
    required this.result,
    required this.connected,
    super.key,
    this.onTap,
  });

  final DeviceScanned result;
  final VoidCallback? onTap;
  final bool connected;

  @override
  Widget build(BuildContext context) {
    if (result.device.name.isNotEmpty) {
      return ListTile(
        onTap: onTap,
        tileColor: connected ? Colors.blue.shade100 : null,
        leading: Icon(
          Icons.bluetooth,
          color: connected ? Colors.blue : null,
        ),
        title: Text(
          result.device.name,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          result.device.address,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    } else {
      return ListTile(
        leading: const Icon(Icons.bluetooth),
        title: Text(
          result.device.address,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }
}

class LoadingDialog extends StatelessWidget {
  /// {@macro loading_dialog}
  const LoadingDialog({super.key});

  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(20),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
