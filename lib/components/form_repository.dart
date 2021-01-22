import 'package:flutter/material.dart';

import 'package:app/components/botao.dart';

class FormRepository extends StatefulWidget {
  FormRepository(
      {Key key, this.repo, this.changeRepo, this.onSearch, this.loading})
      : super(key: key);

  final String repo;
  final Function changeRepo;
  final Function onSearch;
  final bool loading;

  @override
  _FormRepositoryState createState() => _FormRepositoryState();
}

class _FormRepositoryState extends State<FormRepository> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              autofocus: true,
              onChanged: widget.changeRepo,
              decoration: const InputDecoration(
                hintText: 'Busque repositórios',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Favor preencher esse campo';
                }
                return null;
              },
            ),
            Botao(
                onPressed: widget.loading || widget.repo.isEmpty
                    ? null
                    : () {
                        if (_formKey.currentState.validate()) {
                          widget.onSearch();
                        }
                      },
                text: "Buscar"),
          ],
        ));
  }
}
