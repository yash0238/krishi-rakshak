import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/api_service.dart';
import '../models/disease.dart';

class DiseaseLibraryScreen extends StatefulWidget {
  const DiseaseLibraryScreen({Key? key}) : super(key: key);

  @override
  _DiseaseLibraryScreenState createState() => _DiseaseLibraryScreenState();
}

class _DiseaseLibraryScreenState extends State<DiseaseLibraryScreen> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  late TabController _tabController;
  List<Disease> _diseases = [];
  List<Disease> _filteredDiseases = [];
  bool _isLoading = false;
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _fetchDiseases();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      _filterDiseases();
    }
  }
  
  Future<void> _fetchDiseases() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final diseases = await _apiService.fetchDiseases();
      setState(() {
        _diseases = diseases;
        _filterDiseases();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load diseases: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _filterDiseases() {
    if (_diseases.isEmpty) return;
    
    setState(() {
      // Filter based on tab selection and search query
      if (_tabController.index == 0) {
        // All diseases
        _filteredDiseases = _diseases.where((disease) => 
          disease.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          disease.symptoms.toLowerCase().contains(_searchQuery.toLowerCase())
        ).toList();
      } else if (_tabController.index == 1) {
        // Plant diseases
        _filteredDiseases = _diseases.where((disease) => 
          disease.type == 'plant' && (
            disease.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            disease.symptoms.toLowerCase().contains(_searchQuery.toLowerCase())
          )
        ).toList();
      } else {
        // Animal diseases
        _filteredDiseases = _diseases.where((disease) => 
          disease.type == 'animal' && (
            disease.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            disease.symptoms.toLowerCase().contains(_searchQuery.toLowerCase())
          )
        ).toList();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.diseaseLibrary),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.all),
            Tab(text: l10n.plants),
            Tab(text: l10n.animals),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.searchDiseases,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _filterDiseases();
                });
              },
            ),
          ),
          
          // Disease List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredDiseases.isEmpty
                    ? Center(child: Text(l10n.noDiseaseFound))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _filteredDiseases.length,
                        itemBuilder: (context, index) {
                          final disease = _filteredDiseases[index];
                          return _buildDiseaseCard(context, disease);
                        },
                      ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDiseaseCard(BuildContext context, Disease disease) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ExpansionTile(
        leading: Icon(
          disease.type == 'plant' ? Icons.grass : Icons.pets,
          color: disease.type == 'plant' ? Colors.green : Colors.brown,
        ),
        title: Text(
          disease.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          disease.type == 'plant' ? l10n.plantDisease : l10n.animalDisease,
          style: TextStyle(
            color: disease.type == 'plant' ? Colors.green : Colors.brown,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Symptoms Section
                Text(
                  '${l10n.symptoms}:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(disease.symptoms),
                ),
                const SizedBox(height: 16),
                
                // Remedy Section
                Text(
                  '${l10n.remedy}:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(disease.remedy),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
