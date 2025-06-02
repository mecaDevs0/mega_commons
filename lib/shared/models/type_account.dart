enum TypeAccount { checkingAccount, savingsAccount }

extension TypeAccountExtension on TypeAccount {
  String get name {
    switch (this) {
      case TypeAccount.checkingAccount:
        return 'Conta Corrente';
      case TypeAccount.savingsAccount:
        return 'Conta Poupança';
    }
  }

  int get value {
    switch (this) {
      case TypeAccount.checkingAccount:
        return 0;
      case TypeAccount.savingsAccount:
        return 1;
    }
  }
}
