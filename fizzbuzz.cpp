#include <iostream>
#include <ranges>
#include <string>

std::string fizzBuzz(int n) {
    if (n % 15 == 0) return "FizzBuzz";
    if (n % 3 == 0) return "Fizz";
    if (n % 5 == 0) return "Buzz";
    return std::to_string(n);
}

int main() {
    for (int i : std::views::iota(1, 101)) {
        std::cout << fizzBuzz(i) << '\n';
    }
    return 0;
}