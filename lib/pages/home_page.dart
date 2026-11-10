
import 'package:flutter/material.dart';
import 'form_page.dart';
import 'list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool mostrarDica = true;

  static const Color azulPrincipal = Color(0xFF29366F);
  static const Color azulBotao = Color(0xFF4054A5);
  static const Color azulClaro = Color(0xFFEAF0FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      appBar: AppBar(
        title: const Text(
          'Estuda+',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: azulPrincipal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final larguraGrande = constraints.maxWidth > 750;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1050),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // IMAGEM 1 + STACK + POSITIONED
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: larguraGrande ? 210 : 155,
                            decoration: BoxDecoration(
                              color: azulClaro,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.asset(
                                'assets/images/estudo_banner.jpg',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Text(
                                      'Não foi possível carregar o banner.',
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          // Texto posicionado sobre a imagem.
                          Positioned(
                            left: 14,
                            bottom: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Planeje seus estudos!',
                                style: TextStyle(
                                  color: azulPrincipal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        'Organize sua rotina de estudos',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: azulPrincipal,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Cadastre tarefas, escolha uma disciplina e '
                        'acompanhe tudo o que precisa ser estudado.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 14),

                      const Row(
                        children: [
                          Icon(
                            Icons.menu_book,
                            color: azulBotao,
                            size: 22,
                          ),
                          SizedBox(width: 9),
                          Text(
                            'Um passo de cada vez.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: azulPrincipal,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 26),

                      const Text(
                        'O que deseja fazer?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: azulPrincipal,
                        ),
                      ),

                      const SizedBox(height: 14),

                      if (larguraGrande)
                        Row(
                          children: [
                            Expanded(child: _botaoCadastrar()),
                            const SizedBox(width: 16),
                            Expanded(child: _botaoListar()),
                          ],
                        )
                      else
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: _botaoCadastrar(),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: _botaoListar(),
                            ),
                          ],
                        ),

                      const SizedBox(height: 28),

                      // IMAGEM 2
                      Container(
                        width: double.infinity,
                        height: larguraGrande ? 150 : 125,
                        decoration: BoxDecoration(
                          color: azulClaro,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/livros.jpg',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Text(
                                  'Não foi possível carregar a imagem dos livros.',
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // INTERAÇÃO COM SETSTATE
                      Card(
                        elevation: 1,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: SwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 6,
                          ),
                          secondary: const Icon(
                            Icons.lightbulb_outline,
                            color: azulBotao,
                            size: 28,
                          ),
                          title: const Text(
                            'Mostrar dica de organização',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: azulPrincipal,
                            ),
                          ),
                          subtitle: const Text(
                            'Interação com estado usando setState',
                          ),
                          activeThumbColor: azulBotao,
                          value: mostrarDica,
                          onChanged: (value) {
                            setState(() {
                              mostrarDica = value;
                            });
                          },
                        ),
                      ),

                      if (mostrarDica) ...[
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: azulClaro,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.tips_and_updates,
                                color: azulBotao,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Dica: divida uma matéria grande em '
                                  'tarefas menores para facilitar seus estudos.',
                                  style: TextStyle(
                                    color: azulPrincipal,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 30),

                      const Center(
                        child: Text(
                          'Estuda+ • Organize seus estudos',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Abre a tela de cadastro.
  Widget _botaoCadastrar() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.add_task),
      label: const Text('Cadastrar tarefa'),
      style: ElevatedButton.styleFrom(
        backgroundColor: azulBotao,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FormPage(
              tituloPagina: 'Nova tarefa de estudo',
            ),
          ),
        );
      },
    );
  }

  // Abre a lista de tarefas.
  Widget _botaoListar() {
    return OutlinedButton.icon(
      icon: const Icon(Icons.list_alt),
      label: const Text('Ver minhas tarefas'),
      style: OutlinedButton.styleFrom(
        foregroundColor: azulBotao,
        padding: const EdgeInsets.symmetric(vertical: 18),
        side: const BorderSide(color: azulBotao),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ListPage(
              tituloPagina: 'Minhas tarefas de estudo',
            ),
          ),
        );
      },
    );
  }
}