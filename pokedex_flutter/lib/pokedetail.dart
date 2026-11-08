// =============================================================
// pokedetail.dart  (pantalla de detalle)
// Los cambios respecto a la versión original están marcados con "CAMBIO".
// =============================================================

// CAMBIO 1: se quitaron imports sin uso (flutter/widgets.dart, dart:convert
// y http) que solo generaban advertencias.
import 'package:flutter/material.dart';

import 'pokemon.dart';

// CAMBIO 2: la clase se llamaba "pokedetails". Las clases en Dart se escriben
// en PascalCase, por eso ahora es PokeDetails (se actualizó main.dart).
class PokeDetails extends StatelessWidget {
  final Pokemon pokemon;

  const PokeDetails({super.key, required this.pokemon});

  // CAMBIO 3: Wrap en lugar de Row. Un Row no puede partir en varias líneas,
  // y Paras y Parasect tienen 6 debilidades: con Row se desbordaba la pantalla.
  Widget _chips(List<String> textos, Color color, String textoVacio) {
    if (textos.isEmpty) {
      return Text(textoVacio, style: const TextStyle(color: Colors.grey));
    }
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: textos
          .map(
            (t) => FilterChip(
              backgroundColor: color,
              label: Text(t),
              onSelected: (b) {},
            ),
          )
          .toList(),
    );
  }

  Widget _titulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Text(
        texto,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tipos = pokemon.type ?? <String>[];
    final debilidades = pokemon.weaknesses ?? <String>[];
    // CAMBIO 4: se muestran solo evoluciones reales (sin el marcador
    // "This is the final Evolution") y también la evolución previa.
    final siguientes =
        pokemon.siguientesEvoluciones.map((e) => e.name ?? "").toList();
    final previas =
        pokemon.previasEvoluciones.map((e) => e.name ?? "").toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name ?? "Pokemon sin conocer"),
        centerTitle: true,
      ),
      // CAMBIO 5: SingleChildScrollView en lugar del Stack con alturas fijas.
      // Antes la tarjeta medía "alto de pantalla / 1.5" y no tenía scroll,
      // así que el contenido no cabía al rotar el teléfono.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: ConstrainedBox(
            // En pantallas anchas (horizontal) el contenido no se estira de más
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Hero(
                    // CAMBIO 6: misma etiqueta que en la lista (main.dart)
                    tag: 'poke_${pokemon.id ?? pokemon.hashCode}',
                    // CAMBIO 7: PokeImagen (abajo) con respaldo si falla la imagen
                    child: PokeImagen(url: pokemon.img, size: 200),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          pokemon.name ?? "",
                          style: const TextStyle(fontSize: 25),
                        ),
                        const SizedBox(height: 8),
                        Text("Peso: ${pokemon.weight}"),
                        Text("Altura: ${pokemon.height}"),
                        _titulo("Tipo:"),
                        _chips(tipos, Colors.teal, "Sin tipo"),
                        _titulo("Debilidades:"),
                        _chips(debilidades, Colors.redAccent, "Sin debilidades"),
                        _titulo("Evolución previa:"),
                        _chips(previas, Colors.blueGrey,
                            "No tiene evolución previa"),
                        _titulo("Siguiente evolución:"),
                        _chips(siguientes, Colors.deepOrangeAccent,
                            "Es su evolución final"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================
// CAMBIO 7: widget NUEVO, compartido por la lista y el detalle.
// Las 50 URLs del JSON empiezan con "http://", y Android bloquea ese
// tráfico por defecto. Este widget intenta primero la versión https y,
// si falla, la original. Si ambas fallan muestra un ícono en lugar de
// dejar un espacio en blanco.
// =============================================================
class PokeImagen extends StatelessWidget {
  final String? url;
  final double size;

  const PokeImagen({super.key, required this.url, required this.size});

  Widget _vacio() {
    return SizedBox(
      width: size,
      height: size,
      child: Icon(Icons.catching_pokemon, size: size * 0.6, color: Colors.black26),
    );
  }

  @override
  Widget build(BuildContext context) {
    final original = url ?? "";
    if (original.isEmpty) return _vacio();

    final segura = original.replaceFirst('http://', 'https://');

    return Image.network(
      segura,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // La versión https falló: se prueba la URL original
        if (segura == original) return _vacio();
        return Image.network(
          original,
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => _vacio(),
        );
      },
    );
  }
}
