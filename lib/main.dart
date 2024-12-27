import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APIs Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Aplicación IP-Pokemon',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Nombre: Miguel Carvajal',
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Correo: miguelcarvajal2017@gmail.com',
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        toolbarHeight: 120,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  context,
                  'Buscador de IP',
                  Icons.language,
                  const IPStackPage(),
                ),
                const SizedBox(height: 20),
                _buildButton(
                  context,
                  'Buscador de Pokémon',
                  Icons.catching_pokemon,
                  const PokemonPage(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, IconData icon, Widget page) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

class IPStackPage extends StatefulWidget {
  const IPStackPage({super.key});

  @override
  State<IPStackPage> createState() => _IPStackPageState();
}

class _IPStackPageState extends State<IPStackPage> {
  final TextEditingController _ipController = TextEditingController();
  Map<String, dynamic>? ipData;
  String? errorMessage;
  bool isLoading = false;

  Future<void> searchIP(String ip) async {
    if (ip.isEmpty) {
      setState(() {
        errorMessage = 'Por favor ingrese una dirección IP';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'http://api.ipstack.com/$ip?access_key=4b19ce54ff31c8ee0ceb42647c502b99'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == false) {
          setState(() {
            ipData = null;
            errorMessage = data['error']['info'];
            isLoading = false;
          });
        } else {
          setState(() {
            ipData = data;
            errorMessage = null;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          ipData = null;
          errorMessage = 'Error al buscar la IP';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        ipData = null;
        errorMessage = 'Error de conexión';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscador de IP'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _ipController,
                        decoration: _buildInputDecoration(
                          'Dirección IP',
                          'Ejemplo: 134.201.250.155',
                          Icons.language,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: _buildSearchButton(
                          isLoading: isLoading,
                          onPressed: () => searchIP(_ipController.text),
                          text: 'Buscar',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              if (ipData != null && !isLoading)
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: _buildResultCard(
                        title: 'Información de la IP',
                        children: [
                          _buildInfoRow(
                              Icons.public, 'País', ipData!['country_name']),
                          _buildInfoRow(
                              Icons.location_city, 'Ciudad', ipData!['city']),
                          _buildInfoRow(
                              Icons.map, 'Región', ipData!['region_name']),
                          _buildInfoRow(Icons.location_on, 'Latitud',
                              ipData!['latitude'].toString()),
                          _buildInfoRow(Icons.location_on, 'Longitud',
                              ipData!['longitude'].toString()),
                          _buildInfoRow(Icons.flag, 'Código de país',
                              ipData!['country_code']),
                          _buildInfoRow(Icons.language, 'Continente',
                              ipData!['continent_name']),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  final TextEditingController _pokemonController = TextEditingController();
  Map<String, dynamic>? pokemonData;
  String? errorMessage;
  bool isLoading = false;

  Future<void> searchPokemon(String name) async {
    if (name.isEmpty) {
      setState(() {
        errorMessage = 'Por favor ingrese el nombre de un Pokémon';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/${name.toLowerCase()}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          pokemonData = json.decode(response.body);
          errorMessage = null;
          isLoading = false;
        });
      } else {
        setState(() {
          pokemonData = null;
          errorMessage = 'No se encontró el Pokémon';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        pokemonData = null;
        errorMessage = 'Error de conexión';
        isLoading = false;
      });
    }
  }

  Color _getTypeColor(String type) {
    final typeColors = {
      'normal': Colors.brown.shade200,
      'fire': Colors.orange,
      'water': Colors.blue,
      'grass': Colors.green,
      'electric': Colors.yellow,
      'ice': Colors.cyan,
      'fighting': Colors.red.shade900,
      'poison': Colors.purple,
      'ground': Colors.brown,
      'flying': Colors.indigo.shade200,
      'psychic': Colors.pink,
      'bug': Colors.lightGreen,
      'rock': Colors.grey,
      'ghost': Colors.deepPurple,
      'dragon': Colors.indigo,
      'dark': Colors.grey.shade800,
      'steel': Colors.blueGrey,
      'fairy': Colors.pinkAccent,
    };
    return typeColors[type] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscador de Pokémon'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _pokemonController,
                        decoration: _buildInputDecoration(
                          'Nombre del Pokémon',
                          'Ejemplo: pikachu',
                          Icons.catching_pokemon,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: _buildSearchButton(
                          isLoading: isLoading,
                          onPressed: () =>
                              searchPokemon(_pokemonController.text),
                          text: 'Buscar',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              if (pokemonData != null && !isLoading)
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _getTypeColor(pokemonData!['types'][0]
                                        ['type']['name'])
                                    .withOpacity(0.2),
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15)),
                              ),
                              child: Column(
                                children: [
                                  Hero(
                                    tag: 'pokemon-image',
                                    child: Image.network(
                                      pokemonData!['sprites']['front_default'],
                                      height: 200,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    pokemonData!['name'].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  _buildPokemonInfoRow('Altura',
                                      '${pokemonData!['height'] / 10} m'),
                                  _buildPokemonInfoRow('Peso',
                                      '${pokemonData!['weight'] / 10} kg'),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Tipos',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      for (var type in pokemonData!['types'])
                                        Chip(
                                          backgroundColor: _getTypeColor(
                                              type['type']['name']),
                                          label: Text(
                                            type['type']['name'].toUpperCase(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Habilidades',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      for (var ability
                                          in pokemonData!['abilities'])
                                        Chip(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          label:
                                              Text(ability['ability']['name']),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPokemonInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Estilo común para los campos de texto
InputDecoration _buildInputDecoration(
    String label, String hint, IconData icon) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: Icon(icon),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}

// Estilo común para los botones
ElevatedButton _buildSearchButton({
  required bool isLoading,
  required VoidCallback onPressed,
  required String text,
}) {
  return ElevatedButton(
    onPressed: isLoading ? null : onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: isLoading
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
  );
}

// Estilo para mostrar los resultados
Widget _buildResultCard({
  required String title,
  required List<Widget> children,
}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          ...children,
        ],
      ),
    ),
  );
}
