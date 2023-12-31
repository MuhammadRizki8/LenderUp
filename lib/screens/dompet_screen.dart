import 'package:flutter/material.dart';
import 'package:lender_up/reuseable_widgets/With_Draw.dart';
import 'package:lender_up/reuseable_widgets/card_transaksi.dart';
import 'package:lender_up/reuseable_widgets/reusable_widged.dart';
import 'package:lender_up/reuseable_widgets/Top_Up.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DompetScreen extends StatefulWidget {
  final String accessToken;
  const DompetScreen({Key? key, required this.accessToken}) : super(key: key);

  @override
  DompetScreenState createState() => DompetScreenState();
}

class DompetScreenState extends State<DompetScreen> {
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _borrowerData;
  Map<String, dynamic>? _dompetData;
  List<Map<String, dynamic>> _transaksiData = [];
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final url = Uri.parse('http://localhost:8000/user');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${widget.accessToken}'},
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      setState(() {
        _userData = userData;
      });
      print(_userData); // Mencetak data pengguna ke konsol
      if (_userData?["no_tlp"] != null) {
        _fetchUserBorrower();
        _fetchUserDompet();
      }
    } else {
      // Handle error response
    }
  }

  Future<void> _fetchUserBorrower() async {
    final url = Uri.parse('http://localhost:8000/borrower/${_userData?["ID"]}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final borrowerData = jsonDecode(response.body);
      setState(() {
        _borrowerData = borrowerData;
      });
      print(_borrowerData);
    } else {
      // Handle error response
    }
  }

  Future<void> _fetchUserDompet() async {
    final url = Uri.parse('http://localhost:8000/dompet/${_userData?["ID"]}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dompetData = jsonDecode(response.body);
      setState(() {
        _dompetData = dompetData;
      });
      print(_dompetData);
      _fetchUserTransaksi();
    } else {
      // Handle error response
    }
  }

  Future<void> _fetchUserTransaksi() async {
    final url = Uri.parse(
        'http://localhost:8000/tampil_semua_transaksi/${_dompetData?["data"]['id_dompet']}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'] != null) {
        setState(() {
          _transaksiData = List<Map<String, dynamic>>.from(data['data']);
          // print(pinjamanData); // Cetak isi data pinjaman
        });
      } else {
        // Error handling jika data tidak tersedia
        print('Data pinjaman tidak tersedia.');
      }
      print(_transaksiData);
    } else {
      // Handle error response
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lender Up',
      home: Scaffold(
        backgroundColor: const Color(0xFF1D3557),
        body: ListView(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("DOMPET",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                      ))),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dana Tersedia',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'RP. ${_dompetData?["data"]["saldo"]}',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Color(0xffFFB703),
                        fontSize: 25,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50, bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TopUp(
                                id_dompet: _dompetData?["data"]["id_dompet"])),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFB703),
                          ),
                          child: Transform.scale(
                            scale: 1.2, // faktor skala
                            child: Icon(
                              Icons.add,
                              color: const Color(0xFF1D3557),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Top Up',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                            ))),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WithDraw(
                                id_dompet: _dompetData?["data"]["id_dompet"])),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFB703),
                          ),
                          child: Transform.scale(
                            scale: 1.2, // faktor skala
                            child: Icon(
                              Icons.arrow_downward,
                              color: const Color(0xFF1D3557),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Withdraw',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                            ))),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Riwayat()),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFB703),
                          ),
                          child: Transform.scale(
                            scale: 1.2, // faktor skala
                            child: Icon(
                              Icons.list,
                              color: const Color(0xFF1D3557),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Riwayat',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                            ))),
                        Text('Transaksi',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                            ))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 8),
              // child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              child: Text('AKTIVITAS :',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                  ))),
            ),

            SizedBox(height: 20.0),
            // Generate cards using a loop
            for (var data in _transaksiData)
              cardTransaksi(data['jenis_transaksi'], data['tanggal'].toString(),
                  data['jumlah'].toString()),
          ],
        ),
      ),
    );
  }
}

class Riwayat extends StatefulWidget {
  const Riwayat({Key? key}) : super(key: key);

  @override
  RiwayatState createState() => RiwayatState();
}

class RiwayatState extends State<Riwayat> {
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildProfileAppBar(context, "Riwayat"),
      backgroundColor: const Color(0xFF1D3557),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('DOMPET',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 8),
            // child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            child: Text('RIWAYAT :',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                ))),
          ),

          SizedBox(height: 20.0),
          // Generate cards using a loop
          for (int i = 0; i < 5; i++)
            cardTransaksi('Pendanaan', '25 Jan 2023', '-Rp. 327.000'),

          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
