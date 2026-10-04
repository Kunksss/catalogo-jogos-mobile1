import 'package:catalogo_jogos/models/jogo.dart';
import 'package:catalogo_jogos/screens/lista_screen.dart';
import 'package:catalogo_jogos/state/jogo_controller.dart';
import 'package:catalogo_jogos/theme/app_theme.dart';
import 'package:catalogo_jogos/widgets/jogo_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(JogoController controller) {
  return MaterialApp(
    theme: AppTheme.claro,
    home: ListaScreen(controller: controller),
  );
}

JogoController _controllerComJogos() {
  return JogoController(
    iniciais: const [
      Jogo(
        id: '1',
        titulo: 'Zelda',
        plataforma: 'Switch',
        status: StatusJogo.jogando,
        descricao: 'Aventura em Hyrule',
      ),
      Jogo(
        id: '2',
        titulo: 'Hades',
        plataforma: 'PC',
        status: StatusJogo.zerado,
      ),
    ],
  );
}

void main() {
  testWidgets('mostra o estado vazio quando não há jogos', (tester) async {
    await tester.pumpWidget(_app(JogoController()));

    expect(find.text('Nenhum jogo cadastrado'), findsOneWidget);
    expect(find.byType(JogoCard), findsNothing);
  });

  testWidgets('mostra um card para cada jogo da coleção', (tester) async {
    await tester.pumpWidget(_app(_controllerComJogos()));

    expect(find.byType(JogoCard), findsNWidgets(2));
    expect(find.text('Zelda'), findsOneWidget);
    expect(find.text('Hades'), findsOneWidget);
    expect(find.text('Nenhum jogo cadastrado'), findsNothing);
  });

  testWidgets('rejeita título vazio e mostra mensagem de erro', (tester) async {
    final controller = JogoController();
    await tester.pumpWidget(_app(controller));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('botao_salvar')));
    await tester.pump();

    expect(find.text('Informe o título'), findsOneWidget);
    expect(controller.jogos, isEmpty);
  });

  testWidgets('cria um jogo sem descrição, pois ela é opcional', (
    tester,
  ) async {
    final controller = JogoController();
    await tester.pumpWidget(_app(controller));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('campo_titulo')), 'Celeste');
    await tester.enterText(find.byKey(const Key('campo_plataforma')), 'PC');
    await tester.tap(find.byKey(const Key('botao_salvar')));
    await tester.pumpAndSettle();

    expect(controller.jogos.length, 1);
    expect(controller.jogos.first.descricao, isEmpty);
    expect(find.byType(JogoCard), findsOneWidget);
    expect(find.text('Celeste'), findsOneWidget);
  });

  testWidgets('cria um jogo com descrição e a mostra no detalhe', (
    tester,
  ) async {
    final controller = JogoController();
    await tester.pumpWidget(_app(controller));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('campo_titulo')), 'Celeste');
    await tester.enterText(find.byKey(const Key('campo_plataforma')), 'PC');
    await tester.enterText(
      find.byKey(const Key('campo_descricao')),
      'Escalada difícil e emocionante',
    );
    await tester.tap(find.byKey(const Key('botao_salvar')));
    await tester.pumpAndSettle();

    expect(controller.jogos.first.descricao, 'Escalada difícil e emocionante');

    await tester.tap(find.text('Celeste'));
    await tester.pumpAndSettle();

    expect(find.text('Detalhes'), findsOneWidget);
    expect(find.text('Escalada difícil e emocionante'), findsOneWidget);
  });

  testWidgets('tocar no card abre o detalhe com os dados do jogo', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_controllerComJogos()));

    await tester.tap(find.text('Zelda'));
    await tester.pumpAndSettle();

    expect(find.text('Detalhes'), findsOneWidget);
    expect(find.text('Zelda'), findsOneWidget);
    expect(find.text('Switch'), findsOneWidget);
    expect(find.text('Jogando'), findsOneWidget);
    expect(find.text('Aventura em Hyrule'), findsOneWidget);
  });

  testWidgets('detalhe de jogo sem descrição mostra o aviso', (tester) async {
    await tester.pumpWidget(_app(_controllerComJogos()));

    await tester.tap(find.text('Hades'));
    await tester.pumpAndSettle();

    expect(find.text('Detalhes'), findsOneWidget);
    expect(find.text('Sem descrição'), findsOneWidget);
  });

  testWidgets('editar pela lista preserva a identidade e não duplica o item', (
    tester,
  ) async {
    final controller = _controllerComJogos();
    await tester.pumpWidget(_app(controller));

    await tester.tap(find.byTooltip('Editar Zelda'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('campo_titulo')),
      'Zelda Tears of the Kingdom',
    );
    await tester.tap(find.byKey(const Key('botao_salvar')));
    await tester.pumpAndSettle();

    expect(find.byType(JogoCard), findsNWidgets(2));
    expect(find.text('Zelda'), findsNothing);
    expect(find.text('Zelda Tears of the Kingdom'), findsOneWidget);
    expect(controller.jogos.first.id, '1');
    expect(controller.jogos.first.titulo, 'Zelda Tears of the Kingdom');
    expect(controller.jogos.first.descricao, 'Aventura em Hyrule');
  });

  testWidgets('editar pelo detalhe atualiza o detalhe e a lista', (
    tester,
  ) async {
    final controller = _controllerComJogos();
    await tester.pumpWidget(_app(controller));

    await tester.tap(find.text('Zelda'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Editar jogo'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('campo_titulo')),
      'Zelda Remix',
    );
    await tester.enterText(
      find.byKey(const Key('campo_descricao')),
      'Nova descrição',
    );
    await tester.tap(find.byKey(const Key('botao_salvar')));
    await tester.pumpAndSettle();

    expect(find.text('Detalhes'), findsOneWidget);
    expect(find.text('Zelda Remix'), findsOneWidget);
    expect(find.text('Nova descrição'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byType(JogoCard), findsNWidgets(2));
    expect(find.text('Zelda Remix'), findsOneWidget);
    expect(controller.jogos.length, 2);
    expect(controller.jogos.first.id, '1');
    expect(controller.jogos.first.descricao, 'Nova descrição');
  });

  testWidgets('cancelar o formulário não altera a coleção', (tester) async {
    final controller = _controllerComJogos();
    await tester.pumpWidget(_app(controller));

    await tester.tap(find.byTooltip('Editar Zelda'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('campo_titulo')), 'Alterado');
    await tester.tap(find.byKey(const Key('botao_cancelar')));
    await tester.pumpAndSettle();

    expect(controller.jogos.length, 2);
    expect(controller.jogos.first.titulo, 'Zelda');
    expect(find.text('Zelda'), findsOneWidget);
    expect(find.text('Alterado'), findsNothing);
  });

  testWidgets('remover pelo detalhe volta à lista sem o item', (tester) async {
    final controller = _controllerComJogos();
    await tester.pumpWidget(_app(controller));

    await tester.tap(find.text('Hades'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Remover jogo'));
    await tester.pumpAndSettle();

    expect(find.text('Detalhes'), findsNothing);
    expect(find.byType(JogoCard), findsOneWidget);
    expect(find.text('Hades'), findsNothing);
    expect(controller.jogos.length, 1);
  });

  testWidgets('usa lista em tela estreita e grade em tela larga', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(400, 800);

    await tester.pumpWidget(_app(_controllerComJogos()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(GridView), findsNothing);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(900, 800);
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
