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
    _balance = amount;
  }

  //abstract methods
  void deposit(double amount);
  void withdraw(double amount);

  void displayInfo() {
    print("Account Number: $accountNumber");
    print("Account Holder Name: $accountHolderName");
    print("Balance: $_balance");
  }

  //Extended system:
  final List<String> _transaction = [];

  void addTransaction(String message) {
    _transaction.add(message);
  }

  void showTransactions() {
    print("Transaction History for Account $accountNumber:");
    for (String transaction in _transaction) {
      print(transaction);
    }
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
    addTransaction("Deposited $amount"); //extension
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
        addTransaction("Withdrew $amount"); //extension
        print("Withdrew $amount from your Saving Account");
      }
    }
  }

  @override
  void calculateInterest() {
    double interest = balance * interestRate;
    balance += interest;
    addTransaction("Interest added $interest"); //extension
    print("Money $interest added as interest to your Account");
  }
}

class CheckingAccount extends BankAccount {
  final double overdraftFee;
  CheckingAccount({
    required super.accountNumber,
    required super.accountHolderName,
    this.overdraftFee = 35.0,
    super.balance,
  });

  @override
  void deposit(double amount) {
    balance += amount;
    addTransaction("Deposited $amount"); //extension
    print("Deposited $amount to your Checking Account");
  }

  @override
  void withdraw(double amount) {
    double newBalance = balance - amount;
    if (newBalance < 0) {
      newBalance -= overdraftFee;
      addTransaction("Overdraft fee of $overdraftFee applied"); //extension
      print("Overdraft fee of $overdraftFee has been applied");
    }
    balance = newBalance;
    addTransaction("Withdrawn $amount"); //extension
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
    addTransaction("Deposited $amount"); //extension
    print("Deposited $amount to your Premium Account");
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < 10000.0) {
      print("Minimum balance of 10000 must be maintained");
      return;
    }
    balance -= amount;
    addTransaction("Withdrew $amount"); //extension
    print("Withdrew $amount from your Premium Account");
  }

  @override
  void calculateInterest() {
    double interest = balance * _interestRate;
    balance += interest;
    addTransaction("Interest of $interest added"); //extension
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

  //Extended system:
  void applyMonthlyInterest() {
    for (BankAccount acc in _accounts) {
      if (acc is InterestBearing) {
        (acc as InterestBearing).calculateInterest();
      }
    }
  }

  void generateReport() {
    print("\n Bank Account Report");
    for (BankAccount acc in _accounts) {
      acc.displayInfo();
    }
  }
}

//Extension as question asks:
class StudentAccount extends BankAccount {
  final double maxBalance = 5000.0;
  StudentAccount({
    required super.accountNumber,
    required super.accountHolderName,
    super.balance = 0.0,
  });

  @override
  void deposit(double amount) {
    if (balance + amount > maxBalance) {
      print("Maximum balance of $maxBalance reached");
    } else {
      balance += amount;
      addTransaction("Deposited $amount"); //extension
      print("Deposited $amount to your Account");
    }
  }

  @override
  void withdraw(double amount) {
    if (amount > balance) {
      print("Insufficient Balance");
    } else {
      balance -= amount;
      addTransaction("Withdrew $amount"); //extension
      print("Withdrew $amount successfully");
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
  bank.createAccount(acc1);

  acc1.deposit(500);
  acc1.withdraw(200);
  acc1.calculateInterest();
  acc1.showTransactions();

  CheckingAccount acc2 = CheckingAccount(
    accountNumber: "testacc2",
    accountHolderName: "Laxman Thapa",
    balance: 200,
  );
  bank.createAccount(acc2);
  acc2.withdraw(300);
  acc2.deposit(150);
  acc2.showTransactions();

  PremiumAccount acc3 = PremiumAccount(
    accountNumber: "testacc3",
    accountHolderName: "Hariram Shrestha",
    balance: 15000,
  );
  bank.createAccount(acc3);

  acc3.withdraw(2000);
  acc3.calculateInterest();
  acc3.showTransactions();

  bank.transfer("testacc1", "testacc2", 100);

  // student account extension:
  StudentAccount acc4 = StudentAccount(
    accountNumber: "studacc1",
    accountHolderName: "Sita Bhandari",
    balance: 3000,
  );
  bank.createAccount(acc4);
  acc4.deposit(2500);
  acc4.withdraw(1000);
  acc4.showTransactions();

  bank.applyMonthlyInterest();

  bank.generateReport();
}
