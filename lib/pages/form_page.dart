import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum Disciplina { matematica, portugues, programacao, historia, outras }

class FormPage extends StatefulWidget {
  final String tituloPagina;

  const FormPage({super.key, required this.tituloPagina});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();

  Disciplina disciplinaSelecionada = Disciplina.programacao;
  bool importante = false;
  bool consultandoCep = false;
  bool salvando = false;

  String nomeDisciplina(Disciplina disciplina) {
    switch (disciplina) {
      case Disciplina.matematica:
        return 'Matemática';
      case Disciplina.portugues:
        return 'Português';
      case Disciplina.programacao:
        return 'Programação';
      case Disciplina.historia:
        return 'História';
      case Disciplina.outras:
        return 'Outras';
    }
  }

  Future<void> buscarCep() async {
    final cep = cepController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (cep.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um CEP com 8 números.')),
      );
      return;
    }

    setState(() {
      consultandoCep = true;
    });

    try {
      final url = Uri.https('viacep.com.br', '/ws/$cep/json/');
      final resposta = await http.get(url);

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body) as Map<String, dynamic>;

        if (dados['erro'] == true) {
          throw Exception('CEP não encontrado.');
        }

        setState(() {
          ruaController.text = dados['logradouro'] ?? '';
          bairroController.text = dados['bairro'] ?? '';
          cidadeController.text =
              '${dados['localidade'] ?? ''} - ${dados['uf'] ?? ''}';
        });
      } else {
        throw Exception('Não foi possível consultar o CEP.');
      }
    } catch (erro) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro na consulta: $erro')),
      );
    } finally {
      setState(() {
        consultandoCep = false;
      });
    }
  }

  Future<void> salvarTarefa() async {
    if (tituloController.text.trim().isEmpty ||
        descricaoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o título e a descrição.')),
      );
      return;
    }

    setState(() {
      salvando = true;
    });

    try {
      await FirebaseFirestore.instance.collection('tarefas').add({
        'titulo': tituloController.text.trim(),
        'descricao': descricaoController.text.trim(),
        'disciplina': nomeDisciplina(disciplinaSelecionada),
        'importante': importante,
        'concluida': false,
        'cep': cepController.text.trim(),
        'rua': ruaController.text.trim(),
        'bairro': bairroController.text.trim(),
        'cidade': cidadeController.text.trim(),
        'dataCriacao': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarefa salva na nuvem!')),
      );
      Navigator.pop(context);
    } catch (erro) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível salvar: $erro')),
      );
    } finally {
      if (mounted) {
        setState(() {
          salvando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    tituloController.dispose();
    descricaoController.dispose();
    cepController.dispose();
    ruaController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tituloPagina),
        centerTitle: true,
        backgroundColor: const Color(0xFF29366F),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dados da tarefa',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202B55),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Título da tarefa',
                  hintText: 'Ex.: Revisar funções em Dart',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descricaoController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Descrição',
                  hintText: 'O que você precisa estudar?',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Disciplina',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              RadioListTile<Disciplina>(
                title: const Text('Matemática'),
                value: Disciplina.matematica,
                groupValue: disciplinaSelecionada,
                onChanged: (value) {
                  setState(() {
                    disciplinaSelecionada = value!;
                  });
                },
              ),
              RadioListTile<Disciplina>(
                title: const Text('Português'),
                value: Disciplina.portugues,
                groupValue: disciplinaSelecionada,
                onChanged: (value) {
                  setState(() {
                    disciplinaSelecionada = value!;
                  });
                },
              ),
              RadioListTile<Disciplina>(
                title: const Text('Programação'),
                value: Disciplina.programacao,
                groupValue: disciplinaSelecionada,
                onChanged: (value) {
                  setState(() {
                    disciplinaSelecionada = value!;
                  });
                },
              ),
              RadioListTile<Disciplina>(
                title: const Text('História'),
                value: Disciplina.historia,
                groupValue: disciplinaSelecionada,
                onChanged: (value) {
                  setState(() {
                    disciplinaSelecionada = value!;
                  });
                },
              ),
              RadioListTile<Disciplina>(
                title: const Text('Outras'),
                value: Disciplina.outras,
                groupValue: disciplinaSelecionada,
                onChanged: (value) {
                  setState(() {
                    disciplinaSelecionada = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Marcar como importante'),
                subtitle: const Text('Use para destacar uma prioridade'),
                value: importante,
                onChanged: (value) {
                  setState(() {
                    importante = value!;
                  });
                },
              ),
              const Divider(height: 28),
              const Text(
                'Local onde pretende estudar (opcional)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cepController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'CEP',
                        hintText: '00000000',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: consultandoCep ? null : buscarCep,
                    child: consultandoCep
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Buscar'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ruaController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Rua / Logradouro',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bairroController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Bairro',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cidadeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Cidade - UF',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.cloud_upload),
                  label: Text(salvando ? 'Salvando...' : 'Salvar tarefa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4054A5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: salvando ? null : salvarTarefa,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
