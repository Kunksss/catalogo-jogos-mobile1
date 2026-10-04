import 'package:flutter/material.dart';

import '../models/jogo.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key, this.jogo});

  final Jogo? jogo;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloController;
  late final TextEditingController _plataformaController;
  late final TextEditingController _descricaoController;
  late StatusJogo _status;

  bool get _editando => widget.jogo != null;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.jogo?.titulo ?? '');
    _plataformaController = TextEditingController(
      text: widget.jogo?.plataforma ?? '',
    );
    _descricaoController = TextEditingController(
      text: widget.jogo?.descricao ?? '',
    );
    _status = widget.jogo?.status ?? StatusJogo.queroJogar;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _plataformaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final jogo = Jogo(
      id: widget.jogo?.id ?? Jogo.gerarId(),
      titulo: _tituloController.text.trim(),
      plataforma: _plataformaController.text.trim(),
      status: _status,
      descricao: _descricaoController.text.trim(),
    );
    Navigator.of(context).pop(jogo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_editando ? 'Editar jogo' : 'Novo jogo')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      key: const Key('campo_titulo'),
                      controller: _tituloController,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        border: OutlineInputBorder(),
                      ),
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return 'Informe o título';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('campo_plataforma'),
                      controller: _plataformaController,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Plataforma',
                        border: OutlineInputBorder(),
                      ),
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return 'Informe a plataforma';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('campo_descricao'),
                      controller: _descricaoController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Descrição (opcional)',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Semantics(
                      container: true,
                      label: 'Status do jogo',
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final status in StatusJogo.values)
                              ChoiceChip(
                                label: Text(status.rotulo),
                                selected: _status == status,
                                onSelected: (_) =>
                                    setState(() => _status = status),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            key: const Key('botao_cancelar'),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            key: const Key('botao_salvar'),
                            onPressed: _salvar,
                            child: const Text('Salvar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
