class Account {
  final String accountNumber;
  double _amount;

  Account(this.accountNumber, double initialAmount)
      : assert(initialAmount == 0, 'El saldo inicial debe ser 0'),
        _amount = initialAmount;

  double get balance => _amount;

  /// Deposita un importe positivo en la cuenta.
  void deposit(double amount) {
    if (amount <= 0) {
      throw ArgumentError('El importe del depósito debe ser positivo');
    }
    _amount += amount;
  }

  /// Retira un importe positivo si hay suficiente saldo.
  void withdraw(double amount) {
    if (amount <= 0) {
      throw ArgumentError('El importe de la retirada debe ser positivo');
    }
    if (amount > _amount) {
      throw StateError('Saldo insuficiente');
    }
    _amount -= amount;
  }

}
