#include <stdio.h>

const char* fizzBuzz(int n) {
    if (n % 15 == 0) return "FizzBuzz";
    if (n % 3 == 0) return "Fizz";
    if (n % 5 == 0) return "Buzz";
    static char buffer[12];
    snprintf(buffer, sizeof(buffer), "%d", n);
    return buffer;
}

int main() {
    for (int i = 1; i <= 100; i++) {
        printf("%s\n", fizzBuzz(i));
    }
    return 0;
}