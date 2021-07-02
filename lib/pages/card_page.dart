import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

bool isCardValid(String? cardNumber) {
  int sum = 0;
  if (cardNumber != null && cardNumber.length >= 13) {
    List<String> card = cardNumber.replaceAll(new RegExp(r"\s+"), "").split("");
    int i = 0;
    card.reversed.forEach((num) {
      int digit = int.parse(num);
      i.isEven
          ? sum += digit
          : digit >= 5
              ? sum += (digit * 2) - 9
              : sum += digit * 2;
      i++;
    });
  }
  return sum % 10 == 0 && sum != 0;
}

Future<Widget> checkCardBanner(String card) async {
  card = card.replaceAll(new RegExp(r"\s+"), "");
  if (RegExp(r'^4\d{12}(\d{3})?$').hasMatch(card))
    return Image.asset('lib/assets/images/visa.png', height: 30);
  if (RegExp(r'^5[1-5]\d{14}$').hasMatch(card))
    return Image.asset('lib/assets/images/mastercard.png', height: 50);
  if (RegExp(r'^3[47]\d{13}$').hasMatch(card))
    return Image.asset('lib/assets/images/amex.png', height: 60);
  return Container();
}

class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  TextEditingController textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Widget bandeira = Container();
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.586,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 8,
                              blurRadius: 100,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 90,
                              left: 20,
                              child: Text(
                                textController.text.isNotEmpty
                                    ? textController.text
                                    : "XXXX XXXX XXXX XXXX",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: 20,
                              child: bandeira,
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: textController,
                        validator: (value) {
                          isValid = isCardValid(value);
                          if (isValid) {
                            return 'Cartão Válido';
                          } else {
                            return 'Cartão Inválido';
                          }
                        },
                        inputFormatters: [
                          TextInputMask(mask: '9999 9999 9999 9999'),
                        ],
                        onChanged: (_) {
                          setState(() {
                            checkCardBanner(textController.text).then(
                                (imagemBandeira) => bandeira = imagemBandeira);
                          });
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: isValid ? Colors.green : Colors.red,
                              width: 1,
                            ),
                          ),
                          labelText: 'Número',
                          hintText: 'XXXX XXXX XXXX XXXX',
                          errorStyle: TextStyle(
                              color: isValid ? Colors.green : Colors.red),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: isValid ? Colors.green : Colors.red,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF646464),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF646464),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 25, horizontal: 15),
                          suffixIcon: textController.text.isNotEmpty
                              ? InkWell(
                                  onTap: () => setState(
                                    () => textController.clear(),
                                  ),
                                  child: Icon(
                                    Icons.clear,
                                    color: Color(0xFF757575),
                                    size: 22,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.lightBlue[900],
                              minimumSize: Size(
                                120,
                                40,
                              ),
                            ),
                            onPressed: () {
                              setState(() => _formKey.currentState!.validate());
                            },
                            child: Text(
                              "Validar",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
