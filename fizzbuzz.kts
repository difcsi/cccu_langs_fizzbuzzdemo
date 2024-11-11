fun fizzBuzz(n: Int): String {
    return when {
        n % 15 == 0 -> "FizzBuzz"
        n % 3 == 0 -> "Fizz"
        n % 5 == 0 -> "Buzz"
        else -> n.toString()
    }
}

for (i in 1..100) {
    println(fizzBuzz(i))
}
