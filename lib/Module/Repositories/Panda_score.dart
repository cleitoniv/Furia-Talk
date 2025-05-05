import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FuriaPage extends StatefulWidget {
  @override
  _FuriaPageState createState() => _FuriaPageState();
}

class _FuriaPageState extends State<FuriaPage> {
  final String _apiKey = 'tjB_OdO61rLPPgBmLaGxeywUquYGcEnPKQEOZck3w4krzp8srxA';
  Map<String, dynamic>? _team;
  List<dynamic> _upcomingMatches = [];
  List<dynamic> _pastMatches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTeamAndMatches();
  }

  Future<void> fetchTeamAndMatches() async {
    try {
      final teamUrl = Uri.parse(
          'https://api.pandascore.co/csgo/teams?search[name]=Furia&token=$_apiKey');
      final teamResponse = await http.get(teamUrl);
      inspect(teamResponse);

      if (teamResponse.statusCode == 200) {
        final teamData = jsonDecode(teamResponse.body);

        final mainTeam = teamData.firstWhere(
          (team) => team['acronym'] == 'FURIA',
          orElse: () => null,
        );

        if (mainTeam != null) {
          _team = mainTeam;
        }
      }

      if (_team != null) {
        final furiaTeamId = _team!['id'];
        final matchesUrl = Uri.parse(
            'https://api.pandascore.co/csgo/matches?filter[opponent_id]=$furiaTeamId&token=$_apiKey');
        final matchesResponse = await http.get(matchesUrl);
        inspect(matchesResponse);

        if (matchesResponse.statusCode == 200) {
          final List<dynamic> matchesData = jsonDecode(matchesResponse.body);

          _upcomingMatches = matchesData
              .where((m) => m['status'] == 'not_started')
              .toList();

          _pastMatches = matchesData
              .where((m) => m['status'] == 'finished')
              .toList();
        }
      }

      setState(() => _isLoading = false);
    } catch (e) {
      print("Erro: $e");
      setState(() => _isLoading = false);
    }
  }

  String translateStatus(String status) {
    switch (status) {
      case 'not_started':
        return '🕒 Em breve';
      case 'running':
        return '🔥 Jogando agora';
      case 'finished':
        return '✅ Finalizado';
      default:
        return status;
    }
  }

  Widget matchTile(dynamic match) {
    final opponents = match['opponents'] ?? [];
    final results = match['results'] ?? [];
    final int furiaId = _team?['id'];

    final opponent = opponents.firstWhere(
      (o) => o['opponent']['id'] != furiaId,
      orElse: () => null,
    );

    int? furiaScore;
    int? opponentScore;

    for (var result in results) {
      if (result['team_id'] == furiaId) {
        furiaScore = result['score'];
      } else {
        opponentScore = result['score'];
      }
    }

    String outcome = '';
    Color outcomeColor = Colors.grey;

    if (match['status'] == 'finished' &&
        furiaScore != null &&
        opponentScore != null) {
      if (furiaScore > opponentScore) {
        outcome = '✅ Vitória';
        outcomeColor = Colors.green;
      } else {
        outcome = '❌ Derrota';
        outcomeColor = Colors.red;
      }
    }

    return ListTile(
      leading: opponent != null && opponent['opponent']['image_url'] != null
          ? Image.network(opponent['opponent']['image_url'], width: 40)
          : Icon(Icons.shield),
      title: Row(
        children: [
          Expanded(
            child: Text(
              match['name'] ?? 'Partida',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Ícone da Fúria com tamanho ajustado para o mesmo tamanho do ícone adversário
          Image.asset(
            'assets/Furia_Esports_logo.png', // Certifique-se de que essa imagem está no pubspec.yaml
            width: 40, // Ajustando o tamanho para ficar igual ao ícone do adversário
            height: 40, // Mantendo a altura para garantir que fique no mesmo alinhamento
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Status: ${translateStatus(match['status'])}"),
          if (match['status'] == 'finished' && outcome.isNotEmpty)
            Text(outcome, style: TextStyle(color: outcomeColor)),
        ],
      ),
      trailing: Text(
        match['begin_at'] != null
            ? match['begin_at'].toString().substring(0, 10)
            : 'Sem data',
      ),
    );
  }

  Widget section(String title, List<dynamic> matches) {
    if (matches.isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Divider(),
        ...matches.map(matchTile).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_team != null) ...[
                    Center(
                      child: Column(
                        children: [
                          if (_team!['image_url'] != null)
                            Image.network(_team!['image_url'], height: 100),
                          SizedBox(height: 8),
                          Text("${_team!['name']}",
                              style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ],
                  section("📅 Próximas partidas", _upcomingMatches),
                  section("✅ Partidas finalizadas", _pastMatches),
                ],
              ),
            ),
    );
  }
}