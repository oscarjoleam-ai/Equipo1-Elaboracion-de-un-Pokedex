import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'dart:convert';
import 'pokemon.dart';
import 'package:http/http.dart' as http;

class pokedetails extends StatelessWidget {
  //const pokedetails({super.key});
  final Pokemon pokemon;

  pokedetails({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(pokemon.name ?? "Pokemon sin conocer"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width - 20,
            left: 10.0,
            top: MediaQuery.of(context).size.height * 0.1,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 70),
                  Text(pokemon.name ?? "", style: TextStyle(fontSize: 25)),
                  Text("Peso: ${pokemon.weight}"),
                  Text("Altura: ${pokemon.height}"),
                  Text("Tipo: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: (pokemon.type ?? [])
                        .map(
                          (ty) => FilterChip(
                            backgroundColor: Colors.teal,
                            label: Text(ty),
                            onSelected: (b) {},
                          ),
                        )
                        .toList(),
                  ),
                  Text(
                    "Debilidades:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: (pokemon.weaknesses ?? [])
                        .map(
                          (ty) => FilterChip(
                            backgroundColor: Colors.redAccent,
                            label: Text(ty),
                            onSelected: (b) {},
                          ),
                        )
                        .toList(),
                  ),
                  Text(
                    "Siguiente evolución:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: (pokemon.nextEvolution ?? [])
                        .map(
                          (ty) => FilterChip(
                            backgroundColor: Colors.deepOrangeAccent,
                            label: Text(ty.name ?? ""),
                            onSelected: (b) {},
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Hero(
              tag: pokemon.img ?? "",
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(fit: BoxFit.cover,
                  image: NetworkImage(pokemon.img ?? ""))
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
