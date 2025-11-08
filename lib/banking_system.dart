abstract class BankAccount {
  final String accountNumber;
  final String accountHolderName;
  double _balance;

  //Constructor
  BankAccount({
    required this.accountNumber,
    required this.accountHolderName,
    double balance = 0.0,
  }) : _balance = balance;

  //getter and setter
  double get balance {
    return _balance;
  }

  set balance(double amount) {
    if (amount < 0) {
      print("Balance must be greater than 0");
    } else {
      _balance = amount;
    }
  }

  //abstract methods
  void deposit(double amount);
  void withdraw(double amount);

  void displayInfo() {
    print("Account Number: $accountNumber");
    print("Account Holder Name: $accountHolderName");
    print("Balance: $_balance");
  }
}

abstract class InterestBearing {
  void calculateInterest();
}

class SavingsAccount extends BankAccount implements InterestBearing {
  final double interestRate;
  int _withdrawalLimit = 0;
  SavingsAccount({
    required super.accountNumber,
    required super.accountHolderName,
    this.interestRate = 0.02,
    super.balance = 500.0,
  });
  //method overriding
  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited $amount to your Saving Account");
  }

  @override
  void withdraw(double amount) {
    if (_withdrawalLimit < 3) {
      if (balance - amount < 500.0) {
        print("Minimum balance of 500 must be maintained");
      } else if (amount > balance) {
        print("Insufficient money");
      } else {
        balance -= amount;
        _withdrawalLimit++;
        print("Withdrew $amount from your Saving Account");
      }
    }
  }

  @override
  void calculateInterest() {
    double interest = balance * interestRate;
    balance += interest;
    print("Money $interest added as interest to your Account");
  }
}

class CheckingAccount extends BankAccount {
  final double overdraftFee;
  CheckingAccount({
    required super.accountNumber,
    required super.accountHolderName,
    this.overdraftFee = 500.0,
    super.balance,
  });

  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited $amount to your Checking Account");
  }

  @override
  void withdraw(double amount) {
    balance -= amount;
    if (balance < 0) {
      balance -= overdraftFee;
      print("Overdraft fee of $overdraftFee has been applied");
    }
    print("$amount had be withdrawn");
  }
}

class PremiumAccount extends BankAccount implements InterestBearing {
  final double _interestRate;
  PremiumAccount({
    required super.accountNumber,
    required super.accountHolderName,
    double interestRate = 0.05,
    super.balance,
  }) : _interestRate = interestRate;

  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited $amount to your Premium Account");
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < 10000.0) {
      print("Minimum balance of 10000 must be maintained");
      return;
    }
    balance -= amount;
    print("Withdrew $amount from your Premium Account");
  }

  @override
  void calculateInterest() {
    double interest = balance * _interestRate;
    balance += interest;
    print("$interest added to your Account");
  }
}

class Bank {
  final List<BankAccount> _accounts = [];

  void createAccount(BankAccount account) {
    _accounts.add(account);
    print("Account created successfully for ${account.accountHolderName}.");
  }

  BankAccount? findAccount(String accountNumber) {
    for (BankAccount account in _accounts) {
      if (account.accountNumber == accountNumber) {
        return account;
      }
    }
    print("Account not found)");
    return null;
  }

  void transfer(
    String fromAccountNumber,
    String toAccountNumber,
    double amount,
  ) {
    BankAccount? from = findAccount(fromAccountNumber);
    BankAccount? to = findAccount(toAccountNumber);
    if (from == null || to == null) {
      print("Account cannot be null");
      return;
    }

    from.withdraw(amount);
    to.deposit(amount);
    print("Transferred $amount from $fromAccountNumber to $toAccountNumber");
  }

  void generateReport() {
    print("\n Bank Account Report");
    for (BankAccount acc in _accounts) {
      acc.displayInfo();
    }
  }
}

void main() {
  Bank bank = Bank();

  SavingsAccount acc1 = SavingsAccount(
    accountNumber: "testacc1",
    accountHolderName: "Hari Bahadur",
    balance: 1000,
  );
  CheckingAccount acc2 = CheckingAccount(
    accountNumber: "testacc2",
    accountHolderName: "Laxman Thapa",
    balance: 200,
  );
  PremiumAccount acc3 = PremiumAccount(
    accountNumber: "testacc3",
    accountHolderName: "Hariram Shrestha",
    balance: 15000,
  );

  bank.createAccount(acc1);
  bank.createAccount(acc2);
  bank.createAccount(acc3);

  acc1.deposit(500);
  acc1.withdraw(200);
  acc1.calculateInterest();

  acc2.withdraw(300);
  acc2.deposit(150);

  acc3.withdraw(2000);
  acc3.calculateInterest();

  bank.transfer("testacc1", "testacc2", 100);
  bank.generateReport();
}
