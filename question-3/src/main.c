#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#define MAX_ROUTES 100
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
    if (end == line || *end != '\0' || errno != 0 ||
        parsed < -2147483647L - 1 || parsed > 2147483647L) {
        return -1;
    }

    *value = (int)parsed;
    return 1;
}

static long long total_distance(const int distances[], int count)
{
    long long total = 0;
    int i;

    for (i = 0; i < count; i++) {
        total += distances[i];
    }
    return total;
}

static double average_distance(const int distances[], int count)
{
    return (double)total_distance(distances, count) / count;
}

static int longest_distance(const int distances[], int count)
{
    int longest = distances[0];
    int i;

    for (i = 1; i < count; i++) {
        if (distances[i] > longest) {
            longest = distances[i];
        }
    }
    return longest;
}

static int count_above_limit(const int distances[], int count, int limit)
{
    int matches = 0;
    int i;

    for (i = 0; i < count; i++) {
        if (distances[i] > limit) {
            matches++;
        }
    }
    return matches;
}

static long long recursive_sum(const int distances[], int count)
{
    if (count == 0) {
        return 0;
    }
    return distances[count - 1] + recursive_sum(distances, count - 1);
}

int main(void)
{
    int distances[MAX_ROUTES];
    int count;
    int limit;
    int i;
    int result;

    result = read_integer("Number of routes (1-100): ", &count);
    if (result == 0) {
        return 0;
    }
    if (result < 0 || count < 1 || count > MAX_ROUTES) {
        fprintf(stderr, "Enter a whole number from 1 to 100.\n");
        return 1;
    }

    for (i = 0; i < count; i++) {
        char prompt[40];
        snprintf(prompt, sizeof prompt, "Distance for route %d (km): ", i + 1);
        result = read_integer(prompt, &distances[i]);
        if (result == 0) {
            return 0;
        }
        if (result < 0 || distances[i] < 0) {
            fprintf(stderr, "Distances must be whole numbers at least 0.\n");
            return 1;
        }
    }

    result = read_integer("Count routes longer than (km): ", &limit);
    if (result == 0) {
        return 0;
    }
    if (result < 0 || limit < 0) {
        fprintf(stderr, "Enter a whole number at least 0.\n");
        return 1;
    }

    printf("\nDelivery Route Report\n");
    printf("Total distance: %lld km\n", total_distance(distances, count));
    printf("Average distance: %.2f km\n", average_distance(distances, count));
    printf("Longest route: %d km\n", longest_distance(distances, count));
    printf("Routes longer than %d km: %d\n", limit,
           count_above_limit(distances, count, limit));
    printf("Recursive sum: %lld km\n", recursive_sum(distances, count));
    return 0;
}
