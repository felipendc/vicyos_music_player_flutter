import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_extension.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // Criando o FocusNode
  bool _isTyping = false;

  void _onTextChanged(String text) {
    setState(() {
      _isTyping = text.isNotEmpty;
    });
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _isTyping = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Solicita o foco assim que a tela for carregada
    Future.delayed(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181B2C), // Dark background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff181B2C),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            splashRadius: 20,
            onPressed: () async {
              Navigator.pop(context);
            },
            icon: Image.asset(
              "assets/img/arrow_back_ios.png",
              color: TColor.lightGray,
              height: 20,
              width: 20,
            ),
          ),
        ),
        title: TextField(
          controller: _controller,
          focusNode: _focusNode, // Associando o FocusNode ao TextField
          onChanged: _onTextChanged, // Detecta mudanças no texto
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Colors.white60),
            filled: true,
            fillColor: const Color(0xff24273A), // Background do TextField
            contentPadding: const EdgeInsets.only(
                left: 16, right: 48, top: 12, bottom: 12), // Ajuste de padding
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(
                  right: 8), // Espaço pequeno para o ícone
              child: _isTyping
                  ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed:
                          _clearSearch, // Limpa o texto quando o "X" é pressionado
                    )
                  : const Icon(Icons.search,
                      color: Colors.white70), // Ícone de pesquisa quando vazio
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text('Screen content',
            style: TextStyle(
                color: Colors.white)), // Placeholder para o conteúdo da tela
      ),
    );
  }
}
