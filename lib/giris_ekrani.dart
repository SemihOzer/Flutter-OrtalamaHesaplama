import 'package:flutter/material.dart';
import 'ders.dart';

class GirisEkrani extends StatefulWidget {
  @override
  _GirisEkraniState createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final _dersField = GlobalKey<FormState>();
  final _notkey = GlobalKey<FormState>();
  int gelenSeciliKredi = 1;
  String gelenDersAdi;
  int gelenNot;
  int toplamDers = 0;
  int toplamKredi = 0;
  int toplamNot = 0;
  static int sayac = 0;

  double ortalama = 0.0;

  bool isNot = true;
  List<Ders> dersler = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _notController = TextEditingController();
  FocusNode _notNode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_dersField.currentState.validate() &&
                _notkey.currentState.validate()) {
              //Eğer Ders İsmini ve Notunu Doğru Girdiyse
              _dersField.currentState.save();
              _notkey.currentState.save();
              Ders yeniDers = Ders(gelenSeciliKredi, gelenNot, gelenDersAdi);

              FocusScope.of(context).requestFocus(FocusNode());

              setState(() {
                dersler.add(yeniDers);
              });

              toplamDers++;

              int sayi = 0;
              int krediNot = 0;
              for (int i = 0; i < dersler.length; i++) {
                setState(() {
                  sayi = sayi + dersler[i].kredi;
                  toplamKredi = sayi;

                  krediNot = krediNot + (dersler[i].kredi * dersler[i].not);
                  ortalama = krediNot / toplamKredi;
                  debugPrint(ortalama.toString());
                });
              }

              _nameController.clear();
              _notController.clear();
            } else {
              //Eğer Ders İsmini ve Notunu Doğru Girmediyse
            }

            if (_notkey.currentState.validate()) {
              //Eğer Notunu Doğru Girdiyse

              setState(() {
                isNot = true;
              });
            } else {
              //Eğer Notunu Doğru Girmediyse

              setState(() {
                isNot = false;
              });
            }
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.red.shade700,
        ),
        appBar: AppBar(
          title: Text("Ortalama Hesaplama"),
        ),
        body: Column(
          children: [
            dersEkle(),
            ortalamaGoster(),
            dersListesi(),
          ],
        ));
  }

  Widget dersEkle() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _dersField,
            child: TextFormField(
              controller: _nameController,
              onSaved: (value) {
                gelenDersAdi = value;
              },
              autocorrect: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Lütfen Ders İsmi Giriniz';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Dersi Giriniz",
                labelStyle:
                    TextStyle(fontSize: 18, color: Colors.blue.shade700),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red.shade700),
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red.shade700),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20),
              width: isNot == true ? 80 : 118,
              child: Form(
                  key: _notkey,
                  child: TextFormField(
                    controller: _notController,
                    onSaved: (value) {
                      gelenNot = int.parse(value);
                    },
                    autocorrect: true,
                    validator: (value) {
                      if (int.parse(value) < 0 || int.parse(value) > 100) {
                        return 'Geçerli Not Giriniz';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    maxLengthEnforced: true,
                    focusNode: _notNode,
                    decoration: InputDecoration(
                      counter: Text(""),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red.shade700),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red.shade700),
                      ),
                      labelText: "NOT",
                      labelStyle:
                          TextStyle(color: Colors.blue.shade700, fontSize: 18),
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: DropdownButton(
                  style: TextStyle(color: Colors.blue.shade700, fontSize: 18),
                  items: krediItems(),
                  value: gelenSeciliKredi,
                  onChanged: (value) {
                    setState(() {
                      gelenSeciliKredi = value;
                    });
                  }),
            )
          ],
        )
      ],
    );
  }

  List<DropdownMenuItem<int>> krediItems() {
    List<DropdownMenuItem<int>> krediler = [];

    for (int i = 1; i <= 10; i++) {
      krediler.add(DropdownMenuItem<int>(
          child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(4),
              child: Text("$i Kredi"),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.shade700))),
          value: i));
    }
    return krediler;
  }

  Widget ortalamaGoster() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.red.shade700)),
      height: 150,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Toplam Ders Sayısı : $toplamDers ",
                style: TextStyle(fontSize: 20, color: Colors.blue.shade700)),
            Text("Toplam Kredi Sayısı : $toplamKredi",
                style: TextStyle(fontSize: 20, color: Colors.blue.shade700)),
            Text(dersler.length == 0 ? "Lütfen Ders Giriniz" : "Ortalama : ${ortalama.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 30, color: Colors.blue.shade700)),
          ]),
    );
  }

  Widget dersListesi() {
    return Expanded(
        child: ListView.builder(
            itemCount: dersler.length,
            itemBuilder: (context, i) {
              sayac++;
              return Dismissible(
                key: Key(sayac.toString()),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {
                  setState(() {
                    toplamDers--;
                    toplamKredi = toplamKredi - dersler[i].kredi;
                    dersler.removeAt(i);
                    

                    int krediNot = 0;
                    for (int i = 0; i < dersler.length; i++) {
                      krediNot = krediNot + (dersler[i].kredi * dersler[i].not);
                      ortalama = krediNot / toplamKredi;
                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    subtitle: Text(
                      "Not: ${dersler[i].not}",
                    ),
                    leading: Column(
                      children: [
                        Text("Kredi"),
                        Text("${dersler[i].kredi}"),
                      ],
                    ),
                    title: Text(
                      "${dersler[i].name}",
                      style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }));
  }
}
