import 'package:festymatch_frontend/pages/profile_pages/profile_page.dart';
import 'package:festymatch_frontend/pages/profile_pages/other_profile_page.dart';
import 'package:flutter/material.dart';
import '../../components/navbar.dart';
import '../../services/interactions_service.dart';
import 'pet_profile_page.dart';

class LikesPage extends StatefulWidget {
  final String petId;
  final String petName;
  final String petImageUrl;

  const LikesPage({
    super.key,
    required this.petId,
    required this.petName,
    required this.petImageUrl,
  });

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  List<Map<String, dynamic>> interestedUsers = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchInterested();
  }

  Future<void> fetchInterested() async {
    try {
      final users =
          await InteractionsService().getInterestedUsers(widget.petId);
      print(users);
      setState(() {
        interestedUsers = users;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
        title: const Text(''),
      ),
      body: Builder(
        builder: (ctx) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (error != null) {
            return Center(child: Text('Error: $error'));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabecera clicable
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PetProfilePage(
                          petId: widget.petId,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: widget.petImageUrl.startsWith('http')
                            ? Image.network(
                                widget.petImageUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                widget.petImageUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.petName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Personas interesadas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: interestedUsers.isEmpty
                    ? const Center(child: Text('No hay usuarios interesados'))
                    : ListView.builder(
                        itemCount: interestedUsers.length,
                        itemBuilder: (context, index) {
                          final user = interestedUsers[index];
                          final interactionId = user['id'];
                          final interactionStatus = user['status'];
                          final adopterProfile = user['adopterProfile'];

                          // Filtrar interacciones rechazadas
                          if (interactionStatus == 'rejected') {
                            return const SizedBox.shrink();
                          }

                          if (adopterProfile == null)
                            return const SizedBox.shrink();
                          final picUrl =
                              adopterProfile['profilePictureUrl'] as String;
                          final imageProvider = picUrl.startsWith('http')
                              ? NetworkImage(picUrl)
                              : AssetImage(picUrl) as ImageProvider;

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OtherProfilePage(
                                    userId: adopterProfile['id'] as String,
                                    interactionId: interactionId as String,
                                    interactionStatus:
                                        interactionStatus as String,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image(
                                                image: imageProvider,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              adopterProfile['name'] as String,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Wrap(
                                            spacing: 6,
                                            runSpacing: 6,
                                            children: [
                                              RawChip(
                                                label: const Text(
                                                  'Vive en Departamento',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 245, 245, 245),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                ),
                                                side: BorderSide.none,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2),
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                              ),
                                              RawChip(
                                                label: const Text(
                                                  'Tiene más mascotas',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 245, 245, 245),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                ),
                                                side: BorderSide.none,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2),
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (interactionStatus == 'accepted')
                                          IconButton(
                                            onPressed: () {
                                              // Aquí puedes navegar a la página de chat
                                              // Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(...)));
                                              print(
                                                  'Navegar al chat con ${adopterProfile['name']}');
                                            },
                                            icon: const Icon(Icons.chat),
                                            iconSize: 30,
                                            color: const Color.fromARGB(
                                                255, 37, 37, 37),
                                          )
                                        else ...[
                                          IconButton(
                                            icon: const Icon(Icons.close,
                                                color: Colors.red),
                                            iconSize: 30,
                                            onPressed: () => setState(() async {
                                              final response =
                                                  await InteractionsService()
                                                      .updateInteraction(
                                                          'rejected',
                                                          interactionId);
                                              interestedUsers.removeAt(index);
                                            }),
                                          ),
                                          const SizedBox(width: 60),
                                          IconButton(
                                            icon: const Icon(Icons.check,
                                                color: Colors.green),
                                            iconSize: 30,
                                            onPressed: () async {
                                              final response =
                                                  await InteractionsService()
                                                      .updateInteraction(
                                                          'accepted',
                                                          interactionId);
                                              setState(() {
                                                user['status'] = 'accepted';
                                              });
                                            },
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: NavBar(currentIndex: 0),
    );
  }
}
