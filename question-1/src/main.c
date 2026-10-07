#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INPUT_SIZE 100

static int read_number(const char *prompt, double *value)
{
    char line[INPUT_SIZE];
    char *end;
    double parsed;

    printf("%s", prompt);
    fflush(stdout);
    if (fgets(line, sizeof line, stdin) == NULL) {
        return 0;
    }

    parsed = strtod(line, &end);
    while (*end == ' ' || *end == '\t' || *end == '\n' || *end == '\r') {
        end++;
    }

    if (end == line || *end != '\0' || !isfinite(parsed)) {
        return -1;
    }

    *value = parsed;
    return 1;
}

static double calculate_index(double temperature, double turbidity)
{
    return 100.0 - (fabs(temperature - 25.0) + turbidity / 2.0);
}

static const char *classify_water(double index)
{
    if (index >= 80.0) {
        return "Good";
    }
    if (index >= 60.0) {
        return "Warning";
    }
    return "Critical";
}

int main(void)
{
    double temperature;
    double turbidity;
    double index;
    int result;

    result = read_number("Temperature (C): ", &temperature);
    if (result == 0) {
        return 0;
    }
    if (result < 0) {
        fprintf(stderr, "Invalid temperature. Enter one number.\n");
        return 1;
    }

    result = read_number("Turbidity (NTU): ", &turbidity);
    if (result == 0) {
        return 0;
    }
    if (result < 0 || turbidity < 0.0) {
        fprintf(stderr, "Invalid turbidity. Enter a number at least 0.\n");
        return 1;
    }

    index = calculate_index(temperature, turbidity);
    printf("\nWater Quality Report\n");
    printf("--------------------\n");
    printf("Temperature: %.1f C\n", temperature);
    printf("Turbidity:   %.1f NTU\n", turbidity);
    printf("Index:       %.1f\n", index);
    printf("Status:      %s\n", classify_water(index));
    return 0;
}
