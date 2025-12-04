import 'package:festymatch_frontend/services/interactions_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../components/navbar.dart';
import '../../components/models/pet_model.dart';
import '../../services/matchmaking_service.dart';

class HomePageAdopter extends StatefulWidget {
  const HomePageAdopter({Key? key}) : super(key: key);

  @override
  State<HomePageAdopter> createState() => _HomePageAdopterState();
}

class _HomePageAdopterState extends State<HomePageAdopter> {
  late Future<List<MatchResult>> _matchesFuture;
  bool isLoading = true;
  final controller = CardSwiperController();

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  void _loadMatches() {
    setState(() {
      isLoading = true;
      _matchesFuture = MatchmakingService().getMyMatches();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Paws',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    "¡Encuentra tu compañero ideal!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () {
                    Navigator.pushNamed(
                                          context,
                                          '/preference_form_page',
                                        );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<MatchResult>>(
              future: _matchesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error al cargar mascotas: ${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _loadMatches,
                          child: const Text('Intentar de nuevo'),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay mascotas disponibles en este momento',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final matches = snapshot.data!;
                return CardSwiper(
                  controller: controller,
                  cardsCount: matches.length,
                  numberOfCardsDisplayed: 1,
                  cardBuilder: (context, index, horizontalThresholdPercentage,
                      verticalThresholdPercentage) {
                    final matchResult = matches[index];
                    final pet = matchResult.pet;
                    return _buildPetCard(pet, index, matches);
                  },
                  onSwipe: (previousIndex, currentIndex, direction) {
                    if (previousIndex != null &&
                        previousIndex < matches.length) {
                      final pet = matches[previousIndex].pet;

                      if (direction == CardSwiperDirection.right) {
                        InteractionsService().likePet(pet.id);
                      } else if (direction == CardSwiperDirection.left) {
                        InteractionsService().rejectPet(pet.id);
                      }
                    }
                    return true;
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(currentIndex: 1),
    );
  }

  Widget _buildPetCard(Pet pet, int index, List<MatchResult> matches) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: pet.mainPhotoUrl.startsWith('http')
                  ? Image.network(
                      pet.mainPhotoUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'lib/images/cat1.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      },
                    )
                  : Image.asset(
                      pet.mainPhotoUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            pet.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildPetInfo(pet),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.close,
                color: Colors.red,
                onPressed: () {
                  print("Botón de rechazar presionado para: ${pet.name}");
                  controller.swipe(CardSwiperDirection.left);
                },
              ),
              _buildActionButton(
                icon: Icons.favorite,
                color: Colors.green,
                onPressed: () {
                  print("Botón de like presionado para: ${pet.name}");
                  controller.swipe(CardSwiperDirection.right);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildPetInfo(Pet pet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${pet.type}  •  ${pet.gender}  •  ${pet.ageCategory}",
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 40),
      ),
    );
  }
}
