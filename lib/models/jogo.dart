enum StatusJogo {
  queroJogar('Quero jogar'),
  jogando('Jogando'),
  zerado('Zerado'),
  abandonado('Abandonado');

  const StatusJogo(this.rotulo);

  final String rotulo;
}

class Jogo {
  const Jogo({
    required this.id,
    required this.titulo,
    required this.plataforma,
    required this.status,
    this.descricao = '',
  });

  final String id;
  final String titulo;
  final String plataforma;
  final StatusJogo status;
  final String descricao;

  static int _sequencia = 0;

  static String gerarId() {
    _sequencia++;
    return '${DateTime.now().microsecondsSinceEpoch}-$_sequencia';
  }

  Jogo copyWith({
    String? titulo,
    String? plataforma,
    StatusJogo? status,
    String? descricao,
  }) {
    return Jogo(
      id: id,
      titulo: titulo ?? this.titulo,
      plataforma: plataforma ?? this.plataforma,
      status: status ?? this.status,
      descricao: descricao ?? this.descricao,
    );
  }
}
