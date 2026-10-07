#include <errno.h>
#include <float.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INPUT_SIZE 100

static int read_integer(const char *prompt, int *value)
{
    char line[INPUT_SIZE];
    char *end;
    long parsed;

    printf("%s", prompt);
    fflush(stdout);
    if (fgets(line, sizeof line, stdin) == NULL) {
        return 0;
    }

    errno = 0;
    parsed = strtol(line, &end, 10);
    while (*end == ' ' || *end == '\t' || *end == '\n' || *end == '\r') {
        end++;
    }
    if (end == line || *end != '\0' || errno != 0 || parsed < 1 || parsed > 5) {
        return -1;
    }

    *value = (int)parsed;
    return 1;
}

static int read_amount(double *amount)
{
    char line[INPUT_SIZE];
    char *end;
    double parsed;

    printf("Amount: ");
    fflush(stdout);
    if (fgets(line, sizeof line, stdin) == NULL) {
        return 0;
    }

    parsed = strtod(line, &end);
    while (*end == ' ' || *end == '\t' || *end == '\n' || *end == '\r') {
        end++;
    }
    if (end == line || *end != '\0' || !isfinite(parsed) || parsed <= 0.0) {
        return -1;
    }

    *amount = parsed;
    return 1;
}

static void show_menu(void)
{
    printf("\nMobile Money Menu\n");
    printf("1. Deposit\n");
    printf("2. Withdraw\n");
    printf("3. Balance inquiry\n");
    printf("4. Transaction summary\n");
    printf("5. Exit\n");
}

int main(void)
{
    double balance = 0.0;
    double amount;
    int deposits = 0;
    int withdrawals = 0;
    int choice;
    int result;

    for (;;) {
        show_menu();
        result = read_integer("Choose an option: ", &choice);
        if (result == 0) {
            printf("\nSession ended.\n");
            break;
        }
        if (result < 0) {
            printf("Invalid choice. Enter a number from 1 to 5.\n");
            continue;
        }

        switch (choice) {
        case 1:
            result = read_amount(&amount);
            if (result == 0) {
                printf("\nSession ended.\n");
                return 0;
            }
            if (result < 0) {
                printf("Deposit rejected. Amount must be greater than 0.\n");
                continue;
            }
            if (amount > DBL_MAX - balance) {
                printf("Deposit rejected. Balance limit exceeded.\n");
                continue;
            }
            balance += amount;
            deposits++;
            printf("Deposit successful. Balance: %.2f\n", balance);
            break;
        case 2:
            result = read_amount(&amount);
            if (result == 0) {
                printf("\nSession ended.\n");
                return 0;
            }
            if (result < 0) {
                printf("Withdrawal rejected. Amount must be greater than 0.\n");
                continue;
            }
            if (amount > balance) {
                printf("Withdrawal rejected. Insufficient balance.\n");
                continue;
            }
            balance -= amount;
            withdrawals++;
            printf("Withdrawal successful. Balance: %.2f\n", balance);
            break;
        case 3:
            printf("Current balance: %.2f\n", balance);
            break;
        case 4:
            printf("Successful deposits: %d\n", deposits);
            printf("Successful withdrawals: %d\n", withdrawals);
            printf("Current balance: %.2f\n", balance);
            break;
        case 5:
            printf("Goodbye.\n");
            break;
        }

        if (choice == 5) {
            break;
        }
    }

    return 0;
}
