import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  final String tituloPagina;

  const ListPage({super.key, required this.tituloPagina});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tituloPagina),
        centerTitle: true,
        backgroundColor: const Color(0xFF29366F),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('tarefas')
            .orderBy('dataCriacao', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar as tarefas: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book, size: 64, color: Colors.indigo),
                  SizedBox(height: 12),
                  Text(
                    'Nenhuma tarefa cadastrada.',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text('Volte e cadastre sua primeira tarefa.'),
                ],
              ),
            );
          }

          final documentos = snapshot.data!.docs;

          return ListView(
            padding: const EdgeInsets.all(12),
            children: documentos.map((doc) {
              final tarefa = doc.data();
              final concluida = tarefa['concluida'] == true;
              final importante = tarefa['importante'] == true;

              return Card(
                child: CheckboxListTile(
                  value: concluida,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    FirebaseFirestore.instance
                        .collection('tarefas')
                        .doc(doc.id)
                        .update({'concluida': value});
                  },
                  title: Text(
                    tarefa['titulo'] ?? 'Sem título',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration:
                          concluida ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tarefa['disciplina'] ?? 'Sem disciplina'),
                        Text(tarefa['descricao'] ?? ''),
                        if (importante)
                          const Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 16),
                              SizedBox(width: 4),
                              Text('Importante'),
                            ],
                          ),
                        if ((tarefa['cidade'] ?? '').toString().isNotEmpty)
                          Text('Local de estudo: ${tarefa['cidade']}'),
                      ],
                    ),
                  ),
                  secondary: const Icon(Icons.school, color: Color(0xFF5265B5)),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Voltar ao início',
        backgroundColor: const Color(0xFF4054A5),
        foregroundColor: Colors.white,
        child: const Icon(Icons.home),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
