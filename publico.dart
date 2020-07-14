import 'dart:async';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:masked_controller/mask.dart';
import 'package:masked_controller/masked_controller.dart';
import 'package:provider/provider.dart';
import 'package:tributos_datapar/componentes/customDrawer/custom_drawer.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:tributos_datapar/models/faturas/fatura.dart';
import 'package:tributos_datapar/models/faturas/fatura_manager.dart';
import 'package:tributos_datapar/models/user/user_manager.dart';
import 'package:tributos_datapar/screens/fatura_manual/componentes/dado_adicional_usuario.dart';

  @override
  _FaturaManualState createState() => _FaturaManualState();
}

class _FaturaManualState extends State<FaturaManual> {
  final Fatura fatura = Fatura();

  var montoTotalFatura;
  var result;
  var resultado;
  bool ativarBotao = false;
  bool esperandoResulatdo = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final DateTime _dateTime = DateTime.now();
  bool loading = false;

  var adrres;

  _recuperarDadosUsuario() {
    if (context.read<UserManeger>().address != null) {
      adrres = context.read<UserManeger>().address.ruc;
    }
  }

  _limparController() {
    _controllerRazon.clear();
    _controllerRuc.clear();
    _controllerTimbrado.clear();
    _controllerNumFactura.clear();
    _controllerTotlaFatura.clear();
    _controllerIva10.clear();
    _controllerIva05.clear();
    _controllerIvaExento.clear();
  }

  // MaskedTextController _controllerNumFactura = MaskedTextController(mask: "001-001-0000001");
  final MaskedController _controllerNumFactura =
      MaskedController(mask: Mask(mask: 'NNN-NNN-NNNNNNN'));

  final CurrencyTextFieldController _controllerTotlaFatura =
      CurrencyTextFieldController(
          rightSymbol: "", decimalSymbol: ".", thousandSymbol: ".");
  final CurrencyTextFieldController _controllerIva10 =
      CurrencyTextFieldController(
          rightSymbol: "", decimalSymbol: ".", thousandSymbol: ".");
  final CurrencyTextFieldController _controllerIva05 =
      CurrencyTextFieldController(
          rightSymbol: "", decimalSymbol: ".", thousandSymbol: ".");
  final CurrencyTextFieldController _controllerIvaExento =
      CurrencyTextFieldController(
          rightSymbol: "", decimalSymbol: ".", thousandSymbol: ".");

  TextEditingController _controllerRazon = TextEditingController();
  TextEditingController _controllerRuc = TextEditingController();
  TextEditingController _controllerTimbrado = TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarDadosUsuario();
    _limparController();
    ativarBotao = false;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: fatura,
        child: Consumer<UserManeger>(
          builder: (_, userManager, __) {
            return Scaffold(
                key: _scaffoldKey,
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: Text("Factura"),
                ),
                body: context.read<UserManeger>().address != null
                    ? Form(
                        key: _formKey,
                        child: !fatura.loading
                            ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: ListView(
                                  children: [
                                    TextFormField(
                                      controller: _controllerRazon,
                                      readOnly: fatura.loading,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                            top: 5,
                                          ),
                                          isDense: true,
                                          hintText: "EMPRESA EJEMPLO SRL",
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                            color: Colors.grey[300]
                                          ),
                                          labelText: "RAZÓN SOCIAL*",
                                          labelStyle: TextStyle(fontSize: 13)),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                      validator: (text) {
                                        if (text.isEmpty) {
                                          return "Obligatório Razón Social";
                                        } else
                                          return null;
                                      },
                                      onSaved: (rSocial) => fatura.razonSocial =
                                          _controllerRazon.text,
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          flex: 50,
                                          child: Container(
                                            child: TextFormField(
                                                controller: _controllerRuc,
                                                readOnly: fatura.loading,
                                                maxLength: 10,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                    top: 5,
                                                  ),
                                                  counterText: "",
                                                  isDense: true,
                                                  hintText: "80012345-6",
                                                  hintStyle:TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[300]
                                                  ),
                                                  labelText: "RUC",
                                                  labelStyle:
                                                      TextStyle(fontSize: 13),
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                style: TextStyle(
                                                    color: Colors.grey[800],
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                validator: (text) {
                                                  if (text.isEmpty) {
                                                    return "Obligatório informar el RUC";
                                                  } else if (text.length < 7) {
                                                    return "RUC inválido";
                                                  } else if (text.length > 10) {
                                                    return "RUC Inválido";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (ruc) =>
                                                    fatura.rucFatura =
                                                        _controllerRuc.text),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 50,
                                        ),
                                        Expanded(
                                          flex: 50,
                                          child: Container(
                                            child: TextFormField(
                                                controller: _controllerTimbrado,
                                                readOnly: fatura.loading,
                                                maxLength: 8,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          top: 5, left: 3),
                                                  counterText: "",
                                                  isDense: true,
                                                  hintText: "12345678",
                                                  hintStyle:TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[300]
                                                  ),
                                                  labelText: "TIMBRADO",
                                                  labelStyle:
                                                      TextStyle(fontSize: 13),
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                style: TextStyle(
                                                    color: Colors.grey[800],
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                validator: (comp) {
                                                  if (comp.isEmpty) {
                                                    return "debe contener 8 caracteres";
                                                  } else
                                                    return null;
                                                },
                                                onSaved: (tim) => fatura
                                                        .timbrado =
                                                    _controllerTimbrado.text),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(right: 140),
                                      child: DateTimeField(
                                        decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(top: 5),
                                            hintText: "01/01/2020",
                                            hintStyle: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[300]
                                            ),
                                            labelText: "FECHA*",
                                            labelStyle: TextStyle(fontSize: 14),
                                            isDense: false,
                                            suffixIcon: Icon(
                                              Icons.today,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            )),
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                        format: DateFormat("dd/MM/yyyy"),
                                        onShowPicker: (context, currentValue) {
                                          return showDatePicker(
                                            context: context,
                                            firstDate: DateTime(1900),
                                            initialDate:
                                                currentValue ?? _dateTime,
                                            lastDate: DateTime(2100),
                                          );
                                        },
                                        validator: (data) {
                                          if (data == null) {
                                            return "Campo Obligatório";
                                          }
                                          return null;
                                        },
                                        onSaved: (data) =>
                                            fatura.fechaVencimiento = data,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    TextFormField(
                                      controller: _controllerNumFactura,
                                      maxLength: 15,
                                      readOnly: fatura.loading,
                                      decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(top: 5),
                                          hintText: "001-001-0000001",
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[300]
                                          ),
                                          counterText: "",
                                          isDense: true,
                                          labelText: "NÚMERO DE FACTURA*",
                                          labelStyle: TextStyle(fontSize: 14)),
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: false),
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                      //inputFormatters: [maskFormatterC],
                                      validator: (text) {
                                        if (text.isEmpty) {
                                          return "Campo Obligatório";
                                        }
                                        if (text.length != 15) {
                                          return "debe ser en el Formato 001-001-00...";
                                        }
                                        return null;
                                      },
                                      onSaved: (fact) => fatura.numFactura =
                                          _controllerNumFactura.text,
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      7,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      14,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: Color(0xffe3e7eb)),
                                                  child: Center(
                                                    child: Text("PYG"),
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      7,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      14,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: Colors.white),
                                                  child: Center(
                                                    child: Text("USD"),
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 50),
                                          child: TextFormField(
                                              controller: _controllerTotlaFatura,
                                              readOnly: fatura.loading,
                                              decoration: InputDecoration(
                                                prefixStyle: TextStyle(
                                                    color: Colors.grey[800],
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                isDense: true,
                                                labelText: "Monto",
                                                labelStyle:
                                                    TextStyle(fontSize: 14),
                                              ),
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: false),
                                              style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                              onChanged: (text){
                                                final totalNovo = text.replaceAll(".", "");
                                                final totalFatura = int.tryParse(totalNovo);
                                                final result = (totalFatura / 11);
                                                final textResult = result.toString();
                                                print(textResult);
                                                setState(() {
                                                  _controllerIva10.text = textResult;
                                                });
                                              },
                                              onSaved: (total) {
                                                if (total.isEmpty) {
                                                  fatura.totalFatura = "0";
                                                } else {

                                                  fatura.totalFatura =
                                                      _controllerTotlaFatura
                                                          .text;
                                                }
                                              }),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 50),
                                          child: TextFormField(
                                              controller: _controllerIva10,
                                              readOnly: fatura.loading,
                                              decoration: InputDecoration(
                                                prefixStyle: TextStyle(
                                                    color: Colors.grey[800],
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                isDense: true,
                                                labelText: "Iva 10%",
                                                labelStyle:
                                                    TextStyle(fontSize: 14),
                                              ),
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: false),
                                              style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                              onSaved: (text) {
                                                if (text.isEmpty) {
                                                  fatura.iva10 = "0";
                                                } else {
                                                  fatura.iva10 =
                                                      _controllerIva10.text;
                                                }
                                              }),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 50),
                                          child: TextFormField(
                                              controller: _controllerIva05,
                                              readOnly: fatura.loading,
                                              decoration: InputDecoration(
                                                prefixStyle: TextStyle(
                                                    color: Colors.grey[800],
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                isDense: true,
                                                labelText: "Iva 5%",
                                                labelStyle:
                                                    TextStyle(fontSize: 14),
                                              ),
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: false),
                                              style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                              onSaved: (text) {
                                                if (text.isEmpty) {
                                                  fatura.iva05 = "0";
                                                } else {
                                                  fatura.iva05 =
                                                      _controllerIva05.text;
                                                }
                                              }),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 50),
                                          child: TextFormField(
                                              readOnly: fatura.loading,
                                              decoration: InputDecoration(
                                                prefixStyle: TextStyle(
                                                    color: Colors.grey[800],
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                isDense: true,
                                                labelText: "Exento",
                                                labelStyle:
                                                    TextStyle(fontSize: 14),
                                              ),
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: false),
                                              style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                              onSaved: (exento) {
                                                if (exento.isEmpty) {
                                                  fatura.ivaExento = "0";
                                                } else {
                                                  fatura.ivaExento =
                                                      _controllerIvaExento.text;
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RaisedButton(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 35, vertical: 12),
                                          color:  Color(0xff8ec549),
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _formKey.currentState.save();

                                              final ruc = context
                                                  .read<UserManeger>()
                                                  .address
                                                  .ruc;
                                              final idUsuarioAtual = context
                                                  .read<UserManeger>()
                                                  .user
                                                  .id;
                                              if (ruc != null) {
                                                _formKey.currentState.save();

                                                print(fatura.totalFatura);
                                                try {
                                                  context
                                                      .read<FaturaManager>()
                                                      .setFatura(
                                                          fatura,
                                                          ruc,
                                                          idUsuarioAtual,
                                                          _dateTime);

                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 3),
                                                            () {
                                                          _limparController();
                                                          Navigator.of(context)
                                                              .pop(true);
                                                        });
                                                        return Dialog(
                                                            backgroundColor:
                                                                Color(
                                                                    0xff8ec549),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                const SizedBox(
                                                                    height: 70),
                                                                Container(
                                                                  height: 100,
                                                                  width: 100,
                                                                  decoration: BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image:
                                                                              AssetImage("images/icons/formar.png"))),
                                                                ),
                                                                const SizedBox(
                                                                    height: 50),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "Factura Gurdada",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              25),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                    height: 35),
                                                                const SizedBox(
                                                                    height: 50),
                                                              ],
                                                            ));
                                                      });
                                                } catch (erro) {
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content:
                                                        Text(" Falla: $erro"),
                                                  ));
                                                }
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        DadoAdicionalUsuario());
                                              }
                                            }
                                          },
                                          child: Text(
                                            "CONFIRMAR",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: 50,
                                    )
                                  ],
                                ))
                            : Container(
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Guardando datos...!!!",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.green),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                                ),
                              ))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Ingresar Datos Personales!",
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          RaisedButton(
                            textColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed("/dado_adicional_usuario");
                            },
                            child: Text(
                              "Ingresar",
                            ),
                          )
                        ],
                      ));
          },
        ));
  }
}
