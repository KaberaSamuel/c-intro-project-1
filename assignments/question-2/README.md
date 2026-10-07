# Mobile Money Transaction System

## What it does

The menu supports deposits, withdrawals, balance inquiries, transaction summaries, and exit. Deposits and withdrawals must be positive. A withdrawal is rejected if the balance is too small. Only successful transactions affect the counts.

The menu repeats in a loop. Invalid choices and amounts use `continue` to return to it. `break` exits after the user selects Exit or input ends.

`switch` selects the menu action. `if` checks the choice, amount, and balance before a transaction is accepted.

## Build and run

From this folder, compile with a C compiler:

```sh
gcc -std=c11 -Wall -Wextra -pedantic src/main.c -lm -o mobile_money
./mobile_money
```

On Windows, run `mobile_money.exe` after compiling.

## Example run

```text
Choose an option: 1
Amount: 100
Deposit successful. Balance: 100.00
Choose an option: 2
Amount: 25
Withdrawal successful. Balance: 75.00
Choose an option: 2
Amount: 100
Withdrawal rejected. Insufficient balance.
Choose an option: 3
Current balance: 75.00
Choose an option: 4
Successful deposits: 1
Successful withdrawals: 1
Current balance: 75.00
Choose an option: 5
Goodbye.
```

The menu heading appears before each choice. This example shows a deposit, a successful withdrawal, an insufficient-funds rejection, a balance check, the summary, and exit. Also try a zero amount, a negative amount, text at the menu, and an invalid menu number. None should change the balance or successful transaction counts.

## Run evidence

[output.png](screenshots/output.png) shows a deposit, a successful withdrawal, an insufficient-funds rejection, a balance inquiry, a summary, and exit. [output.txt](screenshots/output.txt) has the captured program output. [console-session.txt](screenshots/console-session.txt) shows the inputs with that output.

The program compiled with Android NDK Clang and ran on an x86_64 Android emulator. It passed checks for repeated transactions, invalid choices, zero, negative and non-finite amounts, decimal amounts, insufficient funds, and transaction counts.
