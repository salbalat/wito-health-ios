import 'package:flutter/material.dart';
import '../services/health_service.dart';
import '../services/solid_api_service.dart';
import '../models/bioimpedance_data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HealthService _healthService = HealthService();
  final SolidApiService _solidService = SolidApiService();
  bool _isLoading = false;
  String _statusMessage = 'Listo para sincronizar';
  List<BioimpedanceData> _localData = [];
  
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }
  
  Future<void> _requestPermissions() async {
    bool hasPermissions = await _healthService.requestPermissions();
    if (!hasPermissions) {
      setState(() => _statusMessage = 'Permisos denegados');
    }
  }
  
  Future<void> _syncHealthToSolid() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Sincronizando...';
    });
    
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(days: 30));
      List<BioimpedanceData> healthData = await _healthService.fetchHealthData(startDate, endDate);
      
      if (healthData.isEmpty) {
        setState(() {
          _statusMessage = 'No hay datos en Apple Health';
          _isLoading = false;
        });
        return;
      }
      
      int synced = await _solidService.syncBioimpedanceData(healthData);
      setState(() {
        _localData = healthData;
        _statusMessage = 'Sincronizados $synced de ${healthData.length} registros';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WITO Health iOS'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.favorite, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(_statusMessage, style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _syncHealthToSolid,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Sincronizar Health → Solid'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                backgroundColor: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Últimos datos (${_localData.length}):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: _localData.isEmpty
                  ? Center(child: Text('No hay datos para mostrar'))
                  : ListView.builder(
                      itemCount: _localData.length,
                      itemBuilder: (context, index) {
                        final data = _localData[index];
                        return ListTile(
                          leading: Icon(Icons.analytics),
                          title: Text('${data.bodyFat.toStringAsFixed(1)}% grasa'),
                          subtitle: Text('${data.timestamp}'),
                          trailing: Text('${data.heartRate} bpm'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
