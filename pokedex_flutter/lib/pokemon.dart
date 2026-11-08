// =============================================================
// pokemon.dart  (modelo de datos)
// Los cambios respecto a la versión original están marcados con "CAMBIO".
// =============================================================

// CAMBIO 1: función auxiliar FUERA de las clases.
// Dentro de la clase Pokemon existe un campo llamado "num", que ocultaría
// el tipo "num" de Dart; por eso esta conversión se hace aquí afuera.
// Además es más segura que cast<double>(): acepta enteros (por ejemplo 2)
// y decimales (por ejemplo 2.5) sin lanzar errores.
List<double>? _aListaDeDoubles(dynamic valor) {
  if (valor is! List) return null;
  return valor.whereType<num>().map((e) => e.toDouble()).toList();
}

class POKEMON {
  List<Pokemon>? pokemon;

  POKEMON({this.pokemon});

  POKEMON.fromJson(Map<String, dynamic> json) {
    if (json['pokemon'] != null) {
      pokemon = <Pokemon>[];
      json['pokemon'].forEach((v) {
        pokemon!.add(new Pokemon.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pokemon != null) {
      data['pokemon'] = this.pokemon!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pokemon {
  int? id;
  String? num;
  String? name;
  String? img;
  List<String>? type;
  String? height;
  String? weight;
  String? candy;
  int? candyCount;
  String? egg;
  String? spawnChance;
  String? avgSpawns;
  String? spawnTime;
  List<double>? multipliers;
  List<String>? weaknesses;
  List<NextEvolution>? nextEvolution;
  List<PrevEvolution>? prevEvolution; // CAMBIO 2: se agrega la evolución previa

  Pokemon(
      {this.id,
        this.num,
        this.name,
        this.img,
        this.type,
        this.height,
        this.weight,
        this.candy,
        this.candyCount,
        this.egg,
        this.spawnChance,
        this.avgSpawns,
        this.spawnTime,
        this.multipliers,
        this.weaknesses,
        this.nextEvolution,
        this.prevEvolution}); // CAMBIO 2

  Pokemon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    num = json['num'];
    name = json['name'];
    img = json['img'];
    // CAMBIO 3: "?." para que un campo ausente no cierre la app
    type = json['type']?.cast<String>();
    height = json['height'];
    weight = json['weight'];
    candy = json['candy'];
    candyCount = json['candy_count'];
    egg = json['egg'];
    // CAMBIO 3: antes, un valor ausente se guardaba como el texto "null"
    spawnChance = json['spawn_chance']?.toString();
    avgSpawns = json['avg_spawns']?.toString();
    spawnTime = json['spawn_time'];
    multipliers = _aListaDeDoubles(json['multipliers']); // CAMBIO 1
    weaknesses = json['weaknesses']?.cast<String>(); // CAMBIO 3
    if (json['next_evolution'] != null) {
      nextEvolution = <NextEvolution>[];
      json['next_evolution'].forEach((v) {
        nextEvolution!.add(new NextEvolution.fromJson(v));
      });
    }
    // CAMBIO 2: se activa el bloque que estaba comentado
    if (json['prev_evolution'] != null) {
      prevEvolution = <PrevEvolution>[];
      json['prev_evolution'].forEach((v) {
        prevEvolution!.add(new PrevEvolution.fromJson(v));
      });
    }
  }

  // CAMBIO 4: el JSON marca las evoluciones finales con un elemento falso
  // (num == "0", "This is the final Evolution"). Este getter lo descarta
  // para que la pantalla solo reciba evoluciones reales.
  List<NextEvolution> get siguientesEvoluciones =>
      (nextEvolution ?? <NextEvolution>[]).where((e) => e.num != '0').toList();

  List<PrevEvolution> get previasEvoluciones =>
      prevEvolution ?? <PrevEvolution>[];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['num'] = this.num;
    data['name'] = this.name;
    data['img'] = this.img;
    data['type'] = this.type;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['candy'] = this.candy;
    data['candy_count'] = this.candyCount;
    data['egg'] = this.egg;
    data['spawn_chance'] = this.spawnChance;
    data['avg_spawns'] = this.avgSpawns;
    data['spawn_time'] = this.spawnTime;
    data['multipliers'] = this.multipliers;
    data['weaknesses'] = this.weaknesses;
    if (this.nextEvolution != null) {
      data['next_evolution'] =
          this.nextEvolution!.map((v) => v.toJson()).toList();
    }
    // CAMBIO 2: se activa el bloque que estaba comentado
    if (this.prevEvolution != null) {
      data['prev_evolution'] =
          this.prevEvolution!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NextEvolution {
  String? num;
  String? name;

  NextEvolution({this.num, this.name});

  NextEvolution.fromJson(Map<String, dynamic> json) {
    num = json['num'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num'] = this.num;
    data['name'] = this.name;
    return data;
  }
}

// CAMBIO 2: clase nueva, igual que NextEvolution, para la evolución previa
class PrevEvolution {
  String? num;
  String? name;

  PrevEvolution({this.num, this.name});

  PrevEvolution.fromJson(Map<String, dynamic> json) {
    num = json['num'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num'] = this.num;
    data['name'] = this.name;
    return data;
  }
}
