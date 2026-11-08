// =============================================================
// main.dart  (pantalla principal: lista de Pokémon)
// Los cambios respecto a la versión original están marcados con "CAMBIO".
// =============================================================

// CAMBIO 1: imports RELATIVOS. Antes era
//   import 'package:ag10_equipo1/pokedetail.dart';
// y fallaba si el proyecto de un compañero tenía otro nombre.
// También se quitó 'package:flutter/widgets.dart', que no se usaba.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'pokedetail.dart';
import 'pokemon.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // CAMBIO 2: ahora apunta al JSON con los 50 Pokémon del equipo
  // (antes: Azazel17/pokehub). El repositorio debe ser PÚBLICO.
  final String url =
      "https://raw.githubusercontent.com/oscarjoleam-ai/Equipo1-Elaboracion-de-un-Pokedex/main/pokedex_flutter/lib/pokedex.json";

  POKEMON? Pokehub;

  // CAMBIO 3: guarda el mensaje de error para mostrarlo en pantalla
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // CAMBIO 3: descarga con manejo de errores.
  // Antes, si la descarga fallaba (repositorio privado, sin internet), el
  // indicador de carga giraba para siempre y no se mostraba ningún mensaje.
  Future<void> _fetchData() async {
    try {
      final result =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 20));

      if (result.statusCode != 200) {
        throw Exception(
            'El servidor respondió con el código ${result.statusCode}. '
            'Revisa que el repositorio sea público y que la URL sea correcta.');
      }

      // utf8.decode sobre los bytes: así se leen bien símbolos como ♀ y ♂
      final decodedJson = json.decode(utf8.decode(result.bodyBytes));
      final datos = POKEMON.fromJson(decodedJson);

      // "mounted": evita errores si la pantalla se cerró durante la descarga
      if (!mounted) return;
      setState(() {
        Pokehub = datos;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    }
  }

  // CAMBIO 3: vuelve a mostrar el indicador de carga y reintenta
  void _reintentar() {
    setState(() {
      Pokehub = null;
      _error = null;
    });
    _fetchData();
  }

  Widget _vistaError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No se pudo descargar la Pokédex',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _reintentar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokedex"),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          // CAMBIO 3: botón para volver a descargar
          IconButton(
            tooltip: 'Volver a descargar',
            icon: const Icon(Icons.refresh),
            onPressed: _reintentar,
          ),
        ],
      ),
      body: _error != null
          ? _vistaError()
          : Pokehub == null
              ? Center(child: CircularProgressIndicator())
              // CAMBIO 4: GridView.extent en lugar de GridView.count(2).
              // Con 2 columnas fijas, al rotar el teléfono las tarjetas se
              // veían enormes; ahora el número de columnas se ajusta solo.
              : GridView.extent(
                  maxCrossAxisExtent: 200,
                  children: (Pokehub!.pokemon ?? [])
                      .map<Widget>(
                        (poke) => Padding(
                          padding: EdgeInsets.all(2.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // CAMBIO 5: la clase ahora se llama PokeDetails
                                  builder: (context) =>
                                      PokeDetails(pokemon: poke),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 3.0,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // CAMBIO 6: el Hero ahora envuelve solo la
                                  // imagen (antes envolvía toda la tarjeta, pero
                                  // el detalle usaba solo la imagen). La etiqueta
                                  // usa el id: coincide con pokedetail.dart.
                                  Hero(
                                    tag: 'poke_${poke.id ?? poke.hashCode}',
                                    // CAMBIO 7: PokeImagen con respaldo
                                    child:
                                        PokeImagen(url: poke.img, size: 95),
                                  ),
                                  Text(
                                    poke.name ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
    );
  }
}
