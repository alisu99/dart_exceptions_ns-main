import 'dart:io';

import 'package:dart_exceptions/services/account_service.dart';
import 'package:http/http.dart';

import '../models/account.dart';

class AccountScreen {
  final AccountService _accountService = AccountService();

  void initializeStream() {
    _accountService.streamInfos.listen(
      (event) {
        print(event);
      },
    );
  }

  void runChatBot() async {
    print("Bom dia! Eu sou o Lewis, assistente do Banco d'Ouro!");
    print("Que bom te ter aqui com a gente.\n");

    bool isRunning = true;
    while (isRunning) {
      print("Como eu posso te ajudar? (digite o número desejado)");
      print("1 - 👀 Ver todas sua contas.");
      print("2 - ➕ Adicionar nova conta.");
      print("3 - Sair\n");

      String? input = stdin.readLineSync();

      if (input != null) {
        switch (input) {
          case "1":
            {
              await _getAllAccounts();
              break;
            }
          case "2":
            {
              await _addExampleAccount();
              break;
            }
          case "3":
            {
              isRunning = false;
              print("Te vejo na próxima. 👋");
              break;
            }
          default:
            {
              print("Não entendi. Tente novamente.");
            }
        }
      }
    }
  }

  _getAllAccounts() async {
    try {
      List<Account> listAccounts = await _accountService.getAll();
      print(listAccounts);
    } on ClientException catch (ClientException) {
      print('Não cosegui me conectar com o servidor!');
      print(ClientException.message);
      print(ClientException.uri);
    } on Exception  {
      print('Não cosegui me conectar com o banco. Tente novamente mais tarde!');
    } finally {
      print("${DateTime.now()} | Tentativa de conexão.");
    }
  }

  _addExampleAccount() async {
    Account example = Account(
      id: "ID555",
      name: "Haley",
      lastName: "Chirívia",
      balance: 8001,
    );

    await _accountService.addAccount(example);
  }
}
