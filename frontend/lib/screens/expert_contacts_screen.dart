import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpertContactsScreen extends StatelessWidget {
  const ExpertContactsScreen({Key? key}) : super(key: key);

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Query about disease from Krishi Rakshak app',
      }),
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.expertContacts),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInfoCard(context),
          const SizedBox(height: 24),
          Text(
            l10n.plantExperts,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          _buildExpertCard(
            context,
            'Dr. Sunil Kulkarni',
            'Agricultural Scientist',
            'Maharashtra Agricultural University, Pune',
            '9876543210',
            'sunil.kulkarni@example.com',
            [l10n.cropDiseases, l10n.pestControl, l10n.soilHealth],
            Colors.green.shade700,
          ),
          _buildExpertCard(
            context,
            'Dr. Priya Patil',
            'Plant Pathologist',
            'Krishi Vigyan Kendra, Nashik',
            '9876543211',
            'priya.patil@example.com',
            [l10n.fungalDiseases, l10n.viralDiseases, l10n.organicFarming],
            Colors.green.shade700,
          ),
          _buildExpertCard(
            context,
            'Dr. Rajesh Sharma',
            'Horticulturist',
            'Indian Institute of Horticultural Research',
            '9876543212',
            'rajesh.sharma@example.com',
            [l10n.fruitCrops, l10n.vegetables, l10n.plantNutrition],
            Colors.green.shade700,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.animalExperts,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 8),
          _buildExpertCard(
            context,
            'Dr. Anita Deshmukh',
            'Veterinarian',
            'District Animal Husbandry Center, Kolhapur',
            '9876543213',
            'anita.deshmukh@example.com',
            [l10n.cattleDiseases, l10n.poultryDiseases, l10n.animalNutrition],
            Colors.brown.shade700,
          ),
          _buildExpertCard(
            context,
            'Dr. Vikram Singh',
            'Animal Health Specialist',
            'Veterinary College, Mumbai',
            '9876543214',
            'vikram.singh@example.com',
            [l10n.dairyManagement, l10n.animalBreeding, l10n.livestockDiseases],
            Colors.brown.shade700,
          ),
          _buildExpertCard(
            context,
            'Dr. Meena Joshi',
            'Poultry Specialist',
            'Poultry Research Institute, Pune',
            '9876543215',
            'meena.joshi@example.com',
            [l10n.poultryHealth, l10n.diseaseManagement, l10n.vaccinations],
            Colors.brown.shade700,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.helplines,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          _buildHelplineCard(
            context,
            l10n.kisanCallCenter,
            '1800-180-1551',
            l10n.kisanCallCenterDesc,
            Icons.headset_mic,
            Colors.blue.shade700,
          ),
          _buildHelplineCard(
            context,
            l10n.animalHelpline,
            '1800-123-4567',
            l10n.animalHelplineDesc,
            Icons.pets,
            Colors.brown.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(
              Icons.info_outline,
              size: 40,
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.expertContactsInfo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpertCard(
    BuildContext context,
    String name,
    String designation,
    String organization,
    String phone,
    String email,
    List<String> specializations,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: color.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  radius: 25,
                  child: Text(
                    name.substring(0, 1),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        designation,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        organization,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              AppLocalizations.of(context)!.specializations,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: specializations.map((spec) => Chip(
                label: Text(spec, style: const TextStyle(fontSize: 12)),
                backgroundColor: color.withOpacity(0.1),
              )).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _makePhoneCall(phone),
                    icon: const Icon(Icons.phone),
                    label: Text(AppLocalizations.of(context)!.call),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: color),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _sendEmail(email),
                    icon: const Icon(Icons.email),
                    label: Text(AppLocalizations.of(context)!.email),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: color),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelplineCard(
    BuildContext context,
    String title,
    String number,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(description),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.phone),
          color: color,
          onPressed: () => _makePhoneCall(number),
        ),
      ),
    );
  }
}
